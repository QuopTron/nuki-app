import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class FuenteContenido {
  Future<Map<String, dynamic>> leer(String ruta);
  Future<void> escribir(String ruta, Map<String, dynamic> documento);
  String get descripcion;
}

class ExcepcionRepositorio implements Exception {
  ExcepcionRepositorio(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

class FuenteGitEmulada implements FuenteContenido {
  FuenteGitEmulada._(this._prefs);
  final SharedPreferences _prefs;
  static const _prefijo = 'nuki_repo:';
  static const _claveSembrado = 'nuki_repo_sembrado';

  static Future<FuenteGitEmulada> crear() async {
    final fuente = FuenteGitEmulada._(await SharedPreferences.getInstance());
    await fuente._sembrar();
    return fuente;
  }

  @override
  String get descripcion => 'Git local emulado · rama main';

  Future<void> _sembrar() async {
    final base =
        jsonDecode(
              await rootBundle.loadString('assets/repositorio/indice.json'),
            )
            as Map<String, dynamic>;
    final baseDatos = ((base['datos'] as Map?) ?? const {}).map(
      (k, v) => MapEntry(k.toString(), v.toString()),
    );
    final localTexto = _prefs.getString('${_prefijo}indice.json');
    final local = localTexto == null
        ? <String, dynamic>{}
        : (jsonDecode(localTexto) as Map).cast<String, dynamic>();
    final localDatos = ((local['datos'] as Map?) ?? const {}).map(
      (k, v) => MapEntry(k.toString(), v.toString()),
    );
    var cambiado = localTexto == null;

    for (final entrada in baseDatos.entries) {
      final clave = '$_prefijo${entrada.value}';
      if (!_prefs.containsKey(clave)) {
        final texto = await rootBundle.loadString(
          'assets/repositorio/${entrada.value}',
        );
        await _prefs.setString(clave, texto);
      }
      if (!localDatos.containsKey(entrada.key)) {
        localDatos[entrada.key] = entrada.value;
        cambiado = true;
      }
    }

    if (cambiado) {
      local['datos'] = localDatos;
      local['metadatos'] = base['metadatos'];
      local['repositorio'] = base['repositorio'];
      await _prefs.setString('${_prefijo}indice.json', jsonEncode(local));
    }
    await _prefs.setBool(_claveSembrado, true);
  }

  @override
  Future<Map<String, dynamic>> leer(String ruta) async {
    final local = _prefs.getString('$_prefijo$ruta');
    final texto =
        local ?? await rootBundle.loadString('assets/repositorio/$ruta');
    return (jsonDecode(texto) as Map).cast<String, dynamic>();
  }

  @override
  Future<void> escribir(String ruta, Map<String, dynamic> documento) async {
    final actual = await leer(ruta);
    final metadatos =
        (actual['metadatos'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    metadatos['version'] = ((metadatos['version'] as num?)?.toInt() ?? 0) + 1;
    metadatos['actualizado'] = DateTime.now().toUtc().toIso8601String();
    metadatos['rama'] = 'main';
    metadatos['ruta'] = ruta;
    documento['metadatos'] = metadatos;
    await _prefs.setString(
      '$_prefijo$ruta',
      const JsonEncoder.withIndent('  ').convert(documento),
    );
  }

  Future<void> restablecer() async {
    final claves = _prefs
        .getKeys()
        .where((k) => k.startsWith(_prefijo))
        .toList();
    for (final clave in claves) {
      await _prefs.remove(clave);
    }
    await _prefs.remove(_claveSembrado);
    await _sembrar();
  }
}

class FuenteNukiCloud implements FuenteContenido {
  FuenteNukiCloud({
    required this.baseUrl,
    this.appKey = '',
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  final String baseUrl, appKey;
  final http.Client _cliente;

  @override
  String get descripcion => 'Nuki Cloud - Worker de Cloudflare';

  Map<String, String> get _cabeceras => {
    'Accept': 'application/json',
    if (appKey.isNotEmpty) 'X-Nuki-Key': appKey,
  };

  Uri _uri(String ruta) => Uri.parse(
    '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/api/repo/${Uri.encodeComponent(ruta)}',
  );

  @override
  Future<Map<String, dynamic>> leer(String ruta) async {
    final respuesta = await _cliente
        .get(_uri(ruta), headers: _cabeceras)
        .timeout(const Duration(seconds: 25));
    if (respuesta.statusCode != 200) {
      throw ExcepcionRepositorio(
        'No se pudo leer $ruta (${respuesta.statusCode}).',
      );
    }
    final json = jsonDecode(utf8.decode(respuesta.bodyBytes));
    if (json is! Map) {
      throw ExcepcionRepositorio('Respuesta invalida al leer $ruta.');
    }
    return json.cast<String, dynamic>();
  }

  @override
  Future<void> escribir(String ruta, Map<String, dynamic> documento) async {
    final respuesta = await _cliente
        .put(
          _uri(ruta),
          headers: {..._cabeceras, 'Content-Type': 'application/json'},
          body: jsonEncode(documento),
        )
        .timeout(const Duration(seconds: 30));
    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) {
      throw ExcepcionRepositorio(
        'No se pudo guardar $ruta (${respuesta.statusCode}): ${respuesta.body}',
      );
    }
  }
}

class FuenteGitHub implements FuenteContenido {
  FuenteGitHub({
    required this.propietario,
    required this.repositorio,
    required this.token,
    this.rama = 'main',
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  final String propietario, repositorio, token, rama;
  final http.Client _cliente;
  final Map<String, String> _shas = {};

  @override
  String get descripcion => 'GitHub · $propietario/$repositorio · $rama';

  Map<String, String> get _cabeceras => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };

  Uri _uri(String ruta) => Uri.https(
    'api.github.com',
    '/repos/$propietario/$repositorio/contents/$ruta',
    {'ref': rama},
  );

  @override
  Future<Map<String, dynamic>> leer(String ruta) async {
    final respuesta = await _cliente.get(_uri(ruta), headers: _cabeceras);
    if (respuesta.statusCode != 200) {
      throw ExcepcionRepositorio(
        'No se pudo leer $ruta (${respuesta.statusCode}).',
      );
    }
    final json = jsonDecode(respuesta.body) as Map<String, dynamic>;
    _shas[ruta] = json['sha'] as String? ?? '';
    final texto = utf8.decode(
      base64Decode((json['content'] as String? ?? '').replaceAll('\n', '')),
    );
    return (jsonDecode(texto) as Map).cast<String, dynamic>();
  }

  @override
  Future<void> escribir(String ruta, Map<String, dynamic> documento) async {
    Object? ultimoError;
    for (var intento = 0; intento < 3; intento++) {
      try {
        final actual = await leer(ruta);
        final metadatos =
            (actual['metadatos'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
        metadatos['version'] =
            ((metadatos['version'] as num?)?.toInt() ?? 0) + 1;
        metadatos['actualizado'] = DateTime.now().toUtc().toIso8601String();
        metadatos['rama'] = rama;
        metadatos['ruta'] = ruta;
        documento['metadatos'] = metadatos;
        final contenido = base64Encode(
          utf8.encode(const JsonEncoder.withIndent('  ').convert(documento)),
        );
        final respuesta = await _cliente.put(
          _uri(ruta).replace(queryParameters: const {}),
          headers: _cabeceras,
          body: jsonEncode({
            'message': 'nuki: actualizar $ruta',
            'content': contenido,
            'branch': rama,
            if (_shas[ruta]?.isNotEmpty ?? false) 'sha': _shas[ruta],
          }),
        );
        if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
          final json = jsonDecode(respuesta.body) as Map<String, dynamic>;
          _shas[ruta] =
              (json['content'] as Map?)?['sha'] as String? ?? _shas[ruta] ?? '';
          return;
        }
        ultimoError = 'HTTP ${respuesta.statusCode}: ${respuesta.body}';
        if (respuesta.statusCode != 409 && respuesta.statusCode != 422) {
          break;
        }
        await Future<void>.delayed(Duration(milliseconds: 300 * (intento + 1)));
      } catch (e) {
        ultimoError = e;
        await Future<void>.delayed(Duration(milliseconds: 300 * (intento + 1)));
      }
    }
    throw ExcepcionRepositorio('No se pudo guardar $ruta: $ultimoError');
  }
}

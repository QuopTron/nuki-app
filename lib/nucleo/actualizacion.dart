import 'dart:convert';

import 'package:http/http.dart' as http;

import 'configuracion_repo.dart';

class ActualizacionNuki {
  const ActualizacionNuki({
    required this.version,
    required this.apkUrl,
    required this.releaseUrl,
  });

  final String version;
  final String apkUrl;
  final String releaseUrl;

  bool get disponible => compararVersiones(version, versionNuki) > 0;

  static Future<ActualizacionNuki?> buscar() async {
    if (apiNuki.isEmpty) return null;
    try {
      final respuesta = await http
          .get(
            Uri.parse('${apiNuki.replaceAll(RegExp(r'/+$'), '')}/api/version'),
          )
          .timeout(const Duration(seconds: 8));
      if (respuesta.statusCode != 200) return null;
      final json = jsonDecode(utf8.decode(respuesta.bodyBytes));
      if (json is! Map) return null;
      final version = (json['version'] as String? ?? '').replaceAll('v', '');
      final apk = json['apk'] as String? ?? '';
      final release = json['release'] as String? ?? '';
      if (version.isEmpty || apk.isEmpty) return null;
      return ActualizacionNuki(
        version: version,
        apkUrl: apk,
        releaseUrl: release,
      );
    } catch (_) {
      return null;
    }
  }
}

int compararVersiones(String a, String b) {
  List<int> partes(String valor) => valor
      .split('.')
      .map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
      .toList();
  final pa = partes(a);
  final pb = partes(b);
  final total = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < total; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va.compareTo(vb);
  }
  return 0;
}

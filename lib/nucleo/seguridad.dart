import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

const _iteraciones = 24000;

String generarSal() {
  final azar = Random.secure();
  final bytes = List<int>.generate(18, (_) => azar.nextInt(256));
  return base64UrlEncode(bytes);
}

String hashClave(String clave, String sal) {
  var digest = sha256.convert(utf8.encode('$sal::$clave'));
  for (var i = 0; i < _iteraciones; i++) {
    digest = sha256.convert([...digest.bytes, ...utf8.encode(sal)]);
  }
  return digest.toString();
}

bool verificarClave(String clave, String sal, String hash) {
  if (hash.isEmpty || sal.isEmpty) return false;
  final calculado = hashClave(clave, sal);
  if (calculado.length != hash.length) return false;
  var diferencia = 0;
  for (var i = 0; i < calculado.length; i++) {
    diferencia |= calculado.codeUnitAt(i) ^ hash.codeUnitAt(i);
  }
  return diferencia == 0;
}

String inicialesDe(String nombre) {
  final partes = nombre
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (partes.isEmpty) return 'NU';
  if (partes.length == 1) {
    final texto = partes.first;
    return texto.substring(0, texto.length >= 2 ? 2 : 1).toUpperCase();
  }
  return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
}

String correoNormalizado(String correo) => correo.trim().toLowerCase();

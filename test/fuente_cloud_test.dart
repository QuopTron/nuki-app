import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nuki/nucleo/fuente_git.dart';

void main() {
  test('La fuente cloud lee y escribe usando el Worker con su clave', () async {
    final peticiones = <http.Request>[];
    final cliente = MockClient((solicitud) async {
      peticiones.add(solicitud);
      if (solicitud.method == 'GET') {
        return http.Response(
          jsonEncode({
            'datos': [
              {'id': 'm1'},
            ],
          }),
          200,
        );
      }
      return http.Response('{"ok":true}', 200);
    });
    final fuente = FuenteNukiCloud(
      baseUrl: 'https://nuki-api.example.workers.dev/',
      appKey: 'clave-prueba',
      cliente: cliente,
    );

    final leido = await fuente.leer('materias.json');
    await fuente.escribir('materias.json', leido);

    expect(peticiones, hasLength(2));
    expect(
      peticiones.first.url.toString(),
      'https://nuki-api.example.workers.dev/api/repo/materias.json',
    );
    expect(peticiones.first.headers['X-Nuki-Key'], 'clave-prueba');
    expect(peticiones.last.method, 'PUT');
    expect(peticiones.last.headers['Content-Type'], 'application/json');
  });
}

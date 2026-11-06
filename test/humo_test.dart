import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuki/main.dart';
import 'package:nuki/nucleo/configuracion_repo.dart';
import 'package:nuki/nucleo/repositorio_nuki.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _abrir(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  testWidgets('Nuki carga el repositorio y permite entrar como estudiante', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    final fuente = await crearFuenteContenido();
    await tester.pumpWidget(NukiApp(repositorio: RepositorioNuki(fuente)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Comenzar'), findsOneWidget);
    await tester.tap(find.text('Comenzar'));
    await _abrir(tester);
    expect(find.text('Bienvenido a Nuki'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'ana.ruiz@usfx.bo',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'nuki123');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await _abrir(tester);
    expect(find.textContaining('Hola, Ana'), findsOneWidget);
  });
}

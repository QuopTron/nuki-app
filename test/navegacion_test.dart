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
  testWidgets('El visor 3D y el panel de administración abren sin errores', (
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
    await tester.tap(find.text('Comenzar'));
    await _abrir(tester);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'carlos.m@usfx.bo',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'nuki123');
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await _abrir(tester);
    expect(find.textContaining('Hola, Carlos'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Modelos 3D'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Modelos 3D').first);
    await _abrir(tester);
    expect(find.text('Corazón humano'), findsWidgets);

    await tester.drag(find.byType(ListView).first, const Offset(0, -620));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Jugar'));
    await _abrir(tester);
    expect(find.text('Identificar estructuras'), findsOneWidget);
    expect(find.text('¿Qué estructura cumple esta función?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded).last);
    await _abrir(tester);
    expect(find.text('Corazón humano'), findsWidgets);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).last);
    await _abrir(tester);

    await tester.tap(find.text('Perfil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.drag(find.byType(ListView).first, const Offset(0, -700));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Panel de administración'));
    await _abrir(tester);
    expect(find.text('Administración'), findsOneWidget);
    expect(find.text('Gestión de usuarios'), findsOneWidget);
  });
}

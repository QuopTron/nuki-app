import 'package:flutter/material.dart';

abstract class Colores {
  static const fondo = Color(0xFF0B1329);
  static const fondoProfundo = Color(0xFF050A17);
  static const tarjeta = Color(0xFF131F37);
  static const tarjetaAlta = Color(0xFF1C2B4A);
  static const azul = Color(0xFF39B4E8);
  static const azulMedio = Color(0xFF168AC4);
  static const celeste = Color(0xFF67D4F5);
  static const cielo = Color(0xFF182A47);
  static const coral = Color(0xFFFF7675);
  static const rosa = Color(0xFFFF7675);
  static const turquesa = Color(0xFF62E6B4);
  static const verde = Color(0xFF62E6B4);
  static const texto = Color(0xFFF5F7FB);
  static const gris = Color(0xFF94A3B8);
  static const borde = Color(0xFF243553);
  static const ambar = Color(0xFFFFEAA7);
  static const violeta = Color(0xFF6C5CE7);
}

ThemeData temaNuki() {
  final esquema =
      ColorScheme.fromSeed(
        seedColor: Colores.azul,
        brightness: Brightness.dark,
      ).copyWith(
        primary: Colores.azul,
        onPrimary: Colores.fondo,
        secondary: Colores.violeta,
        onSecondary: Colors.white,
        surface: Colores.tarjeta,
        onSurface: Colores.texto,
        error: Colores.coral,
        outline: Colores.borde,
      );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: esquema,
  );
  final textos = base.textTheme
      .apply(bodyColor: Colores.texto, displayColor: Colores.texto)
      .copyWith(
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 27,
          height: 1.15,
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          height: 1.2,
        ),
        titleMedium: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Colores.texto,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          height: 1.35,
          color: Colores.gris,
        ),
        labelLarge: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      );
  return base.copyWith(
    scaffoldBackgroundColor: Colores.fondo,
    textTheme: textos,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colores.fondo,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: Colores.texto,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 22,
        color: Colores.texto,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colores.tarjeta,
      hintStyle: const TextStyle(color: Colores.gris, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colores.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colores.borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colores.azul, width: 1.6),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colores.azul,
        foregroundColor: Colores.fondo,
        minimumSize: const Size(0, 52),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colores.azul,
        minimumSize: const Size(0, 50),
        side: const BorderSide(color: Colores.azul, width: 1.2),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      backgroundColor: Colores.tarjeta,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colores.azul.withValues(alpha: .16),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (estados) => TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: estados.contains(WidgetState.selected)
              ? Colores.celeste
              : Colores.gris,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (estados) => IconThemeData(
          size: 23,
          color: estados.contains(WidgetState.selected)
              ? Colores.celeste
              : Colores.gris,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: Colores.tarjetaAlta,
      selectedColor: Colores.azul,
      side: const BorderSide(color: Colores.borde),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12.5,
        color: Colores.texto,
      ),
      secondaryLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.5,
        color: Colores.fondo,
      ),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    dividerColor: Colores.borde,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colores.tarjetaAlta,
      contentTextStyle: const TextStyle(
        color: Colores.texto,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: const DialogThemeData(backgroundColor: Colores.tarjeta),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colores.fondo,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colores.azul,
      foregroundColor: Colores.fondo,
    ),
  );
}

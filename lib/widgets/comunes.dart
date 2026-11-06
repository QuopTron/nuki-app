import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../nucleo/tema.dart';

part 'comunes_avatar.dart';
part 'comunes_seccion.dart';
part 'comunes_progreso.dart';

class Tarjeta extends StatelessWidget {
  const Tarjeta({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color = Colores.tarjeta,
    this.borde,
    this.sombra = true,
    this.radio = 20,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color color;
  final Color? borde;
  final bool sombra;
  final double radio;

  @override
  Widget build(BuildContext context) {
    final forma = BorderRadius.circular(radio);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: forma,
        border: Border.all(color: borde ?? Colores.borde.withValues(alpha: .7)),
        boxShadow: sombra
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .22),
                  blurRadius: 22,
                  offset: const Offset(0, 9),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: forma,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

class BarraAvance extends StatelessWidget {
  const BarraAvance({
    super.key,
    required this.valor,
    required this.color,
    this.alto = 7,
    this.fondo = Colores.cielo,
  });
  final double valor;
  final Color color;
  final double alto;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(alto),
      child: SizedBox(
        height: alto,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: fondo),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: valor.clamp(0.0, 1.0),
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: .65), color],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

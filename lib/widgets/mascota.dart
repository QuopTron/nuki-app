import 'package:flutter/material.dart';

class MascotaCelula extends StatelessWidget {
  const MascotaCelula({super.key, this.tamano = 160});
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Nuki, la célula mascota',
      image: true,
      child: Image.asset(
        'assets/images/fondoInicioDemas.png',
        width: tamano,
        height: tamano,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

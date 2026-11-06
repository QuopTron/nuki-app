import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../nucleo/tema.dart';

part 'visor3d_modelo.dart';

class Visor3D extends StatefulWidget {
  const Visor3D({
    super.key,
    required this.icono,
    required this.colores,
    this.tamano = 220,
    this.animar = true,
  });
  final IconData icono;
  final List<Color> colores;
  final double tamano;
  final bool animar;

  @override
  State<Visor3D> createState() => _Visor3DState();
}

class _Visor3DState extends State<Visor3D> with SingleTickerProviderStateMixin {
  late final AnimationController _control;
  double _giro = -.4;
  double _inclinacion = -.06;
  bool _automatico = true;

  @override
  void initState() {
    super.initState();
    _control = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (widget.animar) _control.repeat();
  }

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  void _arrastrar(DragUpdateDetails detalles) {
    setState(() {
      _automatico = false;
      _giro = (_giro + detalles.delta.dx * .012).clamp(-.95, .95);
      _inclinacion = (_inclinacion + detalles.delta.dy * .007).clamp(-.5, .5);
    });
  }

  void _reiniciar() => setState(() {
    _automatico = true;
    _giro = 0;
    _inclinacion = -.06;
  });

  @override
  Widget build(BuildContext context) {
    final color = widget.colores.first;
    return RepaintBoundary(
      child: GestureDetector(
        onPanUpdate: _arrastrar,
        onDoubleTap: _reiniciar,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _control,
          builder: (context, _) {
            final animando = _automatico && widget.animar;
            final giro = animando
                ? math.sin(_control.value * math.pi * 2) * .55
                : _giro;
            final inclinacion = animando
                ? math.sin(_control.value * math.pi * 4) * .07
                : _inclinacion;
            return SizedBox(
              width: widget.tamano,
              height: widget.tamano,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: widget.tamano * .82,
                    height: widget.tamano * .82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          color.withValues(alpha: .32),
                          color.withValues(alpha: .04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: widget.tamano * .07,
                    child: Container(
                      width: widget.tamano * .55,
                      height: widget.tamano * .11,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: RadialGradient(
                          colors: [
                            color.withValues(alpha: .55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .001)
                      ..rotateX(1.18),
                    child: Container(
                      width: widget.tamano * .72,
                      height: widget.tamano * .72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .22),
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .0016)
                      ..rotateY(giro)
                      ..rotateX(inclinacion),
                    child: _ModeloExtruido(
                      icono: widget.icono,
                      colores: widget.colores,
                      tamano: widget.tamano * .46,
                    ),
                  ),
                  Positioned(
                    top: widget.tamano * .27,
                    left: widget.tamano * .29,
                    child: IgnorePointer(
                      child: Container(
                        width: widget.tamano * .2,
                        height: widget.tamano * .12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: .22),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

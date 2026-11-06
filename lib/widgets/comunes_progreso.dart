part of 'comunes.dart';

class CirculoProgreso extends StatelessWidget {
  const CirculoProgreso({
    super.key,
    required this.valor,
    this.tamano = 104,
    this.color = Colores.turquesa,
    this.texto,
    this.detalle,
    this.grosor = 9,
  });
  final double valor;
  final double tamano;
  final Color color;
  final String? texto, detalle;
  final double grosor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamano,
      height: tamano,
      child: CustomPaint(
        painter: _PintorProgreso(
          valor: valor.clamp(0.0, 1.0),
          color: color,
          grosor: grosor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (texto != null)
                Text(
                  texto!,
                  style: TextStyle(
                    fontSize: tamano * .24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              if (detalle != null)
                Text(
                  detalle!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colores.gris,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PintorProgreso extends CustomPainter {
  _PintorProgreso({
    required this.valor,
    required this.color,
    required this.grosor,
  });
  final double valor;
  final Color color;
  final double grosor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.width - grosor) / 2,
    );
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = Colores.cielo
        ..style = PaintingStyle.stroke
        ..strokeWidth = grosor,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * valor,
      false,
      Paint()
        ..shader = SweepGradient(
          colors: [color.withValues(alpha: .55), color],
          startAngle: -math.pi / 2,
          endAngle: math.pi * 1.5,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = grosor
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _PintorProgreso old) =>
      old.valor != valor || old.color != color;
}

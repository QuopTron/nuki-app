part of 'visor3d.dart';

class _ModeloExtruido extends StatelessWidget {
  const _ModeloExtruido({
    required this.icono,
    required this.colores,
    required this.tamano,
  });
  final IconData icono;
  final List<Color> colores;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final claro = colores.first;
    final oscuro = colores.length > 1 ? colores.last : Colores.azul;
    return Stack(
      alignment: Alignment.center,
      children: [
        for (var i = 10; i > 0; i--)
          Transform.translate(
            offset: Offset(i * .7, i * 1.4),
            child: Icon(
              icono,
              size: tamano,
              color: Color.lerp(oscuro, Colors.black, i / 22)!,
            ),
          ),
        ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, claro, oscuro],
            stops: const [0, .45, 1],
          ).createShader(rect),
          child: Icon(
            icono,
            size: tamano,
            color: Colors.white,
            shadows: [
              Shadow(color: claro.withValues(alpha: .65), blurRadius: 26),
            ],
          ),
        ),
      ],
    );
  }
}

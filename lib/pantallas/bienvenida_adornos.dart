part of 'bienvenida.dart';

class _Mancha extends StatelessWidget {
  const _Mancha({required this.color, required this.tamano});
  final Color color;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _MiniAcceso extends StatelessWidget {
  const _MiniAcceso({required this.icono, required this.texto});
  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 15, color: Colores.azulMedio),
        const SizedBox(width: 4),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: Colores.gris,
          ),
        ),
      ],
    );
  }
}

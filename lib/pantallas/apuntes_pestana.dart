part of 'apuntes.dart';

class _Pestana extends StatelessWidget {
  const _Pestana({
    required this.texto,
    required this.activa,
    required this.onTap,
  });
  final String texto;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activa ? Colores.azul : Colores.tarjeta,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: activa ? Colores.azul : Colores.borde),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: activa ? Colores.fondo : Colores.gris,
            ),
          ),
        ),
      ),
    );
  }
}

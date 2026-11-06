part of 'cuestionario.dart';

enum _EstadoOpcion { normal, correcta, incorrecta, apagada }

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.letra,
    required this.texto,
    required this.estado,
    required this.onTap,
  });
  final String letra, texto;
  final _EstadoOpcion estado;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (color, fondo, icono) = switch (estado) {
      _EstadoOpcion.correcta => (
        Colores.turquesa,
        Colores.turquesa.withValues(alpha: .12),
        Icons.check_circle_rounded,
      ),
      _EstadoOpcion.incorrecta => (
        Colores.coral,
        Colores.coral.withValues(alpha: .10),
        Icons.cancel_rounded,
      ),
      _EstadoOpcion.apagada => (Colores.gris, Colores.tarjeta, null),
      _EstadoOpcion.normal => (Colores.azul, Colores.tarjeta, null),
    };
    return Tarjeta(
      onTap: onTap,
      padding: const EdgeInsets.all(13),
      borde: color.withValues(alpha: .4),
      sombra: estado == _EstadoOpcion.normal,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              letra,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: color,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
          if (icono != null) Icon(icono, color: color, size: 20),
        ],
      ),
    );
  }
}

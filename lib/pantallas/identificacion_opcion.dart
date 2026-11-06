part of 'identificacion.dart';

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.estructura,
    required this.seleccionada,
    required this.esCorrecta,
    required this.revelada,
    required this.onTap,
  });
  final EstructuraAnatomica estructura;
  final bool seleccionada, esCorrecta, revelada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borde = revelada && esCorrecta
        ? Colores.turquesa
        : revelada && seleccionada
        ? Colores.coral
        : Colores.borde;
    final fondo = revelada && esCorrecta
        ? Colores.turquesa.withValues(alpha: .08)
        : revelada && seleccionada
        ? Colores.coral.withValues(alpha: .08)
        : Colors.white;
    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: revelada ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borde,
              width: revelada && (esCorrecta || seleccionada) ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                revelada && esCorrecta
                    ? Icons.check_circle_rounded
                    : revelada && seleccionada
                    ? Icons.cancel_rounded
                    : Icons.circle_outlined,
                size: 19,
                color: revelada && esCorrecta
                    ? Colores.turquesa
                    : revelada && seleccionada
                    ? Colores.coral
                    : Colores.gris,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  estructura.nombre,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of 'perfil.dart';

class _Logros extends StatelessWidget {
  const _Logros({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    final logros = [
      (
        icono: Icons.emoji_events_rounded,
        titulo: 'Primer paso',
        color: Colores.ambar,
        activo: estado.resultados.isNotEmpty,
      ),
      (
        icono: Icons.local_fire_department_rounded,
        titulo: 'Racha de 7',
        color: Colores.coral,
        activo: estado.racha >= 7,
      ),
      (
        icono: Icons.favorite_rounded,
        titulo: 'Anatomía',
        color: Colores.celeste,
        activo: estado.modelos.isNotEmpty,
      ),
    ];
    return Tarjeta(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logros obtenidos',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final logro in logros) ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: logro.activo
                          ? logro.color.withValues(alpha: .12)
                          : Colores.fondo,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: logro.activo
                            ? logro.color.withValues(alpha: .4)
                            : Colores.borde,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          logro.icono,
                          color: logro.activo ? logro.color : Colores.gris,
                          size: 24,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          logro.titulo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: logro.activo ? Colores.texto : Colores.gris,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (logro != logros.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

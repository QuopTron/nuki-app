part of 'perfil.dart';

class _Progreso extends StatelessWidget {
  const _Progreso({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi progreso',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CirculoProgreso(
                valor: (estado.promedio / 10).clamp(0, 1),
                tamano: 112,
                color: Colores.turquesa,
                texto: estado.promedio > 0
                    ? estado.promedio.toStringAsFixed(1)
                    : '—',
                detalle: 'promedio',
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Promedio general',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      estado.promedio >= 8
                          ? '¡Excelente constancia!'
                          : estado.promedio >= 6
                          ? 'Sigue así, vas bien.'
                          : 'Un repaso más y subes.',
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colores.ambar,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${estado.racha} días de racha',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Colores.gris,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.task_alt_rounded,
                          color: Colores.turquesa,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${estado.resultados.length} evaluaciones',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Colores.gris,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

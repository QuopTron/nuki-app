part of 'cuestionario.dart';

class _Resultado extends StatelessWidget {
  const _Resultado({
    super.key,
    required this.evaluacion,
    required this.aciertos,
    required this.promedio,
    required this.onRepetir,
    required this.onSalir,
    required this.onRevisar,
  });
  final Evaluacion evaluacion;
  final int aciertos;
  final double promedio;
  final VoidCallback onRepetir, onSalir, onRevisar;

  @override
  Widget build(BuildContext context) {
    final total = evaluacion.preguntas.length;
    final nota = (aciertos / total) * 10;
    final mensaje = nota >= 9
        ? '¡Excelente trabajo!'
        : nota >= 7
        ? '¡Muy bien!'
        : nota >= 5
        ? 'Vas por buen camino'
        : 'Repasa y vuelve a intentarlo';
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Tarjeta(
          color: Colores.azulMedio,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CirculoProgreso(
                valor: aciertos / total,
                tamano: 140,
                grosor: 11,
                color: Colores.turquesa,
                texto: '$aciertos/$total',
                detalle: 'aciertos',
              ),
              const SizedBox(height: 16),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                evaluacion.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 11.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Dato(
                icono: Icons.speed_rounded,
                valor: nota.toStringAsFixed(1),
                etiqueta: 'Nota /10',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Dato(
                icono: Icons.insights_rounded,
                valor: promedio.toStringAsFixed(1),
                etiqueta: 'Promedio',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Dato(
                icono: Icons.cloud_done_rounded,
                valor: 'Git',
                etiqueta: 'Guardado',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: onRepetir,
            icon: const Icon(Icons.replay_rounded),
            label: const Text('Volver a intentar'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onRevisar,
            icon: const Icon(Icons.fact_check_outlined, size: 17),
            label: const Text('Revisar respuestas'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: onSalir,
            child: const Text('Volver a evaluaciones'),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'El resultado ya forma parte de tu perfil y se sincronizó con el repositorio.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colores.gris, fontSize: 10.5),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });
  final IconData icono;
  final String valor, etiqueta;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icono, color: Colores.azulMedio, size: 19),
          const SizedBox(height: 5),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
          ),
          Text(
            etiqueta,
            style: const TextStyle(
              color: Colores.gris,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

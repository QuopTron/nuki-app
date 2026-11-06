part of 'cuestionario.dart';

class _CuerpoPregunta extends StatelessWidget {
  const _CuerpoPregunta({
    super.key,
    required this.evaluacion,
    required this.indice,
    required this.pregunta,
    required this.seleccion,
    required this.respondida,
    required this.contestadas,
    required this.onSeleccion,
    required this.onAvanzar,
    required this.onRetroceder,
    required this.onMapa,
  });
  final Evaluacion evaluacion;
  final int indice, contestadas;
  final Pregunta pregunta;
  final int? seleccion;
  final bool respondida;
  final ValueChanged<int> onSeleccion;
  final VoidCallback onAvanzar, onMapa;
  final VoidCallback? onRetroceder;

  @override
  Widget build(BuildContext context) {
    final correcta = seleccion == pregunta.correcta;
    final total = evaluacion.preguntas.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: BarraAvance(
                valor: contestadas / total,
                color: evaluacion.color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$contestadas/$total',
              style: const TextStyle(
                color: Colores.gris,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: onMapa,
              icon: const Icon(
                Icons.grid_view_rounded,
                size: 19,
                color: Colores.azulMedio,
              ),
              tooltip: 'Mapa de preguntas',
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Tarjeta(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Etiqueta(
                    texto: 'PREGUNTA ${indice + 1}',
                    color: evaluacion.color,
                  ),
                  const Spacer(),
                  Text(
                    '${evaluacion.minutos} min',
                    style: const TextStyle(color: Colores.gris, fontSize: 10.5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                pregunta.enunciado,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < pregunta.opciones.length; i++) ...[
          _Opcion(
            letra: String.fromCharCode(65 + i),
            texto: pregunta.opciones[i],
            estado: !respondida
                ? _EstadoOpcion.normal
                : i == pregunta.correcta
                ? _EstadoOpcion.correcta
                : i == seleccion
                ? _EstadoOpcion.incorrecta
                : _EstadoOpcion.apagada,
            onTap: () => onSeleccion(i),
          ),
          const SizedBox(height: 9),
        ],
        if (respondida) ...[
          const SizedBox(height: 8),
          Tarjeta(
            color: (correcta ? Colores.turquesa : Colores.coral).withValues(
              alpha: .10,
            ),
            sombra: false,
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  correcta ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: correcta ? Colores.turquesa : Colores.coral,
                  size: 20,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        correcta ? '¡Correcto!' : 'Respuesta incorrecta',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          color: correcta ? Colores.turquesa : Colores.coral,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pregunta.explicacion,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Colores.gris,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        Row(
          children: [
            if (onRetroceder != null) ...[
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: onRetroceder,
                    icon: const Icon(Icons.arrow_back_rounded, size: 17),
                    label: const Text('Anterior'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: onAvanzar,
                  style: FilledButton.styleFrom(
                    backgroundColor: respondida
                        ? evaluacion.color
                        : Colores.borde,
                  ),
                  child: Text(
                    indice >= total - 1 ? 'Enviar respuestas' : 'Siguiente',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Puedes cambiar tus respuestas antes de enviar. Se guardan al finalizar.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colores.gris.withValues(alpha: .8),
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

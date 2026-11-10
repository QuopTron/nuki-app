part of 'cuestionario.dart';

Future<void> _hojaMapa(
  BuildContext context,
  Evaluacion evaluacion,
  List<int?> respuestas,
  ValueChanged<int> onIr,
) {
  final contestadas = respuestas.where((r) => r != null).length;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mapa de preguntas',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            Text(
              '$contestadas de ${respuestas.length} respondidas',
              style: const TextStyle(fontSize: 11, color: Colores.gris),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                for (var i = 0; i < respuestas.length; i++)
                  InkWell(
                    onTap: () {
                      onIr(i);
                      Navigator.pop(contexto);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: respuestas[i] == null
                            ? Colores.cielo
                            : evaluacion.color.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: respuestas[i] == null
                              ? Colores.borde
                              : evaluacion.color,
                        ),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: respuestas[i] == null
                              ? Colores.gris
                              : evaluacion.color,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colores.borde),
                SizedBox(width: 5),
                Text(
                  'Pendiente',
                  style: TextStyle(fontSize: 10, color: Colores.gris),
                ),
                SizedBox(width: 14),
                Icon(Icons.circle, size: 10, color: Colores.azulMedio),
                SizedBox(width: 5),
                Text(
                  'Respondida',
                  style: TextStyle(fontSize: 10, color: Colores.gris),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _hojaRevision(
  BuildContext context,
  Evaluacion evaluacion,
  List<int?> respuestas,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => DraggableScrollableSheet(
      initialChildSize: .88,
      minChildSize: .5,
      maxChildSize: .96,
      expand: false,
      builder: (context, scroll) => Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colores.borde,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 10, 6),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Revisión de respuestas',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: evaluacion.preguntas.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final pregunta = evaluacion.preguntas[i];
                final elegida = respuestas[i];
                final correcta = elegida == pregunta.correcta;
                return Tarjeta(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            correcta
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            size: 17,
                            color: correcta ? Colores.turquesa : Colores.coral,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Pregunta ${i + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colores.gris,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pregunta.enunciado,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tu respuesta: ${elegida == null ? 'sin responder' : pregunta.opciones[elegida]}',
                        style: TextStyle(
                          fontSize: 11,
                          color: correcta ? Colores.turquesa : Colores.coral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Correcta: ${pregunta.opciones[pregunta.correcta]}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colores.gris,
                        ),
                      ),
                      if (pregunta.explicacion.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          pregunta.explicacion,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Colores.gris,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

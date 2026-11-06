part of 'detalle_materia.dart';

class _RecursosMateria extends StatelessWidget {
  const _RecursosMateria({required this.recursos});
  final List<Recurso> recursos;

  @override
  Widget build(BuildContext context) {
    if (recursos.isEmpty) {
      return const Tarjeta(
        child: Text(
          'No hay recursos para esta materia todavía.',
          style: TextStyle(color: Colores.gris),
        ),
      );
    }
    return Column(
      children: [
        for (final recurso in recursos)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Tarjeta(
              onTap: () =>
                  mostrarMensaje(context, 'Abriendo ${recurso.titulo}...'),
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  IconoMateria(
                    icono: recurso.icono,
                    color: recurso.color,
                    tamano: 40,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recurso.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${recurso.tipo} · ${recurso.tamano}',
                          style: const TextStyle(
                            color: Colores.gris,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.download_rounded,
                    color: Colores.azulMedio,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _EvaluacionesMateria extends StatelessWidget {
  const _EvaluacionesMateria({required this.evaluaciones});
  final List<Evaluacion> evaluaciones;

  @override
  Widget build(BuildContext context) {
    if (evaluaciones.isEmpty) {
      return const Tarjeta(
        child: Text(
          'Aún no hay evaluaciones para esta materia.',
          style: TextStyle(color: Colores.gris),
        ),
      );
    }
    return Column(
      children: [
        for (final evaluacion in evaluaciones)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Tarjeta(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  IconoMateria(
                    icono: evaluacion.icono,
                    color: evaluacion.color,
                    tamano: 42,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evaluacion.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${evaluacion.cantidad} preguntas · ${evaluacion.minutos} min',
                          style: const TextStyle(
                            color: Colores.gris,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CuestionarioPantalla(evaluacion: evaluacion),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    child: const Text('Iniciar'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

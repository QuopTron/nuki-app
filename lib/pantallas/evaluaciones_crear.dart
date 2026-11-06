part of 'evaluaciones.dart';

class _DatosEvaluacion {
  const _DatosEvaluacion(
    this.titulo,
    this.materia,
    this.tipo,
    this.minutos,
    this.preguntas,
  );
  final String titulo, materia, tipo;
  final int minutos;
  final List<Pregunta> preguntas;
}

Future<void> _crearEvaluacion(BuildContext context, EstadoNuki estado) async {
  if (!estado.puedeGestionar) {
    mostrarMensaje(
      context,
      'Solo docentes y administradores pueden crear evaluaciones.',
    );
    return;
  }
  if (estado.materias.isEmpty) {
    mostrarMensaje(context, 'No hay materias en el repositorio.');
    return;
  }
  final datos = await showModalBottomSheet<_DatosEvaluacion>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaEvaluacion(estado: estado),
  );
  if (datos == null) return;
  await estado.crearEvaluacion(
    titulo: datos.titulo,
    materia: datos.materia,
    tipo: datos.tipo,
    minutos: datos.minutos,
    preguntas: datos.preguntas,
  );
  if (context.mounted) {
    mostrarMensaje(context, 'Evaluación creada en evaluaciones.json.');
  }
}

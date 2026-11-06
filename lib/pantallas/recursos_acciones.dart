part of 'recursos.dart';

Future<void> _subirRecurso(BuildContext context, EstadoNuki estado) async {
  if (!estado.puedeGestionar) {
    mostrarMensaje(
      context,
      'Solo docentes y administradores pueden subir recursos.',
    );
    return;
  }
  if (estado.materias.isEmpty) {
    mostrarMensaje(context, 'No hay materias en el repositorio.');
    return;
  }
  final datos = await showModalBottomSheet<_DatosRecurso>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaRecurso(estado: estado),
  );
  if (datos == null) return;
  await estado.agregarRecurso(
    titulo: datos.titulo,
    materia: datos.materia,
    tipo: datos.tipo,
    descripcion: datos.descripcion,
    tamano: formatearPeso(datos.bytes.length),
    archivo: base64Encode(datos.bytes),
    archivoNombre: datos.nombreArchivo,
  );
  if (context.mounted) {
    mostrarMensaje(context, 'Recurso subido y versionado en recursos.json.');
  }
}

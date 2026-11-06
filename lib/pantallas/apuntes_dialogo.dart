part of 'apuntes.dart';

class _DatosApunte {
  const _DatosApunte(
    this.titulo,
    this.materia,
    this.contenido,
    this.bytes,
    this.nombreArchivo,
  );
  final String titulo, materia, contenido;
  final Uint8List? bytes;
  final String? nombreArchivo;
}

Future<void> _crearApunte(BuildContext context, EstadoNuki estado) async {
  if (!estado.puedeEscribir) {
    mostrarMensaje(context, 'Inicia sesión para crear apuntes.');
    return;
  }
  if (estado.materias.isEmpty) {
    mostrarMensaje(context, 'No hay materias en el repositorio.');
    return;
  }
  final datos = await showModalBottomSheet<_DatosApunte>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaApunte(estado: estado),
  );
  if (datos == null) return;
  await estado.agregarApunte(
    materia: datos.materia,
    titulo: datos.titulo,
    contenido: datos.contenido,
    archivo: datos.bytes == null ? null : base64Encode(datos.bytes!),
    archivoNombre: datos.nombreArchivo,
  );
  if (context.mounted) {
    mostrarMensaje(context, 'Apunte guardado en apuntes.json.');
  }
}

Future<void> _editarApunte(
  BuildContext context,
  EstadoNuki estado,
  Apunte apunte,
) async {
  final titulo = TextEditingController(text: apunte.titulo);
  final contenido = TextEditingController(text: apunte.contenido);
  final guardar = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Editar apunte',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titulo,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Título'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: contenido,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Contenido del apunte'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (titulo.text.trim().isEmpty) return;
            Navigator.pop(contexto, true);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
  if (guardar == true) {
    await estado.editarApunte(
      apunte,
      titulo: titulo.text.trim(),
      contenido: contenido.text.trim(),
    );
    if (context.mounted) mostrarMensaje(context, 'Apunte actualizado.');
  }
  titulo.dispose();
  contenido.dispose();
}

part of 'foro.dart';

Future<void> _menuPublicacion(
  BuildContext context,
  EstadoNuki estado,
  Publicacion publicacion,
) async {
  final propio = estado.esPropio(publicacion.autorId);
  final puedeEditar = estado.puedeEditar(publicacion.autorId);
  final accion = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.person_rounded, color: Colores.azulMedio),
            title: Text(publicacion.autor),
            subtitle: Text(
              '${publicacion.reacciones} reacciones · ${publicacion.comentarios.length} respuestas',
            ),
          ),
          const Divider(height: 1),
          if (puedeEditar && propio)
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: Colores.azulMedio),
              title: const Text('Editar publicación'),
              onTap: () => Navigator.pop(contexto, 'editar'),
            ),
          ListTile(
            leading: const Icon(
              Icons.favorite_border_rounded,
              color: Colores.coral,
            ),
            title: const Text('Ver reacciones'),
            onTap: () => Navigator.pop(contexto, 'reacciones'),
          ),
          if (estado.puedeModerar)
            ListTile(
              leading: Icon(
                publicacion.fijada
                    ? Icons.push_pin_outlined
                    : Icons.push_pin_rounded,
                color: Colores.ambar,
              ),
              title: Text(
                publicacion.fijada ? 'Quitar de fijadas' : 'Fijar publicación',
              ),
              onTap: () => Navigator.pop(contexto, 'fijar'),
            ),
          if (!propio && !publicacion.reportes.contains(estado.uid))
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colores.ambar),
              title: const Text('Reportar publicación'),
              onTap: () => Navigator.pop(contexto, 'reportar'),
            ),
          if (puedeEditar)
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: Colores.coral,
              ),
              title: const Text('Eliminar publicación'),
              onTap: () => Navigator.pop(contexto, 'eliminar'),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (!context.mounted || accion == null) return;
  switch (accion) {
    case 'editar':
      await _editarPublicacion(context, estado, publicacion);
    case 'reacciones':
      await _hojaReacciones(context, estado, publicacion);
    case 'fijar':
      await estado.alternarFijada(publicacion);
    case 'reportar':
      await _reportarPublicacion(context, estado, publicacion);
    case 'eliminar':
      final confirmar = await confirmarNuki(
        context,
        titulo: '¿Eliminar publicación?',
        mensaje: 'Se quitará del foro y del archivo foro.json.',
        confirmar: 'Eliminar',
      );
      if (confirmar) {
        await estado.eliminarPublicacion(publicacion);
        if (context.mounted) mostrarMensaje(context, 'Publicación eliminada.');
      }
  }
}

Future<void> _editarPublicacion(
  BuildContext context,
  EstadoNuki estado,
  Publicacion publicacion,
) async {
  final texto = TextEditingController(text: publicacion.contenido);
  final guardar = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Editar publicación',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: TextField(
        controller: texto,
        autofocus: true,
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (texto.text.trim().isEmpty) return;
            Navigator.pop(contexto, true);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
  if (guardar == true) {
    await estado.editarPublicacion(publicacion, texto.text.trim());
    if (context.mounted) {
      mostrarMensaje(context, 'Publicación actualizada en el repositorio.');
    }
  }
  texto.dispose();
}

Future<void> _reportarPublicacion(
  BuildContext context,
  EstadoNuki estado,
  Publicacion publicacion,
) async {
  const motivos = ['Contenido ofensivo', 'Información falsa', 'Spam', 'Otro'];
  var motivo = motivos.first;
  final enviar = await showDialog<bool>(
    context: context,
    builder: (contexto) => StatefulBuilder(
      builder: (contexto, setStateDialogo) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Reportar publicación'),
        content: RadioGroup<String>(
          groupValue: motivo,
          onChanged: (valor) => setStateDialogo(() => motivo = valor ?? motivo),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Un moderador revisará el contenido reportado.',
                style: TextStyle(fontSize: 12.5),
              ),
              const SizedBox(height: 12),
              for (final opcion in motivos)
                RadioListTile<String>(
                  value: opcion,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(opcion, style: const TextStyle(fontSize: 12.5)),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Reportar'),
          ),
        ],
      ),
    ),
  );
  if (enviar == true) {
    await estado.reportarPublicacion(publicacion, motivo);
    if (context.mounted) {
      mostrarMensaje(context, 'Reporte enviado al panel de administración.');
    }
  }
}

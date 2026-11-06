part of 'recursos.dart';

Future<void> _abrirRecurso(
  BuildContext context,
  EstadoNuki estado,
  Recurso recurso,
) async {
  final bytes = _bytesDe(recurso.archivo);
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconoMateria(
                  icono: recurso.icono,
                  color: recurso.color,
                  tamano: 48,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recurso.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${recurso.tipo} · ${recurso.tamano} · ${recurso.materia}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colores.gris,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (recurso.descripcion.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                recurso.descripcion,
                style: const TextStyle(fontSize: 12.5, height: 1.45),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Autor: ${recurso.autor}',
              style: const TextStyle(fontSize: 11, color: Colores.gris),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: bytes == null
                    ? () => mostrarMensaje(
                        contexto,
                        'Este recurso de demostración no incluye un archivo adjunto.',
                      )
                    : () async {
                        final error = await abrirArchivo(
                          bytes,
                          recurso.archivoNombre ?? '${recurso.titulo}.pdf',
                        );
                        if (error != null && contexto.mounted) {
                          mostrarMensaje(contexto, error);
                        }
                      },
                icon: Icon(
                  bytes == null
                      ? Icons.info_outline_rounded
                      : Icons.open_in_new_rounded,
                  size: 18,
                ),
                label: Text(
                  bytes == null
                      ? 'Sin archivo adjunto'
                      : 'Abrir ${recurso.archivoNombre ?? 'archivo'}',
                ),
              ),
            ),
            if (estado.puedeEditar(recurso.autorId)) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirmar = await confirmarNuki(
                      contexto,
                      titulo: '¿Eliminar recurso?',
                      mensaje: '${recurso.titulo} se quitará de recursos.json.',
                      confirmar: 'Eliminar',
                    );
                    if (!confirmar) return;
                    await estado.eliminarRecurso(recurso);
                    if (contexto.mounted) Navigator.pop(contexto);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: const Text('Eliminar recurso'),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

Uint8List? _bytesDe(String? codificado) {
  if (codificado == null || codificado.isEmpty) return null;
  try {
    return base64Decode(codificado);
  } catch (_) {
    return null;
  }
}

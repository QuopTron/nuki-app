part of 'apuntes.dart';

Future<void> _abrirApunte(
  BuildContext context,
  EstadoNuki estado,
  Apunte apunte,
) async {
  Uint8List? bytes;
  if (apunte.archivo != null) {
    try {
      bytes = base64Decode(apunte.archivo!);
    } catch (_) {
      bytes = null;
    }
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconoMateria(
                  icono: apunte.icono,
                  color: apunte.color,
                  tamano: 46,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apunte.titulo,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${apunte.materia} · ${apunte.fecha}',
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
            const SizedBox(height: 14),
            if (apunte.contenido.isEmpty)
              const Text(
                'Sin contenido escrito. Puedes editar el apunte para agregarlo.',
                style: TextStyle(fontSize: 12, color: Colores.gris),
              )
            else
              Text(
                apunte.contenido,
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            if (bytes != null) ...[
              const SizedBox(height: 16),
              Tarjeta(
                onTap: () async {
                  final error = await abrirArchivo(
                    bytes!,
                    apunte.archivoNombre ?? 'apunte.pdf',
                  );
                  if (error != null && contexto.mounted) {
                    mostrarMensaje(contexto, error);
                  }
                },
                padding: const EdgeInsets.all(12),
                color: Colores.cielo,
                sombra: false,
                child: Row(
                  children: [
                    Icon(
                      iconoDeArchivo(apunte.archivoNombre ?? ''),
                      color: colorDeArchivo(apunte.archivoNombre ?? ''),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        apunte.archivoNombre ?? 'Adjunto',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 17,
                      color: Colores.azulMedio,
                    ),
                  ],
                ),
              ),
            ],
            if (estado.puedeEditar(apunte.autorId)) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        Navigator.pop(contexto);
                        await _editarApunte(context, estado, apunte);
                      },
                      icon: const Icon(Icons.edit_rounded, size: 17),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        final confirmar = await confirmarNuki(
                          contexto,
                          titulo: '¿Eliminar apunte?',
                          mensaje:
                              '${apunte.titulo} se quitará de apuntes.json.',
                          confirmar: 'Eliminar',
                        );
                        if (!confirmar) return;
                        await estado.eliminarApunte(apunte);
                        if (contexto.mounted) Navigator.pop(contexto);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colores.coral,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 17),
                      label: const Text('Eliminar'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

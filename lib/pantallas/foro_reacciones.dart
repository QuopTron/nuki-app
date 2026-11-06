part of 'foro.dart';

Future<void> _hojaReacciones(
  BuildContext context,
  EstadoNuki estado,
  Publicacion publicacion,
) async {
  final nombres = <String>[];
  for (final id in publicacion.reaccionantes) {
    for (final cuenta in estado.usuarios) {
      if (cuenta.id == id) nombres.add(cuenta.nombre);
    }
  }
  final anonimas = publicacion.reacciones - nombres.length;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reacciones (${publicacion.reacciones})',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            for (final nombre in nombres)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: Colores.coral,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(nombre, style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
              ),
            if (anonimas > 0)
              Text(
                '$anonimas reacciones de la comunidad',
                style: const TextStyle(fontSize: 11.5, color: Colores.gris),
              ),
            if (nombres.isEmpty && anonimas == 0)
              const Text(
                'Todavía no hay reacciones.',
                style: TextStyle(fontSize: 12, color: Colores.gris),
              ),
          ],
        ),
      ),
    ),
  );
}

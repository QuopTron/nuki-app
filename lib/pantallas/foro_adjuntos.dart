part of 'foro.dart';

class _ImagenPublicacion extends StatelessWidget {
  const _ImagenPublicacion({required this.datos, this.nombre});
  final String datos;
  final String? nombre;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes;
    try {
      bytes = base64Decode(datos);
    } catch (_) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colores.fondo,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          'No se pudo mostrar la imagen.',
          style: TextStyle(color: Colores.gris, fontSize: 11),
        ),
      );
    }
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: .8,
                  maxScale: 5,
                  child: Center(
                    child: Image.memory(bytes, fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Cerrar',
                ),
              ),
              if (nombre != null)
                Positioned(
                  top: 48,
                  left: 16,
                  child: Text(
                    nombre!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Image.memory(
              bytes,
              width: double.infinity,
              height: 185,
              fit: BoxFit.cover,
              cacheWidth: 1000,
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.fullscreen_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Ampliar',
                      style: TextStyle(color: Colors.white, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccionForo extends StatelessWidget {
  const _AccionForo({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.onLongPress,
    this.color,
  });
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tono = color ?? Colores.gris;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Row(
            children: [
              Icon(icono, size: 17, color: tono),
              const SizedBox(width: 5),
              Text(
                texto,
                style: TextStyle(
                  fontSize: 11,
                  color: tono,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of 'admin.dart';

class _PublicacionReporteAdmin extends StatelessWidget {
  const _PublicacionReporteAdmin({required this.publicacion});
  final Publicacion publicacion;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    return Tarjeta(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarNuki(
                iniciales: publicacion.iniciales,
                tamano: 34,
                colores: const [Colores.coral, Color(0xFF8E1B24)],
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publicacion.autor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      '${publicacion.materia} · ${publicacion.reportes.length} reportes',
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              Etiqueta(
                texto: '${publicacion.reportes.length}',
                color: Colores.ambar,
                icono: Icons.flag_rounded,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            publicacion.contenido,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => estado.descartarReportes(publicacion),
                  icon: const Icon(Icons.visibility_off_rounded, size: 15),
                  label: const Text(
                    'Descartar',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    final confirmar = await confirmarNuki(
                      context,
                      titulo: '¿Eliminar publicación reportada?',
                      mensaje:
                          'El contenido de ${publicacion.autor} se quitará del foro.',
                      confirmar: 'Eliminar',
                    );
                    if (confirmar) {
                      await estado.eliminarPublicacion(publicacion);
                    }
                  },
                  style: FilledButton.styleFrom(backgroundColor: Colores.coral),
                  icon: const Icon(Icons.delete_outline_rounded, size: 15),
                  label: const Text('Eliminar', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

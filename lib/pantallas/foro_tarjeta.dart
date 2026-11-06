part of 'foro.dart';

class _PublicacionTarjeta extends StatelessWidget {
  const _PublicacionTarjeta({required this.publicacion});
  final Publicacion publicacion;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final leGusta = estado.usuario != null && publicacion.leGusta(estado.uid);
    return Tarjeta(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarNuki(
                iniciales: publicacion.iniciales,
                tamano: 38,
                colores: const [Colores.celeste, Colores.azulMedio],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            publicacion.autor,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (publicacion.fijada) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.push_pin_rounded,
                            size: 13,
                            color: Colores.ambar,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${publicacion.tiempo} · ${publicacion.materia}${publicacion.editada ? ' · editada' : ''}',
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _menuPublicacion(context, estado, publicacion),
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: Colores.gris,
                  size: 20,
                ),
                visualDensity: VisualDensity.compact,
                tooltip: 'Opciones',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            publicacion.contenido,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
          if (publicacion.imagen != null) ...[
            const SizedBox(height: 10),
            _ImagenPublicacion(
              datos: publicacion.imagen!,
              nombre: publicacion.imagenNombre,
            ),
          ],
          if (publicacion.comentarios.isNotEmpty) ...[
            const SizedBox(height: 12),
            _VistaComentarios(publicacion: publicacion),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              _AccionForo(
                icono: leGusta
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                texto: '${publicacion.reacciones}',
                color: leGusta ? Colores.coral : null,
                onTap: () => estado.alternarReaccion(publicacion),
                onLongPress: () =>
                    _hojaReacciones(context, estado, publicacion),
              ),
              const SizedBox(width: 6),
              _AccionForo(
                icono: Icons.chat_bubble_outline_rounded,
                texto: '${publicacion.comentarios.length}',
                onTap: () => _abrirComentarios(context, publicacion),
              ),
              const Spacer(),
              if (publicacion.reportes.isNotEmpty) ...[
                const Icon(Icons.flag_rounded, size: 13, color: Colores.ambar),
                const SizedBox(width: 4),
                Text(
                  '${publicacion.reportes.length} reportes',
                  style: const TextStyle(fontSize: 9.5, color: Colores.ambar),
                ),
              ] else ...[
                const Icon(
                  Icons.public_rounded,
                  size: 13,
                  color: Colores.turquesa,
                ),
                const SizedBox(width: 4),
                const Text(
                  'sincronizado',
                  style: TextStyle(fontSize: 9.5, color: Colores.gris),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _VistaComentarios extends StatelessWidget {
  const _VistaComentarios({required this.publicacion});
  final Publicacion publicacion;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colores.fondo,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (final comentario in publicacion.comentarios.take(2))
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarNuki(
                    iniciales: comentario.iniciales,
                    tamano: 24,
                    colores: const [Colores.celeste, Colores.azulMedio],
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${comentario.autor} · ${comentario.tiempo}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Colores.gris,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          comentario.texto,
                          style: const TextStyle(fontSize: 11.5, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  _MiniLike(
                    comentario: comentario,
                    onTap: () => estado.alternarReaccionComentario(
                      publicacion,
                      comentario,
                    ),
                  ),
                ],
              ),
            ),
          if (publicacion.comentarios.length > 2)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _abrirComentarios(context, publicacion),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(
                  'Ver las ${publicacion.comentarios.length} respuestas',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

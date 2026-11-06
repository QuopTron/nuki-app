part of 'foro.dart';

Future<void> _abrirComentarios(BuildContext context, Publicacion publicacion) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaComentarios(publicacion: publicacion),
  );
}

class _HojaComentarios extends StatefulWidget {
  const _HojaComentarios({required this.publicacion});
  final Publicacion publicacion;

  @override
  State<_HojaComentarios> createState() => _HojaComentariosState();
}

class _HojaComentariosState extends State<_HojaComentarios> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar(EstadoNuki estado) async {
    if (_texto.text.trim().isEmpty) return;
    await estado.agregarComentario(widget.publicacion, _texto.text.trim());
    _texto.clear();
  }

  Future<void> _eliminar(EstadoNuki estado, Comentario comentario) async {
    final confirmar = await confirmarNuki(
      context,
      titulo: '¿Eliminar respuesta?',
      mensaje: 'La respuesta de ${comentario.autor} se quitará del foro.',
      confirmar: 'Eliminar',
    );
    if (confirmar) {
      await estado.eliminarComentario(widget.publicacion, comentario);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final publicacion = widget.publicacion;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: .82,
        minChildSize: .5,
        maxChildSize: .96,
        expand: false,
        builder: (context, scroll) => Container(
          decoration: const BoxDecoration(
            color: Colores.fondo,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Respuestas (${publicacion.comentarios.length})',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${publicacion.autor} · ${publicacion.materia}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colores.gris,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: estado,
                  builder: (context, _) {
                    final comentarios = publicacion.comentarios;
                    if (comentarios.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.forum_outlined,
                              size: 38,
                              color: Colores.celeste,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Sé el primero en responder.',
                              style: TextStyle(
                                color: Colores.gris,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scroll,
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
                      itemCount: comentarios.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _ComentarioTarjeta(
                        comentario: comentarios[i],
                        onLike: () => estado.alternarReaccionComentario(
                          publicacion,
                          comentarios[i],
                        ),
                        onEliminar: () => _eliminar(estado, comentarios[i]),
                      ),
                    );
                  },
                ),
              ),
              if (estado.puedeEscribir)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colores.tarjeta,
                    border: Border(top: BorderSide(color: Colores.borde)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _texto,
                          maxLines: 3,
                          minLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Escribe una respuesta...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => _enviar(estado),
                        icon: const Icon(Icons.send_rounded, size: 19),
                        tooltip: 'Responder',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

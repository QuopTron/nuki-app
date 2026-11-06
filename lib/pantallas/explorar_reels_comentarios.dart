part of 'explorar.dart';

Future<void> _abrirComentariosReel(BuildContext context, Reel reel) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaComentariosReel(reel: reel),
  );
}

class _HojaComentariosReel extends StatefulWidget {
  const _HojaComentariosReel({required this.reel});
  final Reel reel;

  @override
  State<_HojaComentariosReel> createState() => _HojaComentariosReelState();
}

class _HojaComentariosReelState extends State<_HojaComentariosReel> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar(EstadoNuki estado, Reel reel) async {
    if (_texto.text.trim().isEmpty) return;
    await estado.agregarComentarioReel(reel, _texto.text.trim());
    _texto.clear();
  }

  Future<void> _eliminar(
    EstadoNuki estado,
    Reel reel,
    Comentario comentario,
  ) async {
    final confirmar = await confirmarNuki(
      context,
      titulo: '¿Eliminar comentario?',
      mensaje: 'El comentario de ${comentario.autor} se quitó del reel.',
      confirmar: 'Eliminar',
    );
    if (!confirmar) return;
    await estado.eliminarComentarioReel(reel, comentario);
  }

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
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
          child: AnimatedBuilder(
            animation: estado,
            builder: (context, _) {
              final reel = estado.reels.firstWhere(
                (r) => r.id == widget.reel.id,
                orElse: () => widget.reel,
              );
              final comentarios = reel.comentariosLista;
              return Column(
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
                                'Comentarios (${reel.comentarios})',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${reel.autor} · ${reel.materia}',
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
                    child: comentarios.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.forum_outlined,
                                  size: 38,
                                  color: Colores.verde,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Sé el primero en comentar.',
                                  style: TextStyle(
                                    color: Colores.gris,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: scroll,
                            padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
                            itemCount: comentarios.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final comentario = comentarios[i];
                              return _ComentarioReelTarjeta(
                                comentario: comentario,
                                onLike: () =>
                                    estado.alternarReaccionComentarioReel(
                                      reel,
                                      comentario,
                                    ),
                                onEliminar: () =>
                                    _eliminar(estado, reel, comentario),
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
                                hintText: 'Escribe un comentario...',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: () => _enviar(estado, reel),
                            icon: const Icon(Icons.send_rounded, size: 19),
                            tooltip: 'Comentar',
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await abrirHojaAcceso(context);
                          },
                          child: const Text('Inicia sesión para comentar'),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ComentarioReelTarjeta extends StatelessWidget {
  const _ComentarioReelTarjeta({
    required this.comentario,
    required this.onLike,
    required this.onEliminar,
  });
  final Comentario comentario;
  final VoidCallback onLike, onEliminar;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final activo = estado.usuario != null && comentario.leGusta(estado.uid);
    final puedeEliminar = estado.puedeEditar(comentario.autorId);
    return Tarjeta(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarNuki(
            iniciales: comentario.iniciales,
            tamano: 32,
            colores: const [Colores.celeste, Colores.azulMedio],
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${comentario.autor} · ${comentario.tiempo}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colores.gris,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comentario.texto,
                  style: const TextStyle(fontSize: 12.5, height: 1.4),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    InkWell(
                      onTap: onLike,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              activo
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 14,
                              color: activo ? Colores.rosa : Colores.gris,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${comentario.reacciones}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colores.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (puedeEliminar)
                      InkWell(
                        onTap: onEliminar,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 15,
                            color: Colores.coral,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

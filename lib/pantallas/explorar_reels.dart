part of 'explorar.dart';

class _ReelsFeed extends StatefulWidget {
  const _ReelsFeed({required this.activo});
  final bool activo;

  @override
  State<_ReelsFeed> createState() => _ReelsFeedState();
}

class _ReelsFeedState extends State<_ReelsFeed> {
  final _controlador = PageController();
  int _indice = 0;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    if (estado.reels.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.video_library_outlined,
              size: 44,
              color: Colores.verde,
            ),
            const SizedBox(height: 10),
            const Text(
              'Aún no hay microlecciones.',
              style: TextStyle(color: Colores.gris),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _abrirSubirReel(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Subir el primer video'),
            ),
          ],
        ),
      );
    }
    return PageView.builder(
      controller: _controlador,
      scrollDirection: Axis.vertical,
      itemCount: estado.reels.length,
      onPageChanged: (i) => setState(() => _indice = i),
      itemBuilder: (context, i) {
        final reel = estado.reels[i];
        return _ReelTarjeta(
          reel: reel,
          reproducir: widget.activo && i == _indice,
          onComentarios: () => _abrirComentariosReel(context, reel),
          onCompartir: () => _compartir(context, reel),
          onLeccion: () => _abrirLeccion(context, reel),
          onVideo: () => _abrirVideo(context, reel),
          onEliminar: () => _eliminarReel(context, reel),
        );
      },
    );
  }
}

class _ReelTarjeta extends StatelessWidget {
  const _ReelTarjeta({
    required this.reel,
    required this.reproducir,
    required this.onComentarios,
    required this.onCompartir,
    required this.onLeccion,
    required this.onVideo,
    required this.onEliminar,
  });

  final Reel reel;
  final bool reproducir;
  final VoidCallback onComentarios;
  final VoidCallback onCompartir;
  final VoidCallback onLeccion;
  final VoidCallback onVideo;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final gusta = estado.reelsGustados.contains(reel.id);
    final sigue = estado.reelsSeguidos.contains(reel.id);
    final info = _analizarVideo(reel.videoUrl);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: reel.color.withValues(alpha: .32)),
        color: Colores.fondoProfundo,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _MediaReel(
            reel: reel,
            info: info,
            reproducir: reproducir,
            onTap: onVideo,
          ),
          const IgnorePointer(child: _DegradadoReel()),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colores.verde,
                  size: 20,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Para ti',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (estado.puedeEditar(reel.creadoPor))
                  _BotonCircular(
                    icono: Icons.delete_outline_rounded,
                    onTap: onEliminar,
                    tooltip: 'Eliminar video',
                  ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 130,
            child: Column(
              children: [
                _AccionLateral(
                  icono: gusta
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: gusta ? Colores.rosa : Colors.white,
                  etiqueta: _compacto(reel.likes),
                  onTap: () => estado.alternarLikeReel(reel),
                ),
                const SizedBox(height: 16),
                _AccionLateral(
                  icono: Icons.comment_rounded,
                  color: Colors.white,
                  etiqueta: _compacto(reel.comentarios),
                  onTap: onComentarios,
                ),
                const SizedBox(height: 16),
                _AccionLateral(
                  icono: Icons.share_rounded,
                  color: Colors.white,
                  etiqueta: 'Enviar',
                  onTap: onCompartir,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 72,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AvatarNuki(
                      iniciales: reel.iniciales,
                      tamano: 38,
                      colores: [reel.color, Colores.violeta],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reel.autor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${reel.usuario} · ${reel.materia}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  reel.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reel.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final etiqueta in reel.etiquetas.take(3))
                      Text(
                        etiqueta,
                        style: TextStyle(
                          color: reel.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => estado.alternarSeguirReel(reel),
                      style: TextButton.styleFrom(
                        foregroundColor: sigue ? Colors.white70 : Colores.fondo,
                        backgroundColor: sigue ? Colors.white12 : Colores.verde,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        sigue ? 'Siguiendo' : '+ Seguir',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onLeccion,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.menu_book_rounded, size: 14),
                      label: const Text(
                        'Lección',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (reel.videoUrl == null || reel.videoUrl!.isEmpty)
            const Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(child: _SinVideo()),
            ),
        ],
      ),
    );
  }

  static String _compacto(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';
}

class _AccionLateral extends StatelessWidget {
  const _AccionLateral({
    required this.icono,
    required this.color,
    required this.etiqueta,
    required this.onTap,
  });
  final IconData icono;
  final Color color;
  final String etiqueta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .36),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: color, size: 25),
          ),
          const SizedBox(height: 3),
          Text(
            etiqueta,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonCircular extends StatelessWidget {
  const _BotonCircular({
    required this.icono,
    required this.onTap,
    required this.tooltip,
  });
  final IconData icono;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .36),
            shape: BoxShape.circle,
          ),
          child: Icon(icono, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _DegradadoReel extends StatelessWidget {
  const _DegradadoReel();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x88000000),
            Color(0x00000000),
            Color(0x00000000),
            Color(0xCC000000),
          ],
          stops: [0, .28, .55, 1],
        ),
      ),
    );
  }
}

class _SinVideo extends StatelessWidget {
  const _SinVideo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .42),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty_rounded, color: Colors.white70, size: 16),
          SizedBox(width: 6),
          Text(
            'Microlección de texto',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

void _compartir(BuildContext context, Reel reel) {
  mostrarMensaje(context, 'Enlace de "${reel.titulo}" listo para compartir.');
}

Future<void> _eliminarReel(BuildContext context, Reel reel) async {
  final estado = AlcanceNuki.de(context);
  final confirmar = await confirmarNuki(
    context,
    titulo: '¿Eliminar video?',
    mensaje: 'Se quitará "${reel.titulo}" del repositorio.',
    confirmar: 'Eliminar',
  );
  if (!confirmar) return;
  await estado.eliminarReel(reel);
  if (context.mounted) mostrarMensaje(context, 'Video eliminado.');
}

void _abrirLeccion(BuildContext context, Reel reel) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colores.borde,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              reel.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              '${reel.autor} · ${reel.materia} · ${reel.fecha.isEmpty ? 'Ahora' : reel.fecha}',
              style: const TextStyle(color: Colores.gris, fontSize: 11.5),
            ),
            const SizedBox(height: 14),
            if (reel.descripcion.isNotEmpty) ...[
              Text(
                reel.descripcion,
                style: const TextStyle(
                  color: Colores.gris,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              reel.contenido,
              style: const TextStyle(fontSize: 13, height: 1.55),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(contexto);
                      _abrirComentariosReel(context, reel);
                    },
                    icon: const Icon(Icons.comment_rounded, size: 17),
                    label: const Text('Comentarios'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(contexto),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

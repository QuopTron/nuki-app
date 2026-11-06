part of 'explorar.dart';

enum _TipoVideo { youtube, tiktok, instagram, archivo, enlace, ninguno }

class _VideoInfo {
  const _VideoInfo(
    this.tipo, {
    this.id = '',
    this.ruta = '',
    this.subtipo = '',
  });
  final _TipoVideo tipo;
  final String id;
  final String ruta;
  final String subtipo;
  bool get tieneVideo => tipo != _TipoVideo.ninguno;
}

_VideoInfo _analizarVideo(String? valor) {
  final ruta = valor?.trim() ?? '';
  if (ruta.isEmpty) return const _VideoInfo(_TipoVideo.ninguno);
  if (!ruta.startsWith('http://') && !ruta.startsWith('https://')) {
    if (File(ruta).existsSync()) {
      return _VideoInfo(_TipoVideo.archivo, ruta: ruta);
    }
    return _VideoInfo(_TipoVideo.enlace, ruta: ruta);
  }
  final uri = Uri.tryParse(ruta);
  if (uri == null) return _VideoInfo(_TipoVideo.enlace, ruta: ruta);
  final host = uri.host.toLowerCase();
  if (host.contains('youtu.be')) {
    final id = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
    return _VideoInfo(_TipoVideo.youtube, id: id, ruta: ruta);
  }
  if (host.contains('youtube.com')) {
    final id =
        uri.queryParameters['v'] ??
        (uri.pathSegments.length > 1 &&
                (uri.pathSegments.first == 'shorts' ||
                    uri.pathSegments.first == 'embed')
            ? uri.pathSegments[1]
            : '');
    return _VideoInfo(_TipoVideo.youtube, id: id, ruta: ruta);
  }
  if (host.contains('tiktok.com')) {
    final partes = uri.pathSegments;
    final indice = partes.indexOf('video');
    final id = indice >= 0 && indice + 1 < partes.length
        ? partes[indice + 1]
        : '';
    return _VideoInfo(_TipoVideo.tiktok, id: id, ruta: ruta);
  }
  if (host.contains('instagram.com')) {
    final partes = uri.pathSegments;
    if (partes.length >= 2) {
      return _VideoInfo(
        _TipoVideo.instagram,
        id: partes[1],
        subtipo: partes.first,
        ruta: ruta,
      );
    }
    return _VideoInfo(_TipoVideo.instagram, ruta: ruta);
  }
  final limpio = uri.path.toLowerCase();
  if (limpio.endsWith('.mp4') ||
      limpio.endsWith('.webm') ||
      limpio.endsWith('.mov') ||
      limpio.endsWith('.m3u8') ||
      limpio.endsWith('.mkv')) {
    return _VideoInfo(_TipoVideo.archivo, ruta: ruta);
  }
  return _VideoInfo(_TipoVideo.enlace, ruta: ruta);
}

String _urlReproduccion(_VideoInfo info) {
  if (info.tipo == _TipoVideo.youtube && info.id.isNotEmpty) {
    return 'https://www.youtube-nocookie.com/embed/${info.id}?autoplay=1&playsinline=1&rel=0&modestbranding=1';
  }
  if (info.tipo == _TipoVideo.tiktok && info.id.isNotEmpty) {
    return 'https://www.tiktok.com/embed/v2/${info.id}';
  }
  if (info.tipo == _TipoVideo.instagram && info.id.isNotEmpty) {
    final tipo = info.subtipo == 'reel' ? 'reel' : 'p';
    return 'https://www.instagram.com/$tipo/${info.id}/embed';
  }
  return info.ruta;
}

class _MediaReel extends StatelessWidget {
  const _MediaReel({
    required this.reel,
    required this.info,
    required this.reproducir,
    required this.onTap,
  });

  final Reel reel;
  final _VideoInfo info;
  final bool reproducir;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (info.tipo == _TipoVideo.archivo) {
      if (reproducir) {
        return _VideoInline(ruta: info.ruta);
      }
      return _PortadaVideo(
        icono: Icons.movie_rounded,
        color: reel.color,
        onTap: onTap,
        etiqueta: 'Video',
      );
    }
    if (info.tipo == _TipoVideo.youtube && info.id.isNotEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://img.youtube.com/vi/${info.id}/hqdefault.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _PortadaVideo(
                icono: Icons.play_circle_fill_rounded,
                color: reel.color,
                onTap: null,
                etiqueta: 'YouTube',
              ),
            ),
            const Center(child: _PlayGrande()),
          ],
        ),
      );
    }
    if (info.tipo == _TipoVideo.tiktok) {
      return _PortadaVideo(
        icono: Icons.music_note_rounded,
        color: reel.color,
        onTap: onTap,
        etiqueta: 'TikTok',
      );
    }
    if (info.tipo == _TipoVideo.instagram) {
      return _PortadaVideo(
        icono: Icons.camera_alt_rounded,
        color: reel.color,
        onTap: onTap,
        etiqueta: 'Instagram',
      );
    }
    if (info.tipo == _TipoVideo.enlace) {
      return _PortadaVideo(
        icono: Icons.language_rounded,
        color: reel.color,
        onTap: onTap,
        etiqueta: 'Enlace externo',
      );
    }
    return _PortadaVideo(
      icono: reel.icono,
      color: reel.color,
      onTap: null,
      etiqueta: 'Microlección',
    );
  }
}

class _PortadaVideo extends StatelessWidget {
  const _PortadaVideo({
    required this.icono,
    required this.color,
    required this.onTap,
    required this.etiqueta,
  });
  final IconData icono;
  final Color color;
  final VoidCallback? onTap;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: .42),
              Colores.tarjeta,
              Colores.fondoProfundo,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -24,
              top: 32,
              child: Icon(
                icono,
                size: 240,
                color: color.withValues(alpha: .16),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onTap != null) const _PlayGrande(),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .38),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      etiqueta,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayGrande extends StatelessWidget {
  const _PlayGrande();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: .46),
        border: Border.all(color: Colors.white24),
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 38,
      ),
    );
  }
}

class _VideoInline extends StatefulWidget {
  const _VideoInline({required this.ruta});
  final String ruta;

  @override
  State<_VideoInline> createState() => _VideoInlineState();
}

class _VideoInlineState extends State<_VideoInline> {
  VideoPlayerController? _controlador;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final ruta = widget.ruta;
    final uri = Uri.tryParse(ruta);
    final esRemoto =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    final controlador = esRemoto
        ? VideoPlayerController.networkUrl(uri)
        : VideoPlayerController.file(File(ruta));
    try {
      await controlador.initialize();
      await controlador.setLooping(true);
      await controlador.setVolume(0);
      await controlador.play();
      if (!mounted) {
        await controlador.dispose();
        return;
      }
      setState(() => _controlador = controlador);
    } catch (_) {
      await controlador.dispose();
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _controlador?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controlador = _controlador;
    if (_error) {
      return const Center(
        child: Text(
          'No se pudo reproducir este video.',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      );
    }
    if (controlador == null || !controlador.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colores.verde),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (controlador.value.isPlaying) {
            controlador.pause();
          } else {
            controlador.play();
          }
        });
      },
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: controlador.value.size.width,
          height: controlador.value.size.height,
          child: VideoPlayer(controlador),
        ),
      ),
    );
  }
}

void _abrirVideo(BuildContext context, Reel reel) {
  final info = _analizarVideo(reel.videoUrl);
  if (!info.tieneVideo) {
    mostrarMensaje(
      context,
      'Esta microlección no tiene video, pero puedes leer el resumen.',
    );
    return;
  }
  if (info.tipo == _TipoVideo.archivo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _VisorVideoNativo(ruta: info.ruta, titulo: reel.titulo),
      ),
    );
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          _PantallaVideoWeb(url: _urlReproduccion(info), titulo: reel.titulo),
    ),
  );
}

class _PantallaVideoWeb extends StatefulWidget {
  const _PantallaVideoWeb({required this.url, required this.titulo});
  final String url, titulo;

  @override
  State<_PantallaVideoWeb> createState() => _PantallaVideoWebState();
}

class _PantallaVideoWebState extends State<_PantallaVideoWeb> {
  late final WebViewController _controlador;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _controlador = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _cargando = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _cargando = false);
          },
        ),
      );
    if (widget.url.contains('youtube')) {
      final enlace = widget.url
          .replaceAll('&', '&amp;')
          .replaceAll('"', '&quot;');
      _controlador.loadHtmlString('''
<!DOCTYPE html>
<html>
<head>
  <meta name="referrer" content="strict-origin-when-cross-origin">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    html, body { margin: 0; height: 100%; background: #000; overflow: hidden; }
    iframe { width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <iframe src="$enlace"
    referrerpolicy="strict-origin-when-cross-origin"
    allow="autoplay; encrypted-media; fullscreen"
    allowfullscreen></iframe>
</body>
</html>
''', baseUrl: 'https://com.usfx.nuki');
    } else {
      _controlador.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controlador),
          if (_cargando)
            const Center(
              child: CircularProgressIndicator(color: Colores.verde),
            ),
        ],
      ),
    );
  }
}

class _VisorVideoNativo extends StatefulWidget {
  const _VisorVideoNativo({required this.ruta, required this.titulo});
  final String ruta, titulo;

  @override
  State<_VisorVideoNativo> createState() => _VisorVideoNativoState();
}

class _VisorVideoNativoState extends State<_VisorVideoNativo> {
  VideoPlayerController? _controlador;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final uri = Uri.tryParse(widget.ruta);
    final esRemoto =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    final controlador = esRemoto
        ? VideoPlayerController.networkUrl(uri)
        : VideoPlayerController.file(File(widget.ruta));
    try {
      await controlador.initialize();
      await controlador.setLooping(true);
      if (!mounted) {
        await controlador.dispose();
        return;
      }
      setState(() => _controlador = controlador);
      await controlador.play();
    } catch (_) {
      await controlador.dispose();
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _controlador?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controlador = _controlador;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: Center(
        child: _error
            ? const Text(
                'No se pudo reproducir este video.',
                style: TextStyle(color: Colors.white70),
              )
            : controlador == null || !controlador.value.isInitialized
            ? const CircularProgressIndicator(color: Colores.verde)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: controlador.value.aspectRatio,
                    child: VideoPlayer(controlador),
                  ),
                  VideoProgressIndicator(
                    controlador,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colores.verde,
                      bufferedColor: Colors.white24,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filled(
                        onPressed: () {
                          setState(() {
                            if (controlador.value.isPlaying) {
                              controlador.pause();
                            } else {
                              controlador.play();
                            }
                          });
                        },
                        icon: Icon(
                          controlador.value.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: () {
                          setState(() {
                            controlador.setVolume(
                              controlador.value.volume > 0 ? 0 : 1,
                            );
                          });
                        },
                        icon: Icon(
                          controlador.value.volume > 0
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

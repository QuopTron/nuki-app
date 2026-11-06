part of 'explorar.dart';

Future<void> _abrirSubirReel(BuildContext context) async {
  final estado = AlcanceNuki.de(context);
  if (!estado.puedeEscribir) {
    mostrarMensaje(context, 'Inicia sesión para subir videos o enlaces.');
    await abrirHojaAcceso(context);
    return;
  }
  if (estado.materias.isEmpty) {
    mostrarMensaje(context, 'No hay materias para asociar el video.');
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaSubirReel(estado: estado),
  );
}

class _HojaSubirReel extends StatefulWidget {
  const _HojaSubirReel({required this.estado});
  final EstadoNuki estado;

  @override
  State<_HojaSubirReel> createState() => _HojaSubirReelState();
}

class _HojaSubirReelState extends State<_HojaSubirReel> {
  final _formulario = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  final _contenido = TextEditingController();
  final _enlace = TextEditingController();
  final _etiquetas = TextEditingController();
  String? _materia;
  String? _rutaLocal;
  bool _usarEnlace = true;
  bool _cargando = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _materia ??= widget.estado.materias.first.nombre;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    _contenido.dispose();
    _enlace.dispose();
    _etiquetas.dispose();
    super.dispose();
  }

  Future<void> _elegirVideo() async {
    setState(() => _error = null);
    try {
      final archivo = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 3),
      );
      if (archivo == null) return;
      final carpeta = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/nuki_reels',
      );
      if (!await carpeta.exists()) await carpeta.create(recursive: true);
      final extension = archivo.name.contains('.')
          ? archivo.name.split('.').last
          : 'mp4';
      final destino = File(
        '${carpeta.path}/reel_${DateTime.now().millisecondsSinceEpoch}.$extension',
      );
      await File(archivo.path).copy(destino.path);
      if (!mounted) return;
      setState(() {
        _rutaLocal = destino.path;
        _usarEnlace = false;
      });
    } catch (e) {
      if (mounted) setState(() => _error = 'No se pudo elegir el video: $e');
    }
  }

  Future<void> _publicar() async {
    if (!(_formulario.currentState?.validate() ?? false)) return;
    if (_usarEnlace && _enlace.text.trim().isEmpty) {
      setState(() => _error = 'Escribe el enlace del video.');
      return;
    }
    if (!_usarEnlace && _rutaLocal == null) {
      setState(() => _error = 'Elige un video de tu galería.');
      return;
    }
    setState(() {
      _cargando = true;
      _error = null;
    });
    final etiquetas = _etiquetas.text
        .split(RegExp(r'[,;]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => e.startsWith('#') ? e : '#$e')
        .toList();
    final descripcion = _descripcion.text.trim();
    final contenido = _contenido.text.trim();
    await widget.estado.agregarReel(
      titulo: _titulo.text.trim(),
      descripcion: descripcion,
      materia: _materia ?? widget.estado.materias.first.nombre,
      contenido: contenido.isEmpty ? descripcion : contenido,
      videoUrl: _usarEnlace ? _enlace.text.trim() : _rutaLocal,
      etiquetas: etiquetas,
    );
    if (!mounted) return;
    Navigator.pop(context);
    mostrarMensaje(context, 'Video publicado en reels.json.');
  }

  @override
  Widget build(BuildContext context) {
    final materias = widget.estado.materias;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: .9,
        minChildSize: .55,
        maxChildSize: .97,
        expand: false,
        builder: (context, scroll) => Container(
          decoration: const BoxDecoration(
            color: Colores.fondo,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colores.borde,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nuevo reel de biología',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
              ),
              const Text(
                'Comparte un video o enlace con tus compañeros.',
                style: TextStyle(color: Colores.gris, fontSize: 11.5),
              ),
              const SizedBox(height: 16),
              _SelectorFuente(
                usarEnlace: _usarEnlace,
                onEnlace: () => setState(() => _usarEnlace = true),
                onArchivo: _elegirVideo,
              ),
              const SizedBox(height: 12),
              if (_usarEnlace)
                TextFormField(
                  controller: _enlace,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Enlace del video',
                    hintText: 'YouTube, TikTok, Instagram o MP4',
                    prefixIcon: Icon(Icons.link_rounded),
                  ),
                )
              else
                _ArchivoElegido(ruta: _rutaLocal, onCambiar: _elegirVideo),
              const SizedBox(height: 8),
              const _AvisoVideo(),
              const SizedBox(height: 14),
              Form(
                key: _formulario,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titulo,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        prefixIcon: Icon(Icons.title_rounded),
                      ),
                      validator: (v) => (v?.trim().length ?? 0) < 4
                          ? 'Escribe un título.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _materia,
                      decoration: const InputDecoration(
                        labelText: 'Materia',
                        prefixIcon: Icon(Icons.menu_book_rounded),
                      ),
                      items: [
                        for (final materia in materias)
                          DropdownMenuItem(
                            value: materia.nombre,
                            child: Text(materia.nombre),
                          ),
                      ],
                      onChanged: (v) => setState(() => _materia = v),
                      validator: (v) => v == null ? 'Elige una materia.' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descripcion,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Descripción breve',
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                      validator: (v) => (v?.trim().isEmpty ?? true)
                          ? 'Agrega una descripción.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contenido,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Resumen para estudiar (opcional)',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.school_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _etiquetas,
                      decoration: const InputDecoration(
                        labelText: 'Etiquetas separadas por coma',
                        hintText: '#Anatomia, #Corazón',
                        prefixIcon: Icon(Icons.tag_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: Colores.coral, fontSize: 11.5),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _cargando ? null : _publicar,
                  icon: _cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_rounded, size: 19),
                  label: Text(_cargando ? 'Publicando...' : 'Publicar reel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorFuente extends StatelessWidget {
  const _SelectorFuente({
    required this.usarEnlace,
    required this.onEnlace,
    required this.onArchivo,
  });
  final bool usarEnlace;
  final VoidCallback onEnlace, onArchivo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OpcionFuente(
            icono: Icons.link_rounded,
            texto: 'Enlace',
            activo: usarEnlace,
            onTap: onEnlace,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _OpcionFuente(
            icono: Icons.video_file_rounded,
            texto: 'Mi galería',
            activo: !usarEnlace,
            onTap: onArchivo,
          ),
        ),
      ],
    );
  }
}

class _OpcionFuente extends StatelessWidget {
  const _OpcionFuente({
    required this.icono,
    required this.texto,
    required this.activo,
    required this.onTap,
  });
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: activo
              ? Colores.verde.withValues(alpha: .16)
              : Colores.tarjeta,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: activo ? Colores.verde : Colores.borde),
        ),
        child: Column(
          children: [
            Icon(icono, color: activo ? Colores.verde : Colores.gris, size: 22),
            const SizedBox(height: 4),
            Text(
              texto,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: activo ? Colores.verde : Colores.gris,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchivoElegido extends StatelessWidget {
  const _ArchivoElegido({required this.ruta, required this.onCambiar});
  final String? ruta;
  final VoidCallback onCambiar;

  @override
  Widget build(BuildContext context) {
    final nombre = ruta?.split(RegExp(r'[\\/]')).last;
    return Tarjeta(
      color: Colores.tarjeta,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.movie_rounded, color: Colores.verde, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              nombre ?? 'Ningún video elegido',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5),
            ),
          ),
          TextButton(
            onPressed: onCambiar,
            child: Text(ruta == null ? 'Elegir' : 'Cambiar'),
          ),
        ],
      ),
    );
  }
}

class _AvisoVideo extends StatelessWidget {
  const _AvisoVideo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 14, color: Colores.gris),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            'Los enlaces sí se sincronizan con GitHub. Los videos de tu galería se guardan solo en este dispositivo.',
            style: TextStyle(color: Colores.gris, fontSize: 10, height: 1.35),
          ),
        ),
      ],
    );
  }
}

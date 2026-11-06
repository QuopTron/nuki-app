part of 'foro.dart';

class _DatosPublicacion {
  const _DatosPublicacion(
    this.texto,
    this.materia, {
    this.imagen,
    this.imagenNombre,
  });
  final String texto, materia;
  final String? imagen, imagenNombre;
}

class _HojaPublicacion extends StatefulWidget {
  const _HojaPublicacion({required this.estado});
  final EstadoNuki estado;

  @override
  State<_HojaPublicacion> createState() => _HojaPublicacionState();
}

class _HojaPublicacionState extends State<_HojaPublicacion> {
  final _texto = TextEditingController();
  late String _materia;
  String? _imagen, _imagenNombre;

  List<String> get _opciones => [
    'General',
    ...widget.estado.materias.map((m) => m.nombre),
  ];

  @override
  void initState() {
    super.initState();
    _materia = widget.estado.materias.isEmpty
        ? 'General'
        : widget.estado.materias.first.nombre;
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _elegirFoto() async {
    final elegida = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1400,
      imageQuality: 72,
    );
    if (elegida == null) return;
    final bytes = await elegida.readAsBytes();
    if (bytes.length > 1200000) {
      if (mounted) {
        mostrarMensaje(context, 'La foto debe pesar menos de 1.2 MB.');
      }
      return;
    }
    setState(() {
      _imagen = base64Encode(bytes);
      _imagenNombre = elegida.name;
    });
  }

  void _enviar() {
    if (_texto.text.trim().isEmpty) return;
    Navigator.pop(
      context,
      _DatosPublicacion(
        _texto.text.trim(),
        _materia,
        imagen: _imagen,
        imagenNombre: _imagenNombre,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colores.fondo,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              children: [
                AvatarNuki(
                  iniciales: widget.estado.usuario?.iniciales ?? 'IN',
                  tamano: 40,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Nueva publicación',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _texto,
              autofocus: true,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Comparte una duda, apunte o idea...',
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _elegirFoto,
              icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
              label: Text(_imagen == null ? 'Añadir foto' : 'Cambiar foto'),
            ),
            if (_imagen != null) ...[
              const SizedBox(height: 10),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      base64Decode(_imagen!),
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      cacheWidth: 800,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton.filledTonal(
                      onPressed: () => setState(() {
                        _imagen = null;
                        _imagenNombre = null;
                      }),
                      icon: const Icon(Icons.close_rounded, size: 17),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Quitar foto',
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _imagenNombre ?? 'foto.jpg',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _materia,
              decoration: const InputDecoration(hintText: 'Materia'),
              items: [
                for (final opcion in _opciones)
                  DropdownMenuItem(value: opcion, child: Text(opcion)),
              ],
              onChanged: (valor) =>
                  setState(() => _materia = valor ?? _materia),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _enviar,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Publicar en el foro'),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Texto y foto se guardan en foro.json del repositorio',
                style: TextStyle(color: Colores.gris, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

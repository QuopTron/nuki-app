part of 'apuntes.dart';

class _HojaApunte extends StatefulWidget {
  const _HojaApunte({required this.estado});
  final EstadoNuki estado;

  @override
  State<_HojaApunte> createState() => _HojaApunteState();
}

class _HojaApunteState extends State<_HojaApunte> {
  final _titulo = TextEditingController();
  final _contenido = TextEditingController();
  late String _materia;
  Uint8List? _bytes;
  String? _nombre;

  @override
  void initState() {
    super.initState();
    _materia = widget.estado.materias.first.nombre;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _contenido.dispose();
    super.dispose();
  }

  Future<void> _elegir() async {
    final archivo = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
    );
    if (archivo == null) return;
    final bytes = await archivo.readAsBytes();
    if (!mounted) return;
    if (bytes.length > 4 * 1024 * 1024) {
      mostrarMensaje(context, 'El adjunto debe pesar menos de 4 MB.');
      return;
    }
    setState(() {
      _bytes = bytes;
      _nombre = archivo.name;
    });
  }

  void _enviar() {
    if (_titulo.text.trim().isEmpty) {
      mostrarMensaje(context, 'Escribe un título para el apunte.');
      return;
    }
    Navigator.pop(
      context,
      _DatosApunte(
        _titulo.text.trim(),
        _materia,
        _contenido.text.trim(),
        _bytes,
        _nombre,
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
        child: SingleChildScrollView(
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
              const Text(
                'Nuevo apunte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titulo,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Título del apunte',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _materia,
                decoration: const InputDecoration(hintText: 'Materia'),
                items: [
                  for (final m in widget.estado.materias)
                    DropdownMenuItem(value: m.nombre, child: Text(m.nombre)),
                ],
                onChanged: (valor) =>
                    setState(() => _materia = valor ?? _materia),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contenido,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Escribe tus apuntes...',
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _elegir,
                icon: const Icon(Icons.attach_file_rounded, size: 18),
                label: Text(
                  _nombre == null ? 'Adjuntar PDF o imagen' : 'Cambiar adjunto',
                ),
              ),
              if (_nombre != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        iconoDeArchivo(_nombre!),
                        size: 17,
                        color: colorDeArchivo(_nombre!),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _nombre!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Text(
                        formatearPeso(_bytes?.length ?? 0),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colores.gris,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _enviar,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('Guardar apunte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

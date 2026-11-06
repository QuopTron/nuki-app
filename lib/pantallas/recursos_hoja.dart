part of 'recursos.dart';

class _DatosRecurso {
  const _DatosRecurso(
    this.titulo,
    this.materia,
    this.tipo,
    this.descripcion,
    this.bytes,
    this.nombreArchivo,
  );
  final String titulo, materia, tipo, descripcion, nombreArchivo;
  final Uint8List bytes;
}

class _HojaRecurso extends StatefulWidget {
  const _HojaRecurso({required this.estado});
  final EstadoNuki estado;

  @override
  State<_HojaRecurso> createState() => _HojaRecursoState();
}

class _HojaRecursoState extends State<_HojaRecurso> {
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
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
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _elegir() async {
    final archivo = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const [
        'pdf',
        'png',
        'jpg',
        'jpeg',
        'webp',
        'doc',
        'docx',
        'ppt',
        'pptx',
      ],
    );
    if (archivo == null) return;
    final bytes = await archivo.readAsBytes();
    if (!mounted) return;
    if (bytes.length > 4 * 1024 * 1024) {
      mostrarMensaje(
        context,
        'El archivo debe pesar menos de 4 MB para versionarse.',
      );
      return;
    }
    setState(() {
      _bytes = bytes;
      _nombre = archivo.name;
      if (_titulo.text.trim().isEmpty) {
        _titulo.text = archivo.name.split('.').first;
      }
    });
  }

  void _enviar() {
    if (_titulo.text.trim().isEmpty || _bytes == null || _nombre == null) {
      mostrarMensaje(context, 'Completa el título y adjunta un archivo.');
      return;
    }
    Navigator.pop(
      context,
      _DatosRecurso(
        _titulo.text.trim(),
        _materia,
        tipoDeArchivo(_nombre!),
        _descripcion.text.trim(),
        _bytes!,
        _nombre!,
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
                'Subir recurso',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Text(
                'El PDF o imagen se guarda en recursos.json del repositorio.',
                style: TextStyle(fontSize: 10.5, color: Colores.gris),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _titulo,
                decoration: const InputDecoration(
                  hintText: 'Título del recurso',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descripcion,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Descripción breve (opcional)',
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
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _elegir,
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: Text(
                  _nombre == null ? 'Elegir PDF o imagen' : 'Cambiar archivo',
                ),
              ),
              if (_nombre != null) ...[
                const SizedBox(height: 10),
                Tarjeta(
                  padding: const EdgeInsets.all(10),
                  sombra: false,
                  child: Row(
                    children: [
                      Icon(
                        iconoDeArchivo(_nombre!),
                        color: colorDeArchivo(_nombre!),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          _nombre!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
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
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _enviar,
                  icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                  label: const Text('Publicar recurso'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

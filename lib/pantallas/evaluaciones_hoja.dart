part of 'evaluaciones.dart';

class _HojaEvaluacion extends StatefulWidget {
  const _HojaEvaluacion({required this.estado});
  final EstadoNuki estado;

  @override
  State<_HojaEvaluacion> createState() => _HojaEvaluacionState();
}

class _HojaEvaluacionState extends State<_HojaEvaluacion> {
  final _titulo = TextEditingController();
  late String _materia;
  String _tipo = 'Cuestionario';
  int _minutos = 20;
  final List<Pregunta> _preguntas = [];

  @override
  void initState() {
    super.initState();
    _materia = widget.estado.materias.first.nombre;
  }

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  Future<void> _agregarPregunta() async {
    final pregunta = await _dialogoPregunta(context);
    if (pregunta != null) setState(() => _preguntas.add(pregunta));
  }

  void _enviar() {
    if (_titulo.text.trim().isEmpty) {
      mostrarMensaje(context, 'Escribe un título para la evaluación.');
      return;
    }
    if (_preguntas.isEmpty) {
      mostrarMensaje(context, 'Agrega al menos una pregunta.');
      return;
    }
    Navigator.pop(
      context,
      _DatosEvaluacion(
        _titulo.text.trim(),
        _materia,
        _tipo,
        _minutos,
        List.of(_preguntas),
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
                'Nueva evaluación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Text(
                'Se publicará en evaluaciones.json para todos los estudiantes.',
                style: TextStyle(fontSize: 10.5, color: Colores.gris),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titulo,
                decoration: const InputDecoration(
                  hintText: 'Título de la evaluación',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _materia,
                      decoration: const InputDecoration(hintText: 'Materia'),
                      items: [
                        for (final m in widget.estado.materias)
                          DropdownMenuItem(
                            value: m.nombre,
                            child: Text(
                              m.nombre,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (valor) =>
                          setState(() => _materia = valor ?? _materia),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _tipo,
                      decoration: const InputDecoration(hintText: 'Tipo'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Cuestionario',
                          child: Text('Cuestionario'),
                        ),
                        DropdownMenuItem(
                          value: 'Simulacro',
                          child: Text('Simulacro'),
                        ),
                        DropdownMenuItem(value: 'Tarea', child: Text('Tarea')),
                      ],
                      onChanged: (valor) =>
                          setState(() => _tipo = valor ?? _tipo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                initialValue: _minutos,
                decoration: const InputDecoration(hintText: 'Duración'),
                items: [
                  for (final m in const [5, 10, 15, 20, 30, 45, 60])
                    DropdownMenuItem(value: m, child: Text('$m minutos')),
                ],
                onChanged: (valor) =>
                    setState(() => _minutos = valor ?? _minutos),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Preguntas (${_preguntas.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _agregarPregunta,
                    icon: const Icon(Icons.add_rounded, size: 17),
                    label: const Text('Agregar'),
                  ),
                ],
              ),
              for (var i = 0; i < _preguntas.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Tarjeta(
                    padding: const EdgeInsets.all(10),
                    sombra: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${i + 1}. ${_preguntas[i].enunciado}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _preguntas.removeAt(i)),
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Colores.coral,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _enviar,
                  icon: const Icon(Icons.publish_rounded, size: 18),
                  label: const Text('Publicar evaluación'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

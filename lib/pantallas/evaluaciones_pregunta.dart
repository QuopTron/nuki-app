part of 'evaluaciones.dart';

Future<Pregunta?> _dialogoPregunta(BuildContext context) async {
  final enunciado = TextEditingController();
  final opciones = List.generate(4, (_) => TextEditingController());
  final explicacion = TextEditingController();
  var correcta = 0;
  final resultado = await showDialog<Pregunta>(
    context: context,
    builder: (contexto) => StatefulBuilder(
      builder: (contexto, setStateDialogo) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Nueva pregunta',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: RadioGroup<int>(
              groupValue: correcta,
              onChanged: (valor) =>
                  setStateDialogo(() => correcta = valor ?? correcta),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: enunciado,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Enunciado de la pregunta',
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Radio<int>(value: i),
                          Expanded(
                            child: TextField(
                              controller: opciones[i],
                              decoration: InputDecoration(
                                hintText:
                                    'Opción ${String.fromCharCode(65 + i)}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: explicacion,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Explicación de la respuesta correcta',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Marca el círculo de la opción correcta.',
                      style: TextStyle(fontSize: 10, color: Colores.gris),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final textos = opciones.map((c) => c.text.trim()).toList();
              if (enunciado.text.trim().isEmpty ||
                  textos.any((t) => t.isEmpty)) {
                return;
              }
              Navigator.pop(
                contexto,
                Pregunta(
                  enunciado.text.trim(),
                  textos,
                  correcta,
                  explicacion.text.trim(),
                ),
              );
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    ),
  );
  enunciado.dispose();
  for (final opcion in opciones) {
    opcion.dispose();
  }
  explicacion.dispose();
  return resultado;
}

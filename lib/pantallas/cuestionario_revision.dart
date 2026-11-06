part of 'cuestionario.dart';

String _formatoTiempo(int segundos) {
  final minutos = (segundos.abs() ~/ 60).toString().padLeft(2, '0');
  final resto = (segundos.abs() % 60).toString().padLeft(2, '0');
  return '$minutos:$resto';
}

Future<bool> confirmarSalida(
  BuildContext context, {
  required int contestadas,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text('¿Salir de la evaluación?'),
      content: Text(
        contestadas == 0
            ? 'El progreso de esta sesión no se guardará.'
            : 'Has respondido $contestadas preguntas. Este intento no se guardará.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: const Text('Seguir'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(contexto, true),
          child: const Text('Salir'),
        ),
      ],
    ),
  );
  return resultado ?? false;
}

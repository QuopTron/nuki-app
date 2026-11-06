import 'package:flutter/material.dart';
import '../nucleo/tema.dart';

Future<bool> confirmarNuki(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String confirmar = 'Confirmar',
  Color color = Colores.coral,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(contexto, true),
          style: FilledButton.styleFrom(backgroundColor: color),
          child: Text(confirmar),
        ),
      ],
    ),
  );
  return resultado ?? false;
}

String formatearPeso(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  return '$bytes B';
}

String tipoDeArchivo(String nombre) {
  final ext = nombre.toLowerCase().split('.').last;
  if (ext == 'pdf') return 'PDF';
  if (['png', 'jpg', 'jpeg', 'webp'].contains(ext)) return 'Imagen';
  if (['doc', 'docx'].contains(ext)) return 'Documento';
  if (['ppt', 'pptx'].contains(ext)) return 'Presentación';
  return 'Archivo';
}

IconData iconoDeArchivo(String nombre) {
  final tipo = tipoDeArchivo(nombre);
  return switch (tipo) {
    'PDF' => Icons.picture_as_pdf_rounded,
    'Imagen' => Icons.image_rounded,
    'Documento' => Icons.description_rounded,
    'Presentación' => Icons.slideshow_rounded,
    _ => Icons.insert_drive_file_rounded,
  };
}

Color colorDeArchivo(String nombre) => switch (tipoDeArchivo(nombre)) {
  'PDF' => Colores.coral,
  'Imagen' => Colores.turquesa,
  'Documento' => Colores.azulMedio,
  'Presentación' => Colores.ambar,
  _ => Colores.violeta,
};

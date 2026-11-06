import 'package:flutter/material.dart';
import 'tema.dart';

const Map<String, IconData> iconosNuki = {
  'favorite': Icons.favorite_rounded,
  'monitor_heart': Icons.monitor_heart_rounded,
  'biotech': Icons.biotech_rounded,
  'hub': Icons.hub_rounded,
  'coronavirus': Icons.coronavirus_rounded,
  'science': Icons.science_rounded,
  'psychology': Icons.psychology_rounded,
  'air': Icons.air_rounded,
  'water_drop': Icons.water_drop_rounded,
  'picture_as_pdf': Icons.picture_as_pdf_rounded,
  'auto_stories': Icons.auto_stories_rounded,
  'menu_book': Icons.menu_book_rounded,
  'map': Icons.map_rounded,
  'article': Icons.article_rounded,
  'library_books': Icons.library_books_rounded,
  'task_alt': Icons.task_alt_rounded,
  'videocam': Icons.videocam_rounded,
  'play_circle': Icons.play_circle_rounded,
  'bolt': Icons.bolt_rounded,
  'comment': Icons.comment_rounded,
  'forum': Icons.forum_rounded,
  'local_fire_department': Icons.local_fire_department_rounded,
  'school': Icons.school_rounded,
  'accessibility_new': Icons.accessibility_new_rounded,
};

IconData iconoDe(String? nombre) => iconosNuki[nombre] ?? Icons.school_rounded;

Color colorDe(String? hex, [Color porDefecto = Colores.azul]) {
  if (hex == null) return porDefecto;
  final limpio = hex.replaceAll('#', '');
  final valor = int.tryParse(limpio, radix: 16);
  if (valor == null) return porDefecto;
  return Color(limpio.length == 6 ? 0xFF000000 | valor : valor);
}

String hexDe(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

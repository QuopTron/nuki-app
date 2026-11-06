import 'package:flutter/material.dart';
import 'iconos.dart';

part 'modelos_academicos.dart';
part 'modelos_reels.dart';
part 'modelos_sociales.dart';
part 'modelos_usuarios.dart';

class Tema {
  const Tema(this.titulo, this.tipo, {this.completado = false});
  final String titulo, tipo;
  final bool completado;

  factory Tema.desdeJson(Map<String, dynamic> j) => Tema(
    j['titulo'] as String? ?? '',
    j['tipo'] as String? ?? '',
    completado: j['completado'] as bool? ?? false,
  );
  Map<String, dynamic> aJson() => {
    'titulo': titulo,
    'tipo': tipo,
    'completado': completado,
  };
}

class Materia {
  Materia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.temas,
    this.completadas = 0,
    this.inscrita = true,
  });
  final String id, nombre, descripcion;
  final IconData icono;
  final Color color;
  final List<Tema> temas;
  int completadas;
  bool inscrita;
  int get total => temas.length;
  double get avance => total == 0 ? 0 : (completadas / total).clamp(0.0, 1.0);

  factory Materia.desdeJson(Map<String, dynamic> j) => Materia(
    id: j['id'] as String? ?? '',
    nombre: j['nombre'] as String? ?? '',
    descripcion: j['descripcion'] as String? ?? '',
    icono: iconoDe(j['icono'] as String?),
    color: colorDe(j['color'] as String?),
    completadas: (j['completadas'] as num?)?.toInt() ?? 0,
    inscrita: j['inscrita'] as bool? ?? true,
    temas: (j['temas'] as List<dynamic>? ?? const [])
        .map((e) => Tema.desdeJson((e as Map).cast<String, dynamic>()))
        .toList(),
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () => const MapEntry('school', Icons.school_rounded),
        )
        .key,
    'color': hexDe(color),
    'completadas': completadas,
    'inscrita': inscrita,
    'temas': temas.map((t) => t.aJson()).toList(),
  };
}

part of 'modelos.dart';

class Reel {
  Reel({
    required this.id,
    required this.autor,
    required this.usuario,
    required this.iniciales,
    required this.materia,
    required this.titulo,
    required this.descripcion,
    required this.contenido,
    required this.icono,
    required this.color,
    this.likes = 0,
    this.comentarios = 0,
    this.duracion = '0:30',
    this.etiquetas = const [],
    this.seguido = false,
    this.videoUrl,
    this.creadoPor = '',
    this.fecha = '',
    this.vistas = 0,
    List<String>? reaccionantes,
    List<String>? seguidores,
    List<Comentario>? comentariosLista,
  }) : reaccionantes = reaccionantes ?? [],
       seguidores = seguidores ?? [],
       comentariosLista = comentariosLista ?? [];

  final int id;
  final String autor,
      usuario,
      iniciales,
      materia,
      titulo,
      descripcion,
      contenido,
      duracion;
  final IconData icono;
  final Color color;
  int likes, comentarios, vistas;
  final List<String> etiquetas;
  final bool seguido;
  final String? videoUrl;
  final String creadoPor, fecha;
  final List<String> reaccionantes, seguidores;
  final List<Comentario> comentariosLista;

  bool leGusta(String uid) => reaccionantes.contains(uid);
  bool seguidoPor(String uid) => seguidores.contains(uid);

  factory Reel.desdeJson(Map<String, dynamic> j) => Reel(
    id: (j['id'] as num?)?.toInt() ?? 0,
    autor: j['autor'] as String? ?? '',
    usuario: j['usuario'] as String? ?? '',
    iniciales: j['iniciales'] as String? ?? '?',
    materia: j['materia'] as String? ?? '',
    titulo: j['titulo'] as String? ?? '',
    descripcion: j['descripcion'] as String? ?? '',
    contenido: j['contenido'] as String? ?? '',
    icono: iconoDe(j['icono'] as String?),
    color: colorDe(j['color'] as String?),
    likes: (j['likes'] as num?)?.toInt() ?? 0,
    comentarios: (j['comentarios'] as num?)?.toInt() ?? 0,
    duracion: j['duracion'] as String? ?? '0:30',
    etiquetas: (j['etiquetas'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    seguido: j['seguido'] as bool? ?? false,
    videoUrl: j['videoUrl'] as String?,
    creadoPor: j['creadoPor'] as String? ?? '',
    fecha: j['fecha'] as String? ?? '',
    vistas: (j['vistas'] as num?)?.toInt() ?? 0,
    reaccionantes: (j['reaccionantes'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    seguidores: (j['seguidores'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    comentariosLista: (j['comentariosLista'] as List<dynamic>? ?? const [])
        .map((e) => Comentario.desdeJson((e as Map).cast<String, dynamic>()))
        .toList(),
  );

  Map<String, dynamic> aJson() => {
    'id': id,
    'autor': autor,
    'usuario': usuario,
    'iniciales': iniciales,
    'materia': materia,
    'titulo': titulo,
    'descripcion': descripcion,
    'contenido': contenido,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () =>
              const MapEntry('play_circle', Icons.play_circle_rounded),
        )
        .key,
    'color': hexDe(color),
    'likes': likes,
    'comentarios': comentarios,
    'duracion': duracion,
    'etiquetas': etiquetas,
    'seguido': seguido,
    if (videoUrl != null && videoUrl!.isNotEmpty) 'videoUrl': videoUrl,
    if (creadoPor.isNotEmpty) 'creadoPor': creadoPor,
    if (fecha.isNotEmpty) 'fecha': fecha,
    'vistas': vistas,
    'reaccionantes': reaccionantes,
    'seguidores': seguidores,
    'comentariosLista': comentariosLista.map((c) => c.aJson()).toList(),
  };

  Reel copiar({
    int? likes,
    int? comentarios,
    int? vistas,
    bool? seguido,
    List<String>? reaccionantes,
    List<String>? seguidores,
    List<Comentario>? comentariosLista,
  }) => Reel(
    id: id,
    autor: autor,
    usuario: usuario,
    iniciales: iniciales,
    materia: materia,
    titulo: titulo,
    descripcion: descripcion,
    contenido: contenido,
    icono: icono,
    color: color,
    likes: likes ?? this.likes,
    comentarios: comentarios ?? this.comentarios,
    duracion: duracion,
    etiquetas: etiquetas,
    seguido: seguido ?? this.seguido,
    videoUrl: videoUrl,
    creadoPor: creadoPor,
    fecha: fecha,
    vistas: vistas ?? this.vistas,
    reaccionantes: reaccionantes ?? this.reaccionantes,
    seguidores: seguidores ?? this.seguidores,
    comentariosLista: comentariosLista ?? this.comentariosLista,
  );
}

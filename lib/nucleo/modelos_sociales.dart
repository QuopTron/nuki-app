part of 'modelos.dart';

class Comentario {
  Comentario({
    required this.autor,
    required this.iniciales,
    required this.texto,
    required this.tiempo,
    this.id = 0,
    this.autorId = '',
    this.reacciones = 0,
    List<String>? reaccionantes,
  }) : reaccionantes = reaccionantes ?? [];
  final String autor, iniciales, texto, tiempo;
  final int id;
  final String autorId;
  int reacciones;
  final List<String> reaccionantes;
  bool leGusta(String usuarioId) => reaccionantes.contains(usuarioId);

  factory Comentario.desdeJson(Map<String, dynamic> j) => Comentario(
    autor: j['autor'] as String? ?? '',
    iniciales: j['iniciales'] as String? ?? '?',
    texto: j['texto'] as String? ?? '',
    tiempo: j['tiempo'] as String? ?? '',
    id: (j['id'] as num?)?.toInt() ?? 0,
    autorId: j['autorId'] as String? ?? '',
    reacciones: (j['reacciones'] as num?)?.toInt() ?? 0,
    reaccionantes: (j['reaccionantes'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'autor': autor,
    'iniciales': iniciales,
    'texto': texto,
    'tiempo': tiempo,
    'autorId': autorId,
    'reacciones': reacciones,
    'reaccionantes': reaccionantes,
  };
}

class Publicacion {
  Publicacion({
    required this.id,
    required this.autor,
    required this.iniciales,
    required this.tiempo,
    required this.materia,
    required this.contenido,
    this.autorId = '',
    this.reacciones = 0,
    List<Comentario>? comentarios,
    this.imagen,
    this.imagenNombre,
    this.editada = false,
    this.fijada = false,
    List<String>? reaccionantes,
    List<String>? reportes,
  }) : comentarios = comentarios ?? [],
       reaccionantes = reaccionantes ?? [],
       reportes = reportes ?? [];
  final int id;
  final String autor, iniciales;
  String tiempo;
  final String materia;
  String contenido;
  final String autorId;
  int reacciones;
  final List<Comentario> comentarios;
  final String? imagen, imagenNombre;
  bool editada, fijada;
  final List<String> reaccionantes, reportes;
  bool leGusta(String usuarioId) => reaccionantes.contains(usuarioId);

  factory Publicacion.desdeJson(Map<String, dynamic> j) => Publicacion(
    id: (j['id'] as num?)?.toInt() ?? 0,
    autor: j['autor'] as String? ?? '',
    iniciales: j['iniciales'] as String? ?? '?',
    tiempo: j['tiempo'] as String? ?? '',
    materia: j['materia'] as String? ?? '',
    contenido: j['contenido'] as String? ?? '',
    autorId: j['autorId'] as String? ?? '',
    reacciones: (j['reacciones'] as num?)?.toInt() ?? 0,
    imagen: j['imagen'] as String?,
    imagenNombre: j['imagenNombre'] as String?,
    editada: j['editada'] as bool? ?? false,
    fijada: j['fijada'] as bool? ?? false,
    reaccionantes: (j['reaccionantes'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    reportes: (j['reportes'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    comentarios: (j['comentarios'] as List<dynamic>? ?? const [])
        .map((e) => Comentario.desdeJson((e as Map).cast<String, dynamic>()))
        .toList(),
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'autor': autor,
    'iniciales': iniciales,
    'tiempo': tiempo,
    'materia': materia,
    'contenido': contenido,
    'autorId': autorId,
    'reacciones': reacciones,
    'editada': editada,
    'fijada': fijada,
    'comentarios': comentarios.map((c) => c.aJson()).toList(),
    'reaccionantes': reaccionantes,
    'reportes': reportes,
    if (imagen != null) 'imagen': imagen,
    if (imagenNombre != null) 'imagenNombre': imagenNombre,
  };
}

class Apunte {
  Apunte({
    required this.materia,
    required this.titulo,
    required this.fecha,
    required this.icono,
    required this.color,
    this.id = 0,
    this.contenido = '',
    this.autor = '',
    this.autorId = '',
    this.archivo,
    this.archivoNombre,
  });
  final String materia, titulo, fecha;
  final IconData icono;
  final Color color;
  final int id;
  final String contenido, autor, autorId;
  final String? archivo, archivoNombre;

  factory Apunte.desdeJson(Map<String, dynamic> j) => Apunte(
    materia: j['materia'] as String? ?? '',
    titulo: j['titulo'] as String? ?? '',
    fecha: j['fecha'] as String? ?? '',
    icono: iconoDe(j['icono'] as String?),
    color: colorDe(j['color'] as String?),
    id: (j['id'] as num?)?.toInt() ?? 0,
    contenido: j['contenido'] as String? ?? '',
    autor: j['autor'] as String? ?? '',
    autorId: j['autorId'] as String? ?? '',
    archivo: j['archivo'] as String?,
    archivoNombre: j['archivoNombre'] as String?,
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'materia': materia,
    'titulo': titulo,
    'fecha': fecha,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () => const MapEntry('school', Icons.school_rounded),
        )
        .key,
    'color': hexDe(color),
    'contenido': contenido,
    'autor': autor,
    'autorId': autorId,
    if (archivo != null) 'archivo': archivo,
    if (archivoNombre != null) 'archivoNombre': archivoNombre,
  };
}

class NotificacionNuki {
  NotificacionNuki({
    required this.titulo,
    required this.detalle,
    required this.hace,
    required this.tipo,
    required this.icono,
    required this.color,
    this.leida = false,
  });
  final String titulo, detalle, hace, tipo;
  final IconData icono;
  final Color color;
  bool leida;

  factory NotificacionNuki.desdeJson(Map<String, dynamic> j) =>
      NotificacionNuki(
        titulo: j['titulo'] as String? ?? '',
        detalle: j['detalle'] as String? ?? '',
        hace: j['hace'] as String? ?? '',
        tipo: j['tipo'] as String? ?? 'Sistema',
        icono: iconoDe(j['icono'] as String?),
        color: colorDe(j['color'] as String?),
        leida: j['leida'] as bool? ?? false,
      );
  Map<String, dynamic> aJson() => {
    'titulo': titulo,
    'detalle': detalle,
    'hace': hace,
    'tipo': tipo,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () => const MapEntry('school', Icons.school_rounded),
        )
        .key,
    'color': hexDe(color),
    'leida': leida,
  };
}

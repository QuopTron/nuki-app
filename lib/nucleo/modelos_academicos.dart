part of 'modelos.dart';

class Recurso {
  const Recurso({
    required this.titulo,
    required this.autor,
    required this.tipo,
    required this.materia,
    required this.tamano,
    required this.icono,
    required this.color,
    this.id = 0,
    this.autorId = '',
    this.descripcion = '',
    this.archivo,
    this.archivoNombre,
  });
  final String titulo, autor, tipo, materia, tamano;
  final IconData icono;
  final Color color;
  final int id;
  final String autorId, descripcion;
  final String? archivo, archivoNombre;

  factory Recurso.desdeJson(Map<String, dynamic> j) => Recurso(
    titulo: j['titulo'] as String? ?? '',
    autor: j['autor'] as String? ?? '',
    tipo: j['tipo'] as String? ?? 'PDF',
    materia: j['materia'] as String? ?? '',
    tamano: j['tamano'] as String? ?? '',
    icono: iconoDe(j['icono'] as String?),
    color: colorDe(j['color'] as String?),
    id: (j['id'] as num?)?.toInt() ?? 0,
    autorId: j['autorId'] as String? ?? '',
    descripcion: j['descripcion'] as String? ?? '',
    archivo: j['archivo'] as String?,
    archivoNombre: j['archivoNombre'] as String?,
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'titulo': titulo,
    'autor': autor,
    'tipo': tipo,
    'materia': materia,
    'tamano': tamano,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () => const MapEntry('school', Icons.school_rounded),
        )
        .key,
    'color': hexDe(color),
    'autorId': autorId,
    'descripcion': descripcion,
    if (archivo != null) 'archivo': archivo,
    if (archivoNombre != null) 'archivoNombre': archivoNombre,
  };
}

class Pregunta {
  const Pregunta(
    this.enunciado,
    this.opciones,
    this.correcta,
    this.explicacion,
  );
  final String enunciado, explicacion;
  final List<String> opciones;
  final int correcta;

  factory Pregunta.desdeJson(Map<String, dynamic> j) => Pregunta(
    j['enunciado'] as String? ?? '',
    (j['opciones'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    (j['correcta'] as num?)?.toInt() ?? 0,
    j['explicacion'] as String? ?? '',
  );
  Map<String, dynamic> aJson() => {
    'enunciado': enunciado,
    'opciones': opciones,
    'correcta': correcta,
    'explicacion': explicacion,
  };
}

class Evaluacion {
  Evaluacion({
    required this.id,
    required this.titulo,
    required this.materia,
    required this.tipo,
    required this.cantidad,
    required this.minutos,
    required this.icono,
    required this.color,
    required this.preguntas,
    this.autor = '',
    this.autorId = '',
  });
  final String id, titulo, materia, tipo;
  final int cantidad, minutos;
  final IconData icono;
  final Color color;
  final List<Pregunta> preguntas;
  final String autor, autorId;

  factory Evaluacion.desdeJson(Map<String, dynamic> j) => Evaluacion(
    id: j['id'] as String? ?? '',
    titulo: j['titulo'] as String? ?? '',
    materia: j['materia'] as String? ?? '',
    tipo: j['tipo'] as String? ?? 'Cuestionario',
    cantidad: (j['cantidad'] as num?)?.toInt() ?? 0,
    minutos: (j['minutos'] as num?)?.toInt() ?? 0,
    icono: iconoDe(j['icono'] as String?),
    color: colorDe(j['color'] as String?),
    autor: j['autor'] as String? ?? '',
    autorId: j['autorId'] as String? ?? '',
    preguntas: (j['preguntas'] as List<dynamic>? ?? const [])
        .map((e) => Pregunta.desdeJson((e as Map).cast<String, dynamic>()))
        .toList(),
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'titulo': titulo,
    'materia': materia,
    'tipo': tipo,
    'cantidad': cantidad,
    'minutos': minutos,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () => const MapEntry('school', Icons.school_rounded),
        )
        .key,
    'color': hexDe(color),
    'autor': autor,
    'autorId': autorId,
    'preguntas': preguntas.map((p) => p.aJson()).toList(),
  };
}

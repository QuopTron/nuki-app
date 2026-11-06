part of 'modelos.dart';

class Usuario {
  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.iniciales,
    this.estado = 'Activo',
    this.materias = 0,
    this.reportes = 0,
    this.claveHash = '',
    this.claveSal = '',
    this.creadoEn = '',
  });
  final String id;
  String nombre, correo, rol, iniciales;
  String estado;
  final int materias, reportes;
  String claveHash, claveSal;
  final String creadoEn;
  bool get tieneClave => claveHash.isNotEmpty && claveSal.isNotEmpty;
  bool get esAdmin => rol == 'Administrador';
  bool get esDocente => rol == 'Docente';
  bool get baneado => estado == 'Baneado';
  bool get esInvitado => id == 'invitado';

  factory Usuario.desdeJson(Map<String, dynamic> j) => Usuario(
    id: j['id'] as String? ?? '',
    nombre: j['nombre'] as String? ?? '',
    correo: j['correo'] as String? ?? '',
    rol: j['rol'] as String? ?? 'Estudiante',
    iniciales: j['iniciales'] as String? ?? '?',
    estado: j['estado'] as String? ?? 'Activo',
    materias: (j['materias'] as num?)?.toInt() ?? 0,
    reportes: (j['reportes'] as num?)?.toInt() ?? 0,
    claveHash: j['claveHash'] as String? ?? '',
    claveSal: j['claveSal'] as String? ?? '',
    creadoEn: j['creadoEn'] as String? ?? '',
  );
  Map<String, dynamic> aJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'rol': rol,
    'iniciales': iniciales,
    'estado': estado,
    'materias': materias,
    'reportes': reportes,
    if (claveHash.isNotEmpty) 'claveHash': claveHash,
    if (claveSal.isNotEmpty) 'claveSal': claveSal,
    if (creadoEn.isNotEmpty) 'creadoEn': creadoEn,
  };
}

class EstructuraAnatomica {
  const EstructuraAnatomica(this.nombre, this.funcion);
  final String nombre, funcion;

  factory EstructuraAnatomica.desdeJson(dynamic valor) {
    if (valor is String) return EstructuraAnatomica(valor, '');
    final j = (valor as Map).cast<String, dynamic>();
    return EstructuraAnatomica(
      j['nombre'] as String? ?? '',
      j['funcion'] as String? ?? '',
    );
  }
  Map<String, dynamic> aJson() => {'nombre': nombre, 'funcion': funcion};
}

class ModeloAnatomico {
  const ModeloAnatomico({
    required this.nombre,
    required this.icono,
    required this.colores,
    required this.descripcion,
    required this.estructuras,
    required this.dato,
    this.archivo,
  });
  final String nombre, descripcion, dato;
  final IconData icono;
  final List<Color> colores;
  final List<EstructuraAnatomica> estructuras;
  final String? archivo;

  factory ModeloAnatomico.desdeJson(Map<String, dynamic> j) => ModeloAnatomico(
    nombre: j['nombre'] as String? ?? '',
    icono: iconoDe(j['icono'] as String?),
    colores: (j['colores'] as List<dynamic>? ?? const [])
        .map((e) => colorDe(e.toString()))
        .toList(),
    descripcion: j['descripcion'] as String? ?? '',
    dato: j['dato'] as String? ?? '',
    archivo: j['archivo'] as String?,
    estructuras: (j['estructuras'] as List<dynamic>? ?? const [])
        .map(EstructuraAnatomica.desdeJson)
        .toList(),
  );
  Map<String, dynamic> aJson() => {
    'nombre': nombre,
    'icono': iconosNuki.entries
        .firstWhere(
          (e) => e.value == icono,
          orElse: () => const MapEntry('school', Icons.school_rounded),
        )
        .key,
    'colores': colores.map(hexDe).toList(),
    'descripcion': descripcion,
    'estructuras': estructuras.map((e) => e.aJson()).toList(),
    'dato': dato,
    if (archivo != null) 'archivo': archivo,
  };
}

class RegistroPerfil {
  const RegistroPerfil({
    this.racha = 0,
    this.logros = 0,
    this.promedio = 0,
    this.resultados = const {},
  });
  final int racha, logros;
  final double promedio;
  final Map<String, int> resultados;

  factory RegistroPerfil.desdeJson(Map<String, dynamic> j) => RegistroPerfil(
    racha: (j['racha'] as num?)?.toInt() ?? 0,
    logros: (j['logros'] as num?)?.toInt() ?? 0,
    promedio: (j['promedio'] as num?)?.toDouble() ?? 0,
    resultados: ((j['resultados'] as Map?) ?? const {}).map(
      (k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0),
    ),
  );
  Map<String, dynamic> aJson() => {
    'racha': racha,
    'logros': logros,
    'promedio': promedio,
    'resultados': resultados,
  };
}

class PerfilDatos {
  const PerfilDatos({this.usuarios = const {}});
  final Map<String, RegistroPerfil> usuarios;
  RegistroPerfil de(String id) => usuarios[id] ?? const RegistroPerfil();

  factory PerfilDatos.desdeJson(Map<String, dynamic> j) {
    final mapa = j['usuarios'];
    if (mapa is Map) {
      return PerfilDatos(
        usuarios: mapa.map(
          (k, v) => MapEntry(
            k.toString(),
            RegistroPerfil.desdeJson((v as Map).cast<String, dynamic>()),
          ),
        ),
      );
    }
    return PerfilDatos(usuarios: {'u1': RegistroPerfil.desdeJson(j)});
  }
  Map<String, dynamic> aJson() => {
    'usuarios': usuarios.map((k, v) => MapEntry(k, v.aJson())),
  };
}

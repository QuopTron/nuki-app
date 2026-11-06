import 'fuente_git.dart';
import 'modelos.dart';

class InfoRepositorio {
  const InfoRepositorio({
    required this.nombre,
    required this.rama,
    required this.actualizado,
    required this.mensaje,
    required this.archivos,
    required this.fuente,
  });
  final String nombre, rama, actualizado, mensaje, fuente;
  final int archivos;
}

class ContenidoNuki {
  const ContenidoNuki({
    required this.materias,
    required this.recursos,
    required this.reels,
    required this.evaluaciones,
    required this.publicaciones,
    required this.apuntes,
    required this.notificaciones,
    required this.usuarios,
    required this.modelos,
    required this.perfil,
    required this.info,
  });
  final List<Materia> materias;
  final List<Recurso> recursos;
  final List<Reel> reels;
  final List<Evaluacion> evaluaciones;
  final List<Publicacion> publicaciones;
  final List<Apunte> apuntes;
  final List<NotificacionNuki> notificaciones;
  final List<Usuario> usuarios;
  final List<ModeloAnatomico> modelos;
  final PerfilDatos perfil;
  final InfoRepositorio info;
}

class RepositorioNuki {
  RepositorioNuki(this.fuente);
  final FuenteContenido fuente;
  Map<String, dynamic>? _indice;
  Map<String, String> _rutas = {};

  Future<ContenidoNuki> cargar() async {
    final indice = await fuente.leer('indice.json');
    _indice = indice;
    _rutas = ((indice['datos'] as Map?) ?? const {}).map(
      (clave, valor) => MapEntry(clave.toString(), valor.toString()),
    );
    final claves = _rutas.keys.toList();
    final respuestas = await Future.wait(
      claves.map((clave) => fuente.leer(_rutas[clave]!)),
    );
    final archivos = <String, Map<String, dynamic>>{
      for (var i = 0; i < claves.length; i++) claves[i]: respuestas[i],
    };

    List<T> lista<T>(String clave, T Function(Map<String, dynamic>) convertir) {
      final datos = archivos[clave]?['datos'] as List<dynamic>? ?? const [];
      return datos
          .map((e) => convertir((e as Map).cast<String, dynamic>()))
          .toList();
    }

    final metadatos =
        (indice['metadatos'] as Map?)?.cast<String, dynamic>() ?? const {};
    final perfil =
        (archivos['perfil']?['datos'] as Map?)?.cast<String, dynamic>() ??
        const {};
    return ContenidoNuki(
      materias: lista('materias', Materia.desdeJson),
      recursos: lista('recursos', Recurso.desdeJson),
      reels: lista('reels', Reel.desdeJson),
      evaluaciones: lista('evaluaciones', Evaluacion.desdeJson),
      publicaciones: lista('foro', Publicacion.desdeJson),
      apuntes: lista('apuntes', Apunte.desdeJson),
      notificaciones: lista('notificaciones', NotificacionNuki.desdeJson),
      usuarios: lista('usuarios', Usuario.desdeJson),
      modelos: lista('modelos', ModeloAnatomico.desdeJson),
      perfil: PerfilDatos.desdeJson(perfil),
      info: InfoRepositorio(
        nombre: indice['repositorio'] as String? ?? 'nuki-contenido',
        rama: metadatos['rama'] as String? ?? 'main',
        actualizado: metadatos['actualizado'] as String? ?? '',
        mensaje: metadatos['mensaje'] as String? ?? 'Contenido académico',
        archivos: _rutas.length,
        fuente: fuente.descripcion,
      ),
    );
  }

  Future<void> guardar(String clave, List<Map<String, dynamic>> datos) async {
    final ruta = _rutas[clave];
    if (ruta == null) {
      throw ExcepcionRepositorio('El índice no define "$clave".');
    }
    await fuente.escribir(ruta, {'datos': datos});
    await _actualizarIndice();
  }

  Future<void> guardarPerfil(PerfilDatos perfil) async {
    final ruta = _rutas['perfil'];
    if (ruta == null) {
      throw ExcepcionRepositorio('El índice no define "perfil".');
    }
    await fuente.escribir(ruta, {'datos': perfil.aJson()});
    await _actualizarIndice();
  }

  Future<void> _actualizarIndice() async {
    final indice = _indice;
    if (indice == null) return;
    final metadatos =
        (indice['metadatos'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    metadatos['actualizado'] = DateTime.now().toUtc().toIso8601String();
    indice['metadatos'] = metadatos;
    await fuente.escribir('indice.json', indice);
  }

  Future<void> restablecer() async {
    final actual = fuente;
    if (actual is FuenteGitEmulada) {
      await actual.restablecer();
      return;
    }
    throw ExcepcionRepositorio(
      'Restablecer solo está disponible en el modo local emulado.',
    );
  }
}

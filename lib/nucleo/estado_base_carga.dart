part of 'estado.dart';

mixin _CargaEstado on _EstadoBase {
  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      final contenido = await _repositorio.cargar();
      materias = contenido.materias;
      recursos = contenido.recursos;
      reels = contenido.reels;
      evaluaciones = contenido.evaluaciones;
      publicaciones = contenido.publicaciones;
      apuntes = contenido.apuntes;
      notificaciones = contenido.notificaciones;
      usuarios = contenido.usuarios;
      modelos = contenido.modelos;
      _perfiles = Map<String, RegistroPerfil>.from(contenido.perfil.usuarios);
      infoRepositorio = contenido.info;
      for (final cuenta in usuarios) {
        if (cuenta.id == usuario?.id) usuario = cuenta;
      }
      if (usuario == null) {
        final prefs = await SharedPreferences.getInstance();
        final guardado = prefs.getString('nuki_sesion_uid');
        if (guardado != null) {
          for (final cuenta in usuarios) {
            if (cuenta.id == guardado) {
              usuario = cuenta;
              break;
            }
          }
        }
      }
      _recalcularSecuencias();
      _aplicarPerfil();
      _sincronizarGustosReels();
    } catch (e) {
      error = e.toString();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void _recalcularSecuencias() {
    _siguienteId = publicaciones.fold(
      100,
      (mayor, p) => p.id > mayor ? p.id : mayor,
    );
    for (final p in publicaciones) {
      for (final c in p.comentarios) {
        if (c.id >= _siguienteComentarioId) _siguienteComentarioId = c.id + 1;
      }
    }
    _siguienteApunteId = apuntes.fold(
      1,
      (mayor, a) => a.id >= mayor ? a.id + 1 : mayor,
    );
    _siguienteRecursoId = recursos.fold(
      1,
      (mayor, r) => r.id >= mayor ? r.id + 1 : mayor,
    );
    _siguienteEvaluacionId = evaluaciones.fold(1, (mayor, e) {
      final numero = int.tryParse(e.id.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      return numero >= mayor ? numero + 1 : mayor;
    });
    _siguienteReelId = reels.fold(
      1,
      (mayor, r) => r.id >= mayor ? r.id + 1 : mayor,
    );
    for (final r in reels) {
      for (final c in r.comentariosLista) {
        if (c.id >= _siguienteComentarioId) _siguienteComentarioId = c.id + 1;
      }
    }
  }

  void iniciarSesion(Usuario cuenta) {
    usuario = cuenta;
    _aplicarPerfil();
    _sincronizarGustosReels();
    _persistirSesion(cuenta.id);
    notifyListeners();
  }

  void _persistirSesion(String? id) {
    SharedPreferences.getInstance().then((prefs) {
      if (id == null) {
        prefs.remove('nuki_sesion_uid');
      } else {
        prefs.setString('nuki_sesion_uid', id);
      }
    });
  }

  void entrarInvitado() {
    usuario = Usuario(
      id: 'invitado',
      nombre: 'Invitado',
      correo: 'invitado@nuki.app',
      rol: 'Estudiante',
      iniciales: 'IN',
    );
    _aplicarPerfil();
    _sincronizarGustosReels();
    _persistirSesion(null);
    notifyListeners();
  }

  void cerrarSesion() {
    usuario = null;
    reelsGustados.clear();
    reelsSeguidos.clear();
    _persistirSesion(null);
    notifyListeners();
  }

  void _sincronizarGustosReels() {
    reelsGustados.clear();
    reelsSeguidos.clear();
    if (usuario == null || esInvitado) return;
    for (final reel in reels) {
      if (reel.reaccionantes.contains(uid)) reelsGustados.add(reel.id);
      if (reel.seguidores.contains(uid)) reelsSeguidos.add(reel.id);
    }
  }

  Future<void> inscribir(Materia materia) async {
    if (!puedeEscribir) return _soloLectura();
    materia.inscrita = !materia.inscrita;
    notifyListeners();
    await _guardar('materias', materias.map((m) => m.aJson()).toList());
  }

  Future<void> alternarTema(Materia materia, int indice) async {
    if (!puedeEscribir) return _soloLectura();
    final tema = materia.temas[indice];
    materia.temas[indice] = Tema(
      tema.titulo,
      tema.tipo,
      completado: !tema.completado,
    );
    materia.completadas = materia.temas.where((t) => t.completado).length;
    notifyListeners();
    await _guardar('materias', materias.map((m) => m.aJson()).toList());
  }

  void _aplicarPerfil() {
    final registro = _perfiles[uid] ?? const RegistroPerfil();
    racha = registro.racha;
    logros = registro.logros;
    promedio = registro.promedio;
    resultados
      ..clear()
      ..addAll(registro.resultados);
  }

  Future<void> _guardarPerfil() async {
    if (usuario == null || esInvitado) return;
    _perfiles[uid] = RegistroPerfil(
      racha: racha,
      logros: logros,
      promedio: promedio,
      resultados: Map<String, int>.from(resultados),
    );
    try {
      await _repositorio.guardarPerfil(
        PerfilDatos(usuarios: Map<String, RegistroPerfil>.from(_perfiles)),
      );
    } catch (e) {
      aviso = 'No se pudo guardar el perfil: $e';
      notifyListeners();
    }
  }

  void _soloLectura() {
    aviso =
        'Estás explorando como invitado: inicia sesión para guardar cambios.';
    notifyListeners();
  }

  Future<void> _guardar(String clave, List<Map<String, dynamic>> datos) async {
    guardando = true;
    notifyListeners();
    try {
      await _repositorio.guardar(clave, datos);
      aviso = 'Sincronizado: $clave.json';
    } catch (e) {
      aviso = 'Error al guardar $clave: $e';
    } finally {
      guardando = false;
      notifyListeners();
    }
  }
}

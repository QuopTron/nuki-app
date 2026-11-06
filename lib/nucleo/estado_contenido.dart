part of 'estado.dart';

mixin _AccionesContenido on _EstadoBase, _CargaEstado {
  Future<void> alternarLikeReel(Reel reel) async {
    if (!puedeEscribir) return _soloLectura();
    final indice = reels.indexWhere((r) => r.id == reel.id);
    if (indice < 0) return;
    final actual = reels[indice];
    final gusta = actual.reaccionantes.contains(uid);
    final reaccionantes = List<String>.from(actual.reaccionantes);
    if (gusta) {
      reaccionantes.remove(uid);
      reelsGustados.remove(actual.id);
    } else {
      reaccionantes.add(uid);
      reelsGustados.add(actual.id);
    }
    reels[indice] = actual.copiar(
      likes: (actual.likes + (gusta ? -1 : 1)).clamp(0, 1 << 31).toInt(),
      reaccionantes: reaccionantes,
    );
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Future<void> alternarSeguirReel(Reel reel) async {
    if (!puedeEscribir) return _soloLectura();
    final indice = reels.indexWhere((r) => r.id == reel.id);
    if (indice < 0) return;
    final actual = reels[indice];
    final sigue = actual.seguidores.contains(uid);
    final seguidores = List<String>.from(actual.seguidores);
    if (sigue) {
      seguidores.remove(uid);
      reelsSeguidos.remove(actual.id);
    } else {
      seguidores.add(uid);
      reelsSeguidos.add(actual.id);
    }
    reels[indice] = actual.copiar(seguidores: seguidores);
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Future<void> agregarReel({
    required String titulo,
    required String descripcion,
    required String materia,
    required String contenido,
    required String? videoUrl,
    required List<String> etiquetas,
  }) async {
    if (!puedeEscribir) return _soloLectura();
    final base = _materiaBase(materia);
    final cuenta = usuario!;
    final usuarioRed = '@';
    reels.insert(
      0,
      Reel(
        id: _siguienteReelId++,
        autor: cuenta.nombre,
        usuario: usuarioRed,
        iniciales: cuenta.iniciales,
        materia: materia,
        titulo: titulo,
        descripcion: descripcion,
        contenido: contenido,
        icono: base?.icono ?? Icons.menu_book_rounded,
        color: base?.color ?? Colores.violeta,
        videoUrl: videoUrl,
        creadoPor: uid,
        fecha: 'Ahora',
        etiquetas: etiquetas,
        duracion: 'Video',
      ),
    );
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Future<void> eliminarReel(Reel reel) async {
    if (!puedeEditar(reel.creadoPor)) return;
    reels.removeWhere((r) => r.id == reel.id);
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Future<void> agregarComentarioReel(Reel reel, String texto) async {
    if (!puedeEscribir) return _soloLectura();
    final indice = reels.indexWhere((r) => r.id == reel.id);
    if (indice < 0) return;
    final actual = reels[indice];
    final lista = List<Comentario>.from(actual.comentariosLista)
      ..add(
        Comentario(
          id: _siguienteComentarioId++,
          autor: usuario?.nombre ?? 'Invitado',
          iniciales: usuario?.iniciales ?? 'IN',
          texto: texto,
          tiempo: 'Ahora',
          autorId: uid,
        ),
      );
    reels[indice] = actual.copiar(
      comentarios: actual.comentarios + 1,
      comentariosLista: lista,
    );
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Future<void> eliminarComentarioReel(Reel reel, Comentario comentario) async {
    if (!puedeEditar(comentario.autorId)) return;
    final indice = reels.indexWhere((r) => r.id == reel.id);
    if (indice < 0) return;
    final actual = reels[indice];
    final lista = List<Comentario>.from(actual.comentariosLista)
      ..removeWhere((c) => c.id == comentario.id);
    reels[indice] = actual.copiar(
      comentarios: (actual.comentarios - 1).clamp(0, 1 << 31).toInt(),
      comentariosLista: lista,
    );
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Future<void> alternarReaccionComentarioReel(
    Reel reel,
    Comentario comentario,
  ) async {
    if (!puedeEscribir) return _soloLectura();
    final indice = reels.indexWhere((r) => r.id == reel.id);
    if (indice < 0) return;
    final actual = reels[indice];
    final lista = List<Comentario>.from(actual.comentariosLista);
    final posicion = lista.indexWhere((c) => c.id == comentario.id);
    if (posicion < 0) return;
    final objetivo = lista[posicion];
    if (objetivo.leGusta(uid)) {
      objetivo.reaccionantes.remove(uid);
      if (objetivo.reacciones > 0) objetivo.reacciones--;
    } else {
      objetivo.reaccionantes.add(uid);
      objetivo.reacciones++;
    }
    reels[indice] = actual.copiar(comentariosLista: lista);
    notifyListeners();
    await _guardar('reels', reels.map((r) => r.aJson()).toList());
  }

  Materia? _materiaBase(String nombre) {
    for (final materia in materias) {
      if (materia.nombre == nombre) return materia;
    }
    return materias.isEmpty ? null : materias.first;
  }

  Future<void> agregarRecurso({
    required String titulo,
    required String materia,
    required String tipo,
    required String descripcion,
    required String tamano,
    String? archivo,
    String? archivoNombre,
  }) async {
    if (!puedeGestionar) return _soloLectura();
    final base = _materiaBase(materia);
    recursos.insert(
      0,
      Recurso(
        titulo: titulo,
        autor: usuario?.nombre ?? 'Docencia Nuki',
        tipo: tipo,
        materia: materia,
        tamano: tamano,
        icono: base?.icono ?? Icons.picture_as_pdf_rounded,
        color: base?.color ?? Colores.coral,
        id: _siguienteRecursoId++,
        autorId: uid,
        descripcion: descripcion,
        archivo: archivo,
        archivoNombre: archivoNombre,
      ),
    );
    notifyListeners();
    await _guardar('recursos', recursos.map((r) => r.aJson()).toList());
  }

  Future<void> eliminarRecurso(Recurso recurso) async {
    if (!puedeEditar(recurso.autorId)) return;
    recursos.removeWhere((r) => identical(r, recurso));
    notifyListeners();
    await _guardar('recursos', recursos.map((r) => r.aJson()).toList());
  }

  Future<void> agregarApunte({
    required String materia,
    required String titulo,
    required String contenido,
    String? archivo,
    String? archivoNombre,
  }) async {
    if (!puedeEscribir) return _soloLectura();
    final base = _materiaBase(materia);
    apuntes.insert(
      0,
      Apunte(
        materia: materia,
        titulo: titulo,
        fecha: 'Ahora',
        icono: base?.icono ?? Icons.note_rounded,
        color: base?.color ?? Colores.azulMedio,
        id: _siguienteApunteId++,
        contenido: contenido,
        autor: usuario?.nombre ?? '',
        autorId: uid,
        archivo: archivo,
        archivoNombre: archivoNombre,
      ),
    );
    notifyListeners();
    await _guardar('apuntes', apuntes.map((a) => a.aJson()).toList());
  }

  Future<void> editarApunte(
    Apunte apunte, {
    required String titulo,
    required String contenido,
  }) async {
    if (!puedeEditar(apunte.autorId)) return;
    final actualizado = Apunte(
      materia: apunte.materia,
      titulo: titulo,
      fecha: 'Editado',
      icono: apunte.icono,
      color: apunte.color,
      id: apunte.id,
      contenido: contenido,
      autor: apunte.autor,
      autorId: apunte.autorId,
      archivo: apunte.archivo,
      archivoNombre: apunte.archivoNombre,
    );
    final indice = apuntes.indexWhere((a) => a.id == apunte.id);
    if (indice >= 0) apuntes[indice] = actualizado;
    notifyListeners();
    await _guardar('apuntes', apuntes.map((a) => a.aJson()).toList());
  }

  Future<void> eliminarApunte(Apunte apunte) async {
    if (!puedeEditar(apunte.autorId)) return;
    apuntes.removeWhere((a) => a.id == apunte.id);
    notifyListeners();
    await _guardar('apuntes', apuntes.map((a) => a.aJson()).toList());
  }

  Future<void> crearEvaluacion({
    required String titulo,
    required String materia,
    required String tipo,
    required int minutos,
    required List<Pregunta> preguntas,
  }) async {
    if (!puedeGestionar) return _soloLectura();
    final base = _materiaBase(materia);
    final id = 'e${_siguienteEvaluacionId++}';
    evaluaciones.insert(
      0,
      Evaluacion(
        id: id,
        titulo: titulo,
        materia: materia,
        tipo: tipo,
        cantidad: preguntas.length,
        minutos: minutos,
        icono: base?.icono ?? Icons.quiz_rounded,
        color: base?.color ?? Colores.violeta,
        preguntas: preguntas,
        autor: usuario?.nombre ?? '',
        autorId: uid,
      ),
    );
    notifyListeners();
    await _guardar('evaluaciones', evaluaciones.map((e) => e.aJson()).toList());
  }

  Future<void> eliminarEvaluacion(Evaluacion evaluacion) async {
    if (!puedeEditar(evaluacion.autorId)) return;
    evaluaciones.removeWhere((e) => e.id == evaluacion.id);
    notifyListeners();
    await _guardar('evaluaciones', evaluaciones.map((e) => e.aJson()).toList());
  }

  Future<void> guardarResultado(Evaluacion evaluacion, int aciertos) async {
    if (!puedeEscribir) return;
    resultados[evaluacion.id] = aciertos;
    final total = evaluacion.preguntas.length;
    final nota = total == 0 ? 0.0 : (aciertos / total) * 10;
    promedio = double.parse(
      ((promedio * 3 + nota) / 4).clamp(0, 10).toStringAsFixed(1),
    );
    notificaciones.insert(
      0,
      NotificacionNuki(
        titulo: 'Evaluación completada',
        detalle: '${evaluacion.titulo}: $aciertos/$total',
        hace: 'Ahora',
        tipo: 'Materias',
        icono: Icons.task_alt_rounded,
        color: evaluacion.color,
      ),
    );
    notifyListeners();
    await _guardar(
      'notificaciones',
      notificaciones.map((n) => n.aJson()).toList(),
    );
    await _guardarPerfil();
  }
}

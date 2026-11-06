part of 'estado.dart';

mixin _AccionesForo on _EstadoBase, _CargaEstado {
  Future<void> agregarPublicacion(
    String contenido,
    String materia, {
    String? imagen,
    String? imagenNombre,
  }) async {
    if (!puedeEscribir) return _soloLectura();
    publicaciones.insert(
      0,
      Publicacion(
        id: ++_siguienteId,
        autor: usuario?.nombre ?? 'Invitado',
        iniciales: usuario?.iniciales ?? 'IN',
        tiempo: 'Ahora',
        materia: materia,
        contenido: contenido,
        autorId: uid,
        imagen: imagen,
        imagenNombre: imagenNombre,
      ),
    );
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> editarPublicacion(
    Publicacion publicacion,
    String contenido,
  ) async {
    if (!puedeEditar(publicacion.autorId)) return;
    publicacion.contenido = contenido;
    publicacion.editada = true;
    publicacion.tiempo = 'Ahora';
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> eliminarPublicacion(Publicacion publicacion) async {
    if (!puedeEditar(publicacion.autorId)) return;
    publicaciones.removeWhere((p) => p.id == publicacion.id);
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> alternarReaccion(Publicacion publicacion) async {
    if (!puedeEscribir) return _soloLectura();
    if (publicacion.leGusta(uid)) {
      publicacion.reaccionantes.remove(uid);
      if (publicacion.reacciones > 0) publicacion.reacciones--;
    } else {
      publicacion.reaccionantes.add(uid);
      publicacion.reacciones++;
    }
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> agregarComentario(Publicacion publicacion, String texto) async {
    if (!puedeEscribir) return _soloLectura();
    publicacion.comentarios.add(
      Comentario(
        autor: usuario?.nombre ?? 'Invitado',
        iniciales: usuario?.iniciales ?? 'IN',
        texto: texto,
        tiempo: 'Ahora',
        id: _siguienteComentarioId++,
        autorId: uid,
      ),
    );
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> eliminarComentario(
    Publicacion publicacion,
    Comentario comentario,
  ) async {
    if (!puedeEditar(comentario.autorId)) return;
    publicacion.comentarios.removeWhere((c) => identical(c, comentario));
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> alternarReaccionComentario(
    Publicacion publicacion,
    Comentario comentario,
  ) async {
    if (!puedeEscribir) return _soloLectura();
    if (comentario.leGusta(uid)) {
      comentario.reaccionantes.remove(uid);
      if (comentario.reacciones > 0) comentario.reacciones--;
    } else {
      comentario.reaccionantes.add(uid);
      comentario.reacciones++;
    }
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> reportarPublicacion(
    Publicacion publicacion,
    String motivo,
  ) async {
    if (!puedeEscribir) return _soloLectura();
    if (publicacion.reportes.contains(uid)) return;
    publicacion.reportes.add(uid);
    notificaciones.insert(
      0,
      NotificacionNuki(
        titulo: 'Publicación reportada',
        detalle: '${usuario?.nombre}: $motivo',
        hace: 'Ahora',
        tipo: 'Foro',
        icono: Icons.flag_rounded,
        color: Colores.ambar,
      ),
    );
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
    await _guardar(
      'notificaciones',
      notificaciones.map((n) => n.aJson()).toList(),
    );
  }

  Future<void> alternarFijada(Publicacion publicacion) async {
    if (!puedeModerar) return;
    publicacion.fijada = !publicacion.fijada;
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Future<void> registrarIdentificacion(
    String modelo,
    int aciertos,
    int total,
  ) async {
    if (!puedeEscribir) return;
    if (aciertos == total && total > 0) logros++;
    notificaciones.insert(
      0,
      NotificacionNuki(
        titulo: 'Identificación anatómica',
        detalle: '$modelo: $aciertos/$total estructuras reconocidas',
        hace: 'Ahora',
        tipo: 'Materias',
        icono: Icons.view_in_ar_rounded,
        color: Colores.turquesa,
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

part of 'estado.dart';

mixin _AccionesNotificaciones on _EstadoBase, _CargaEstado {
  Future<void> marcarLeida(NotificacionNuki notificacion) async {
    if (notificacion.leida) return;
    notificacion.leida = true;
    notifyListeners();
    await _guardar(
      'notificaciones',
      notificaciones.map((n) => n.aJson()).toList(),
    );
  }

  Future<void> enviarAviso(String titulo, String detalle) async {
    if (!puedeGestionar) return _soloLectura();
    notificaciones.insert(
      0,
      NotificacionNuki(
        titulo: titulo,
        detalle: detalle,
        hace: 'Ahora',
        tipo: 'Sistema',
        icono: Icons.campaign_rounded,
        color: Colores.violeta,
      ),
    );
    notifyListeners();
    await _guardar(
      'notificaciones',
      notificaciones.map((n) => n.aJson()).toList(),
    );
  }

  Future<void> eliminarNotificacion(NotificacionNuki notificacion) async {
    if (!puedeGestionar) return;
    notificaciones.removeWhere((n) => identical(n, notificacion));
    notifyListeners();
    await _guardar(
      'notificaciones',
      notificaciones.map((n) => n.aJson()).toList(),
    );
  }

  Future<void> marcarTodasLeidas() async {
    for (final notificacion in notificaciones) {
      notificacion.leida = true;
    }
    notifyListeners();
    await _guardar(
      'notificaciones',
      notificaciones.map((n) => n.aJson()).toList(),
    );
  }

  Future<void> restablecerContenido() async {
    try {
      await _repositorio.restablecer();
      await cargar();
    } catch (e) {
      aviso = e.toString();
      notifyListeners();
    }
  }
}

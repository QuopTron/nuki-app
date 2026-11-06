part of 'estado.dart';

mixin _AccionesModeracion on _EstadoBase, _CargaEstado {
  Future<void> alternarBan(Usuario cuenta) async {
    if (!puedeModerar) return;
    cuenta.estado = cuenta.baneado ? 'Activo' : 'Baneado';
    notifyListeners();
    await _guardar('usuarios', usuarios.map((u) => u.aJson()).toList());
  }

  Future<void> cambiarRol(Usuario cuenta, String rol) async {
    if (!puedeModerar) return;
    cuenta.rol = rol;
    notifyListeners();
    await _guardar('usuarios', usuarios.map((u) => u.aJson()).toList());
  }

  Future<void> crearUsuario({
    required String nombre,
    required String correo,
    required String rol,
  }) async {
    if (!puedeModerar) return;
    final iniciales = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    var numero = 1;
    for (final cuenta in usuarios) {
      final valor =
          int.tryParse(cuenta.id.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      if (valor >= numero) numero = valor + 1;
    }
    usuarios.add(
      Usuario(
        id: 'u$numero',
        nombre: nombre,
        correo: correo,
        rol: rol,
        iniciales: iniciales.isEmpty ? 'NU' : iniciales,
      ),
    );
    notifyListeners();
    await _guardar('usuarios', usuarios.map((u) => u.aJson()).toList());
  }

  Future<void> descartarReportes(Publicacion publicacion) async {
    if (!puedeModerar) return;
    publicacion.reportes.clear();
    notifyListeners();
    await _guardar('foro', publicaciones.map((p) => p.aJson()).toList());
  }

  Usuario? autorDe(Publicacion publicacion) {
    for (final cuenta in usuarios) {
      if (cuenta.id == publicacion.autorId) return cuenta;
    }
    for (final cuenta in usuarios) {
      if (cuenta.nombre == publicacion.autor) return cuenta;
    }
    return null;
  }
}

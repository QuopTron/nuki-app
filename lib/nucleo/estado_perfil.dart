part of 'estado.dart';

const claveDemoNuki = 'nuki123';

mixin _AccionesPerfil on _EstadoBase, _CargaEstado {
  Future<String?> iniciarSesionCredenciales({
    required String correo,
    required String clave,
  }) async {
    final normalizado = correoNormalizado(correo);
    Usuario? cuenta;
    for (final u in usuarios) {
      if (correoNormalizado(u.correo) == normalizado) {
        cuenta = u;
        break;
      }
    }
    if (cuenta == null) return 'No existe una cuenta con ese correo.';
    if (cuenta.baneado) return 'Esta cuenta está suspendida.';
    if (cuenta.tieneClave) {
      if (!verificarClave(clave, cuenta.claveSal, cuenta.claveHash)) {
        return 'La contraseña no es correcta.';
      }
    } else {
      if (clave != claveDemoNuki) {
        return 'Esta cuenta antigua usa la clave temporal $claveDemoNuki.';
      }
      final sal = generarSal();
      cuenta.claveSal = sal;
      cuenta.claveHash = hashClave(clave, sal);
      await _guardar('usuarios', usuarios.map((u) => u.aJson()).toList());
    }
    iniciarSesion(cuenta);
    return null;
  }

  Future<String?> registrarCuenta({
    required String nombre,
    required String correo,
    required String clave,
    required String rol,
  }) async {
    final limpio = nombre.trim();
    if (limpio.length < 3) return 'Escribe tu nombre completo.';
    final normalizado = correoNormalizado(correo);
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizado)) {
      return 'El correo no tiene un formato válido.';
    }
    if (clave.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (rol != 'Estudiante' && rol != 'Docente') {
      return 'Selecciona un rol válido.';
    }
    if (usuarios.any((u) => correoNormalizado(u.correo) == normalizado)) {
      return 'Ya existe una cuenta con ese correo.';
    }
    var siguiente = 1;
    for (final u in usuarios) {
      final numero = int.tryParse(u.id.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
      if (numero >= siguiente) siguiente = numero + 1;
    }
    final sal = generarSal();
    final cuenta = Usuario(
      id: 'u$siguiente',
      nombre: limpio,
      correo: normalizado,
      rol: rol,
      iniciales: inicialesDe(limpio),
      claveHash: hashClave(clave, sal),
      claveSal: sal,
      creadoEn: DateTime.now().toUtc().toIso8601String(),
    );
    usuarios.add(cuenta);
    try {
      await _repositorio.guardar(
        'usuarios',
        usuarios.map((u) => u.aJson()).toList(),
      );
    } catch (e) {
      usuarios.remove(cuenta);
      return 'No se pudo registrar la cuenta: $e';
    }
    iniciarSesion(cuenta);
    aviso = 'Cuenta creada y sincronizada.';
    notifyListeners();
    return null;
  }

  Future<void> editarPerfil({
    required String nombre,
    required String correo,
    required String iniciales,
  }) async {
    final cuenta = usuario;
    if (cuenta == null || esInvitado) return _soloLectura();
    cuenta.nombre = nombre;
    cuenta.correo = correo;
    cuenta.iniciales = iniciales;
    notifyListeners();
    await _guardar('usuarios', usuarios.map((u) => u.aJson()).toList());
  }

  Future<void> registrarRacha() async {
    if (!puedeEscribir) return;
    racha++;
    if (logros < 100) logros++;
    notifyListeners();
    await _guardarPerfil();
  }
}

import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/mascota.dart';

part 'acceso_cuenta.dart';

Future<void> abrirHojaAcceso(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const HojaAcceso(),
  );
}

enum _ModoAcceso { entrar, registrar }

class HojaAcceso extends StatefulWidget {
  const HojaAcceso({super.key});

  @override
  State<HojaAcceso> createState() => _HojaAccesoState();
}

class _HojaAccesoState extends State<HojaAcceso> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  final _confirmar = TextEditingController();
  _ModoAcceso _modo = _ModoAcceso.entrar;
  String _rol = 'Estudiante';
  String? _error;
  bool _procesando = false;
  bool _verClave = false;

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _clave.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _enviar(EstadoNuki estado) async {
    if (!(_formulario.currentState?.validate() ?? false)) return;
    setState(() {
      _procesando = true;
      _error = null;
    });
    final error = _modo == _ModoAcceso.entrar
        ? await estado.iniciarSesionCredenciales(
            correo: _correo.text,
            clave: _clave.text,
          )
        : await estado.registrarCuenta(
            nombre: _nombre.text,
            correo: _correo.text,
            clave: _clave.text,
            rol: _rol,
          );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _procesando = false;
        _error = error;
      });
      return;
    }
    Navigator.pop(context);
  }

  void _cambiarModo(_ModoAcceso modo) {
    setState(() {
      _modo = modo;
      _error = null;
      _verClave = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final registrando = _modo == _ModoAcceso.registrar;
    return DraggableScrollableSheet(
      initialChildSize: .82,
      minChildSize: .5,
      maxChildSize: .96,
      expand: false,
      builder: (context, scroll) {
        return Container(
          decoration: const BoxDecoration(
            color: Colores.fondo,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colores.borde,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const MascotaCelula(tamano: 58),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          registrando ? 'Crea tu cuenta' : 'Bienvenido a Nuki',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          registrando
                              ? 'Tu cuenta se guarda en el repositorio'
                              : 'Entra con tu correo y contraseña',
                          style: const TextStyle(
                            color: Colores.gris,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SelectorModo(modo: _modo, onCambio: _cambiarModo),
              const SizedBox(height: 18),
              Form(
                key: _formulario,
                child: Column(
                  children: [
                    if (registrando) ...[
                      TextFormField(
                        controller: _nombre,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (v) => (v?.trim().length ?? 0) < 3
                            ? 'Escribe tu nombre completo.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _correo,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Correo institucional',
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                      ),
                      validator: (v) {
                        final valor = v?.trim() ?? '';
                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(valor)) {
                          return 'Escribe un correo válido.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _clave,
                      obscureText: !_verClave,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _verClave = !_verClave),
                          icon: Icon(
                            _verClave
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                        ),
                      ),
                      validator: (v) => (v?.length ?? 0) < 6
                          ? 'Usa al menos 6 caracteres.'
                          : null,
                    ),
                    if (registrando) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmar,
                        obscureText: !_verClave,
                        decoration: const InputDecoration(
                          labelText: 'Repite la contraseña',
                          prefixIcon: Icon(Icons.lock_reset_rounded),
                        ),
                        validator: (v) => v != _clave.text
                            ? 'Las contraseñas no coinciden.'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _rol,
                        decoration: const InputDecoration(
                          labelText: 'Rol',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Estudiante',
                            child: Text('Estudiante'),
                          ),
                          DropdownMenuItem(
                            value: 'Docente',
                            child: Text('Docente'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _rol = v ?? 'Estudiante'),
                      ),
                    ],
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colores.coral.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colores.coral.withValues(alpha: .35),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colores.coral,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colores.coral,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: FilledButton(
                  onPressed: _procesando ? null : () => _enviar(estado),
                  child: _procesando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : Text(registrando ? 'Crear cuenta' : 'Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _procesando
                    ? null
                    : () => _cambiarModo(
                        registrando
                            ? _ModoAcceso.entrar
                            : _ModoAcceso.registrar,
                      ),
                child: Text(
                  registrando
                      ? 'Ya tengo una cuenta'
                      : 'No tengo cuenta, quiero registrarme',
                ),
              ),
              const SizedBox(height: 6),
              _AccesoDemo(estado: estado),
            ],
          ),
        );
      },
    );
  }
}

class _SelectorModo extends StatelessWidget {
  const _SelectorModo({required this.modo, required this.onCambio});
  final _ModoAcceso modo;
  final ValueChanged<_ModoAcceso> onCambio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colores.borde),
      ),
      child: Row(
        children: [
          for (final opcion in _ModoAcceso.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onCambio(opcion),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: modo == opcion ? Colores.verde : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    opcion == _ModoAcceso.entrar ? 'Entrar' : 'Registrarme',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: modo == opcion ? Colores.fondo : Colores.gris,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

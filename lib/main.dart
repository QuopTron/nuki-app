import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'nucleo/actualizacion.dart';
import 'nucleo/configuracion_repo.dart';
import 'nucleo/estado.dart';
import 'nucleo/fuente_git.dart';
import 'nucleo/repositorio_nuki.dart';
import 'nucleo/tema.dart';
import 'pantallas/bienvenida.dart';
import 'widgets/comunes.dart';
import 'widgets/mascota.dart';
import 'widgets/navegacion.dart';

part 'main_estados.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FuenteContenido? fuente;
  String? error;
  try {
    fuente = await crearFuenteContenido();
  } catch (e) {
    error = e.toString();
  }
  runApp(
    NukiApp(
      repositorio: fuente == null ? null : RepositorioNuki(fuente),
      errorInicial: error,
    ),
  );
}

class NukiApp extends StatefulWidget {
  const NukiApp({super.key, this.repositorio, this.errorInicial});
  final RepositorioNuki? repositorio;
  final String? errorInicial;

  @override
  State<NukiApp> createState() => _NukiAppState();
}

class _NukiAppState extends State<NukiApp> {
  EstadoNuki? _estado;

  @override
  void initState() {
    super.initState();
    final repositorio = widget.repositorio;
    if (repositorio != null) {
      _estado = EstadoNuki(repositorio)..cargar();
    }
  }

  @override
  void dispose() {
    _estado?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estado;
    if (estado == null) {
      return MaterialApp(
        title: 'Nuki',
        debugShowCheckedModeBanner: false,
        theme: temaNuki(),
        home: _ErrorInicio(
          mensaje: widget.errorInicial ?? 'No se pudo iniciar el repositorio.',
          alReintentar: null,
        ),
      );
    }
    return AlcanceNuki(
      estado: estado,
      child: MaterialApp(
        title: 'Nuki',
        debugShowCheckedModeBanner: false,
        theme: temaNuki(),
        home: const _RaizNuki(),
      ),
    );
  }
}

class _AvisoActualizacion extends StatefulWidget {
  const _AvisoActualizacion({super.key, required this.child});
  final Widget child;

  @override
  State<_AvisoActualizacion> createState() => _AvisoActualizacionState();
}

class _AvisoActualizacionState extends State<_AvisoActualizacion> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _comprobar());
  }

  Future<void> _comprobar() async {
    final actualizacion = await ActualizacionNuki.buscar();
    if (!mounted || actualizacion == null || !actualizacion.disponible) return;
    final prefs = await SharedPreferences.getInstance();
    if (!mounted ||
        prefs.getString('nuki_version_ignorada') == actualizacion.version) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (contexto) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(
          Icons.system_update_rounded,
          color: Colores.azul,
          size: 32,
        ),
        title: Text('Nuki ${actualizacion.version} disponible'),
        content: Text(
          'Hay una versión nueva con mejoras y correcciones. Tu progreso se conserva.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colores.gris, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await prefs.setString(
                'nuki_version_ignorada',
                actualizacion.version,
              );
              if (contexto.mounted) Navigator.pop(contexto);
            },
            child: const Text('Más tarde'),
          ),
          FilledButton.icon(
            onPressed: () async {
              final uri = Uri.tryParse(actualizacion.apkUrl);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
              if (contexto.mounted) Navigator.pop(contexto);
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _RaizNuki extends StatelessWidget {
  const _RaizNuki();

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    if (estado.cargando) return const _Cargando();
    if (estado.error != null) {
      return _ErrorInicio(mensaje: estado.error!, alReintentar: estado.cargar);
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: estado.usuario == null
          ? const Bienvenida(key: ValueKey('bienvenida'))
          : const _AvisoActualizacion(
              key: ValueKey('app'),
              child: NavegacionPrincipal(),
            ),
    );
  }
}

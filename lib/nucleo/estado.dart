import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modelos.dart';
import 'repositorio_nuki.dart';
import 'seguridad.dart';
import 'tema.dart';

part 'estado_base_carga.dart';
part 'estado_perfil.dart';
part 'estado_contenido.dart';
part 'estado_foro.dart';
part 'estado_notificaciones.dart';
part 'estado_moderacion.dart';

class _EstadoBase extends ChangeNotifier {
  _EstadoBase(this._repositorio);
  final RepositorioNuki _repositorio;

  bool cargando = true;
  bool guardando = false;
  String? error;
  String? aviso;
  String? ultimaAccion;
  Usuario? usuario;

  List<Materia> materias = [];
  List<Recurso> recursos = [];
  List<Reel> reels = [];
  final Set<int> reelsGustados = {};
  final Set<int> reelsSeguidos = {};
  List<Evaluacion> evaluaciones = [];
  List<Publicacion> publicaciones = [];
  List<Apunte> apuntes = [];
  List<NotificacionNuki> notificaciones = [];
  List<Usuario> usuarios = [];
  List<ModeloAnatomico> modelos = [];
  InfoRepositorio? infoRepositorio;
  final Map<String, int> resultados = {};
  Map<String, RegistroPerfil> _perfiles = {};
  int racha = 0;
  int logros = 0;
  double promedio = 0;
  int _siguienteId = 100;
  int _siguienteComentarioId = 1;
  int _siguienteApunteId = 1;
  int _siguienteRecursoId = 1;
  int _siguienteEvaluacionId = 1;
  int _siguienteReelId = 1;

  String get uid => usuario?.id ?? 'invitado';
  bool get esInvitado => usuario?.esInvitado ?? true;
  bool get esAdmin => usuario?.esAdmin ?? false;
  bool get esDocente => usuario?.esDocente ?? false;
  bool get puedeGestionar => esAdmin || esDocente;
  bool get puedeEscribir => usuario != null && !esInvitado;
  bool get puedeModerar => esAdmin;
  int get noLeidas => notificaciones.where((n) => !n.leida).length;
  List<Materia> get materiasInscritas =>
      materias.where((m) => m.inscrita).toList();
  List<Usuario> get usuariosActivos =>
      usuarios.where((u) => !u.baneado).toList();
  int get usuariosBaneados => usuarios.where((u) => u.baneado).length;
  List<Publicacion> get publicacionesReportadas =>
      publicaciones.where((p) => p.reportes.isNotEmpty).toList();
  Usuario? get administrador {
    for (final cuenta in usuarios) {
      if (cuenta.esAdmin) return cuenta;
    }
    return null;
  }

  bool esPropio(String autorId) => autorId.isNotEmpty && autorId == uid;
  bool puedeEditar(String autorId) =>
      esAdmin || (puedeEscribir && esPropio(autorId));
}

class EstadoNuki extends _EstadoBase
    with
        _CargaEstado,
        _AccionesPerfil,
        _AccionesContenido,
        _AccionesForo,
        _AccionesNotificaciones,
        _AccionesModeracion {
  EstadoNuki(super.repositorio);
}

class AlcanceNuki extends InheritedNotifier<EstadoNuki> {
  const AlcanceNuki({
    super.key,
    required EstadoNuki estado,
    required super.child,
  }) : super(notifier: estado);

  static EstadoNuki de(BuildContext context) {
    final alcance = context.dependOnInheritedWidgetOfExactType<AlcanceNuki>();
    assert(alcance != null, 'AlcanceNuki no encontrado.');
    return alcance!.notifier!;
  }

  static EstadoNuki leer(BuildContext context) {
    final alcance = context.getInheritedWidgetOfExactType<AlcanceNuki>();
    assert(alcance != null, 'AlcanceNuki no encontrado.');
    return alcance!.notifier!;
  }
}

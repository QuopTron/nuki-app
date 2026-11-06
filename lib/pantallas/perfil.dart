import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import 'admin.dart';
import 'notificaciones.dart';

part 'perfil_cabecera.dart';
part 'perfil_editar.dart';
part 'perfil_logros.dart';
part 'perfil_progreso.dart';
part 'perfil_repositorio.dart';
part 'perfil_opciones.dart';

class PerfilPantalla extends StatelessWidget {
  const PerfilPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final usuario = estado.usuario;
    if (usuario == null) return const SizedBox.shrink();
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, restricciones) {
          final ancho = restricciones.maxWidth;
          final cabecera = _Cabecera(estado: estado);
          final progreso = _Progreso(estado: estado);
          final logros = _Logros(estado: estado);
          final opciones = _Opciones(estado: estado);
          final repo = _Repositorio(estado: estado);
          if (ancho < 820) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                cabecera,
                const SizedBox(height: 14),
                progreso,
                const SizedBox(height: 14),
                logros,
                const SizedBox(height: 14),
                repo,
                const SizedBox(height: 14),
                opciones,
              ],
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      cabecera,
                      const SizedBox(height: 14),
                      progreso,
                      const SizedBox(height: 14),
                      logros,
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [repo, const SizedBox(height: 14), opciones],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

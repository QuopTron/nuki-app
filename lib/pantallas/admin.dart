import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/repositorio_nuki.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/modales.dart';

part 'admin_acciones.dart';
part 'admin_reportes.dart';
part 'admin_usuarios.dart';
part 'admin_tarjetas.dart';
part 'admin_repo.dart';

class AdminPantalla extends StatefulWidget {
  const AdminPantalla({super.key});

  @override
  State<AdminPantalla> createState() => _AdminPantallaState();
}

class _AdminPantallaState extends State<AdminPantalla> with _AdminAcciones {
  String _consulta = '';

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final info = estado.infoRepositorio;
    final usuarios = estado.usuarios.where((u) {
      final q = _consulta.toLowerCase();
      return u.nombre.toLowerCase().contains(q) ||
          u.correo.toLowerCase().contains(q);
    }).toList();
    final reportados = estado.usuarios.where((u) => u.reportes > 0).toList()
      ..sort((a, b) => b.reportes.compareTo(a.reportes));
    final totalReportes = estado.usuarios.fold<int>(
      0,
      (suma, u) => suma + u.reportes,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Administración', style: TextStyle(fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Etiqueta(
              texto: 'ADMIN',
              color: Colores.coral,
              icono: Icons.shield_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          LayoutBuilder(
            builder: (context, restricciones) => GridView.count(
              crossAxisCount: restricciones.maxWidth >= 640 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: restricciones.maxWidth >= 640 ? 1.25 : 1.7,
              children: [
                _Metrica(
                  valor: '${estado.usuarios.length}',
                  etiqueta: 'Usuarios',
                  icono: Icons.people_alt_rounded,
                  color: Colores.azulMedio,
                ),
                _Metrica(
                  valor: '${estado.usuariosActivos.length}',
                  etiqueta: 'Activos',
                  icono: Icons.verified_user_rounded,
                  color: Colores.turquesa,
                ),
                _Metrica(
                  valor: '${estado.usuariosBaneados}',
                  etiqueta: 'Baneados',
                  icono: Icons.block_rounded,
                  color: Colores.coral,
                ),
                _Metrica(
                  valor: '$totalReportes',
                  etiqueta: 'Reportes',
                  icono: Icons.flag_rounded,
                  color: Colores.ambar,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _TarjetaRepoAdmin(
            info: info,
            onRestablecer: () => _restablecer(context, estado),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: TituloSeccion(titulo: 'Gestión de usuarios'),
              ),
              TextButton.icon(
                onPressed: () => _crearUsuarioAdmin(context, estado),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                label: const Text('Usuario'),
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _enviarAviso(context, estado),
                icon: const Icon(Icons.campaign_rounded, size: 16),
                label: const Text('Aviso'),
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          CampoBusqueda(
            hint: 'Buscar usuario...',
            onChanged: (v) => setState(() => _consulta = v),
          ),
          const SizedBox(height: 10),
          if (usuarios.isEmpty)
            const Tarjeta(
              child: Text(
                'No se encontraron usuarios.',
                style: TextStyle(color: Colores.gris),
              ),
            )
          else
            for (final cuenta in usuarios) ...[
              _UsuarioAdmin(
                cuenta: cuenta,
                esUnoMismo: cuenta.id == estado.usuario?.id,
                onBan: () => _cambiarEstado(context, estado, cuenta),
                onRol: () => _cambiarRolAdmin(context, estado, cuenta),
              ),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 14),
          TituloSeccion(
            titulo: 'Publicaciones reportadas',
            accion: '${estado.publicacionesReportadas.length}',
          ),
          const SizedBox(height: 8),
          if (estado.publicacionesReportadas.isEmpty)
            const Tarjeta(
              child: Text(
                'El foro está limpio: no hay publicaciones reportadas.',
                style: TextStyle(color: Colores.gris),
              ),
            )
          else
            for (final publicacion in estado.publicacionesReportadas) ...[
              _PublicacionReporteAdmin(publicacion: publicacion),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 14),
          const TituloSeccion(titulo: 'Usuarios con reportes'),
          const SizedBox(height: 8),
          if (reportados.isEmpty)
            const Tarjeta(
              child: Text(
                'Sin reportes de usuarios pendientes.',
                style: TextStyle(color: Colores.gris),
              ),
            )
          else
            for (final cuenta in reportados) ...[
              _ReporteAdmin(
                cuenta: cuenta,
                onBan: () => _cambiarEstado(context, estado, cuenta),
              ),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

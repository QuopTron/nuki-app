part of 'perfil.dart';

class _Opciones extends StatelessWidget {
  const _Opciones({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    final usuario = estado.usuario!;
    return Column(
      children: [
        _Opcion(
          icono: Icons.notifications_none_rounded,
          titulo: 'Notificaciones',
          subtitulo: estado.noLeidas > 0
              ? '${estado.noLeidas} sin leer'
              : 'Todo al día',
          color: Colores.azulMedio,
          insignia: estado.noLeidas,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificacionesPantalla()),
          ),
        ),
        _Opcion(
          icono: Icons.settings_outlined,
          titulo: 'Configuración',
          subtitulo: 'Cuenta, permisos y repositorio',
          color: Colores.gris,
          onTap: () => _abrirConfiguracion(context, estado),
        ),
        _Opcion(
          icono: Icons.help_outline_rounded,
          titulo: 'Ayuda y soporte',
          subtitulo: 'Preguntas frecuentes y contacto',
          color: Colores.turquesa,
          onTap: () => mostrarMensaje(context, 'Soporte: soporte@nuki.app'),
        ),
        if (usuario.esAdmin)
          _Opcion(
            icono: Icons.admin_panel_settings_outlined,
            titulo: 'Panel de administración',
            subtitulo: 'Usuarios, roles, reportes y contenido',
            color: Colores.coral,
            insignia: estado.publicacionesReportadas.length,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AdminPantalla())),
          ),
        if (usuario.esDocente)
          _Opcion(
            icono: Icons.upload_file_rounded,
            titulo: 'Publicar contenido',
            subtitulo: 'Sube PDFs y crea evaluaciones',
            color: Colores.violeta,
            onTap: () => mostrarMensaje(
              context,
              'Usa el botón Subir en Recursos o Crear en Evaluaciones.',
            ),
          ),
        _Opcion(
          icono: Icons.logout_rounded,
          titulo: 'Cerrar sesión',
          subtitulo: 'Volver a la pantalla de acceso',
          color: Colores.coral,
          onTap: () => _confirmarSalida(context),
        ),
      ],
    );
  }

  Future<void> _confirmarSalida(BuildContext context) async {
    final estado = AlcanceNuki.leer(context);
    final salir = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('¿Cerrar sesión?'),
        content: const Text('Tu progreso ya está guardado en el repositorio.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (salir == true) estado.cerrarSesion();
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
    this.insignia,
  });
  final IconData icono;
  final String titulo, subtitulo;
  final Color color;
  final VoidCallback onTap;
  final int? insignia;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Tarjeta(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconoMateria(icono: icono, color: color, tamano: 40),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: const TextStyle(color: Colores.gris, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            if (insignia != null && insignia! > 0)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colores.coral,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$insignia',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colores.gris,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

part of 'admin.dart';

mixin _AdminAcciones on State<AdminPantalla> {
  Future<void> _cambiarEstado(
    BuildContext context,
    EstadoNuki estado,
    Usuario cuenta,
  ) async {
    final banear = !cuenta.baneado;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(banear ? '¿Banear usuario?' : '¿Reactivar usuario?'),
        content: Text(
          banear
              ? '${cuenta.nombre} no podrá acceder a la plataforma.'
              : '${cuenta.nombre} recuperará el acceso.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            style: FilledButton.styleFrom(
              backgroundColor: banear ? Colores.coral : Colores.turquesa,
            ),
            child: Text(banear ? 'Banear' : 'Reactivar'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await estado.alternarBan(cuenta);
      if (context.mounted) {
        mostrarMensaje(context, 'usuarios.json actualizado: ${cuenta.nombre}.');
      }
    }
  }

  Future<void> _restablecer(BuildContext context, EstadoNuki estado) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Restaurar contenido'),
        content: const Text(
          'Se descartarán los cambios locales del repositorio emulado y se volverá al contenido base.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contexto, true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await estado.restablecerContenido();
      if (context.mounted) {
        mostrarMensaje(context, 'Repositorio local restaurado.');
      }
    }
  }

  Future<void> _enviarAviso(BuildContext context, EstadoNuki estado) async {
    final titulo = TextEditingController();
    final detalle = TextEditingController();
    final enviar = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Aviso global'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titulo,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Título del aviso'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: detalle,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Detalle'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (titulo.text.trim().isEmpty) return;
              Navigator.pop(contexto, true);
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
    if (enviar == true) {
      await estado.enviarAviso(titulo.text.trim(), detalle.text.trim());
      if (context.mounted) {
        mostrarMensaje(context, 'Aviso publicado y versionado.');
      }
    }
    titulo.dispose();
    detalle.dispose();
  }
}

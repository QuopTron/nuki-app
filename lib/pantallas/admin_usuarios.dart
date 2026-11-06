part of 'admin.dart';

Future<void> _crearUsuarioAdmin(BuildContext context, EstadoNuki estado) async {
  final nombre = TextEditingController();
  final correo = TextEditingController();
  var rol = 'Estudiante';
  final crear = await showDialog<bool>(
    context: context,
    builder: (contexto) => StatefulBuilder(
      builder: (contexto, setStateDialogo) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Nuevo usuario',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombre,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Nombre completo'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Correo electrónico'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: rol,
              decoration: const InputDecoration(hintText: 'Rol'),
              items: const [
                DropdownMenuItem(
                  value: 'Estudiante',
                  child: Text('Estudiante'),
                ),
                DropdownMenuItem(value: 'Docente', child: Text('Docente')),
                DropdownMenuItem(
                  value: 'Administrador',
                  child: Text('Administrador'),
                ),
              ],
              onChanged: (valor) => setStateDialogo(() => rol = valor ?? rol),
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
              if (nombre.text.trim().isEmpty || correo.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(contexto, true);
            },
            child: const Text('Crear usuario'),
          ),
        ],
      ),
    ),
  );
  if (crear == true) {
    await estado.crearUsuario(
      nombre: nombre.text.trim(),
      correo: correo.text.trim(),
      rol: rol,
    );
    if (context.mounted) {
      mostrarMensaje(context, 'Usuario creado en usuarios.json.');
    }
  }
  nombre.dispose();
  correo.dispose();
}

Future<void> _cambiarRolAdmin(
  BuildContext context,
  EstadoNuki estado,
  Usuario cuenta,
) async {
  var rol = cuenta.rol;
  final guardar = await showDialog<bool>(
    context: context,
    builder: (contexto) => StatefulBuilder(
      builder: (contexto, setStateDialogo) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text('Rol de ${cuenta.nombre}'),
        content: RadioGroup<String>(
          groupValue: rol,
          onChanged: (valor) => setStateDialogo(() => rol = valor ?? rol),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final opcion in const [
                'Estudiante',
                'Docente',
                'Administrador',
              ])
                RadioListTile<String>(
                  value: opcion,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(opcion),
                ),
              const SizedBox(height: 4),
              const Text(
                'Docentes pueden subir recursos y crear evaluaciones. Administradores además moderan usuarios y reportes.',
                style: TextStyle(fontSize: 10.5, color: Colores.gris),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: rol == cuenta.rol
                ? null
                : () => Navigator.pop(contexto, true),
            child: const Text('Actualizar rol'),
          ),
        ],
      ),
    ),
  );
  if (guardar == true) {
    await estado.cambiarRol(cuenta, rol);
    if (context.mounted) {
      mostrarMensaje(
        context,
        'Rol actualizado: ${cuenta.nombre} ahora es $rol.',
      );
    }
  }
}

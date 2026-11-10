part of 'perfil.dart';

Future<void> _editarPerfil(BuildContext context, EstadoNuki estado) async {
  final cuenta = estado.usuario;
  if (cuenta == null) return;
  if (estado.esInvitado) {
    mostrarMensaje(
      context,
      'Inicia sesión con una cuenta para editar tu perfil.',
    );
    return;
  }
  final nombre = TextEditingController(text: cuenta.nombre);
  final correo = TextEditingController(text: cuenta.correo);
  final iniciales = TextEditingController(text: cuenta.iniciales);
  final guardar = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Editar perfil',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(hintText: 'Nombre completo'),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Correo electrónico'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: iniciales,
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'Iniciales (2 letras)',
                counterText: '',
              ),
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
          onPressed: () {
            if (nombre.text.trim().isEmpty || correo.text.trim().isEmpty) {
              return;
            }
            Navigator.pop(contexto, true);
          },
          child: const Text('Guardar cambios'),
        ),
      ],
    ),
  );
  if (guardar == true) {
    final letras = iniciales.text.trim().toUpperCase();
    await estado.editarPerfil(
      nombre: nombre.text.trim(),
      correo: correo.text.trim(),
      iniciales: letras.isEmpty ? cuenta.iniciales : letras,
    );
    if (context.mounted) {
      mostrarMensaje(context, 'Perfil actualizado correctamente.');
    }
  }
  nombre.dispose();
  correo.dispose();
  iniciales.dispose();
}

Future<void> _abrirConfiguracion(
  BuildContext context,
  EstadoNuki estado,
) async {
  final usuario = estado.usuario;
  if (usuario == null) return;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _Ajuste(
              icono: Icons.person_outline_rounded,
              titulo: 'Cuenta',
              detalle: '${usuario.correo} · ${usuario.rol}',
            ),
            _Ajuste(
              icono: Icons.storage_rounded,
              titulo: 'Fuente de contenido',
              detalle: estado.infoRepositorio?.fuente ?? 'Sin conexión',
            ),
            _Ajuste(
              icono: Icons.account_tree_rounded,
              titulo: 'Rama y archivos',
              detalle:
                  '${estado.infoRepositorio?.rama ?? 'main'} · ${estado.infoRepositorio?.archivos ?? 0} archivos',
            ),
            _Ajuste(
              icono: Icons.verified_user_outlined,
              titulo: 'Permisos',
              detalle: estado.puedeModerar
                  ? 'Moderación total'
                  : estado.puedeGestionar
                  ? 'Docencia y contenido'
                  : estado.puedeEscribir
                  ? 'Foro, apuntes y evaluaciones'
                  : 'Solo lectura',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(contexto);
                      await estado.cargar();
                      if (context.mounted) {
                        mostrarMensaje(
                          context,
                          'Contenido sincronizado desde el repositorio.',
                        );
                      }
                    },
                    icon: const Icon(Icons.sync_rounded, size: 17),
                    label: const Text('Sincronizar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(contexto);
                      estado.cerrarSesion();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colores.coral,
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 17),
                    label: const Text('Salir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _Ajuste extends StatelessWidget {
  const _Ajuste({
    required this.icono,
    required this.titulo,
    required this.detalle,
  });
  final IconData icono;
  final String titulo, detalle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icono, size: 18, color: Colores.azulMedio),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  detalle,
                  style: const TextStyle(fontSize: 10.5, color: Colores.gris),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

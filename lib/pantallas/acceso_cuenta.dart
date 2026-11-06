part of 'acceso.dart';

class _AccesoDemo extends StatelessWidget {
  const _AccesoDemo({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    final cuentas = estado.usuarios.where((u) => !u.baneado).toList();
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              estado.entrarInvitado();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.visibility_rounded, size: 18),
            label: const Text('Explorar como invitado'),
          ),
        ),
        const SizedBox(height: 10),
        Tarjeta(
          padding: EdgeInsets.zero,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(
                Icons.science_outlined,
                color: Colores.turquesa,
              ),
              title: const Text(
                'Cuentas de demostración',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              subtitle: const Text(
                'Clave temporal: $claveDemoNuki',
                style: TextStyle(color: Colores.gris, fontSize: 10.5),
              ),
              children: [
                for (final cuenta in cuentas)
                  _CuentaNuki(cuenta: cuenta, estado: estado),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CuentaNuki extends StatelessWidget {
  const _CuentaNuki({required this.cuenta, required this.estado});
  final Usuario cuenta;
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    final color = cuenta.esAdmin
        ? Colores.coral
        : cuenta.rol == 'Docente'
        ? Colores.violeta
        : Colores.azulMedio;
    return ListTile(
      onTap: () async {
        final error = await estado.iniciarSesionCredenciales(
          correo: cuenta.correo,
          clave: claveDemoNuki,
        );
        if (!context.mounted) return;
        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
          return;
        }
        Navigator.pop(context);
      },
      leading: AvatarNuki(
        iniciales: cuenta.iniciales,
        tamano: 38,
        colores: [color.withValues(alpha: .7), color],
      ),
      title: Text(
        cuenta.nombre,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
      ),
      subtitle: Text(
        cuenta.correo,
        style: const TextStyle(color: Colores.gris, fontSize: 10.5),
      ),
      trailing: Etiqueta(texto: cuenta.rol, color: color),
    );
  }
}

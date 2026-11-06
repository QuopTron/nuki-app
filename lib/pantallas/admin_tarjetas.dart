part of 'admin.dart';

class _Metrica extends StatelessWidget {
  const _Metrica({
    required this.valor,
    required this.etiqueta,
    required this.icono,
    required this.color,
  });
  final String valor, etiqueta;
  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: color, size: 20),
          const Spacer(),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 10.5,
              color: Colores.gris,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsuarioAdmin extends StatelessWidget {
  const _UsuarioAdmin({
    required this.cuenta,
    required this.esUnoMismo,
    required this.onBan,
    required this.onRol,
  });
  final Usuario cuenta;
  final bool esUnoMismo;
  final VoidCallback onBan, onRol;

  @override
  Widget build(BuildContext context) {
    final color = cuenta.baneado
        ? Colores.coral
        : cuenta.esAdmin
        ? Colores.violeta
        : Colores.azulMedio;
    return Tarjeta(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          AvatarNuki(
            iniciales: cuenta.iniciales,
            tamano: 40,
            colores: [color.withValues(alpha: .7), color],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        cuenta.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Etiqueta(texto: cuenta.rol, color: color),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  cuenta.correo,
                  style: const TextStyle(color: Colores.gris, fontSize: 10.5),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      cuenta.baneado
                          ? Icons.block_rounded
                          : Icons.check_circle_rounded,
                      size: 12,
                      color: cuenta.baneado ? Colores.coral : Colores.turquesa,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      cuenta.estado,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: cuenta.baneado
                            ? Colores.coral
                            : Colores.turquesa,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${cuenta.materias} materias · ${cuenta.reportes} reportes',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Colores.gris,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!esUnoMismo)
            PopupMenuButton<String>(
              tooltip: 'Gestionar usuario',
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colores.gris,
                size: 19,
              ),
              onSelected: (accion) => accion == 'rol' ? onRol() : onBan(),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'rol',
                  child: Text('Cambiar rol (${cuenta.rol})'),
                ),
                PopupMenuItem(
                  value: 'ban',
                  child: Text(
                    cuenta.baneado ? 'Reactivar acceso' : 'Banear usuario',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

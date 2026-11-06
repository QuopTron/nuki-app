part of 'notificaciones.dart';

class _TarjetaNotificacion extends StatelessWidget {
  const _TarjetaNotificacion({required this.notificacion});
  final NotificacionNuki notificacion;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final noLeida = !notificacion.leida;
    return Tarjeta(
      onTap: () => estado.marcarLeida(notificacion),
      color: noLeida ? Colores.tarjeta : Colores.tarjeta.withValues(alpha: .72),
      borde: noLeida ? notificacion.color.withValues(alpha: .25) : null,
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notificacion.color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              notificacion.icono,
              color: notificacion.color,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notificacion.titulo,
                        style: TextStyle(
                          fontWeight: noLeida
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (noLeida)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: notificacion.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (estado.puedeModerar)
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          size: 17,
                          color: Colores.gris,
                        ),
                        onSelected: (_) =>
                            estado.eliminarNotificacion(notificacion),
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'eliminar',
                            child: Text('Eliminar aviso'),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  notificacion.detalle,
                  style: const TextStyle(
                    color: Colores.gris,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      notificacion.hace,
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 9.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· ${notificacion.tipo}',
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _avisoRapido(BuildContext context, EstadoNuki estado) async {
  final titulo = TextEditingController();
  final detalle = TextEditingController();
  final enviar = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Nuevo aviso',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
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
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Detalle para la comunidad',
            ),
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
          child: const Text('Publicar'),
        ),
      ],
    ),
  );
  if (enviar == true) {
    await estado.enviarAviso(titulo.text.trim(), detalle.text.trim());
    if (context.mounted) {
      mostrarMensaje(context, 'Aviso enviado a todos los usuarios.');
    }
  }
  titulo.dispose();
  detalle.dispose();
}

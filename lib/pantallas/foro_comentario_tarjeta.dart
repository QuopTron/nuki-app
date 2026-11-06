part of 'foro.dart';

class _ComentarioTarjeta extends StatelessWidget {
  const _ComentarioTarjeta({
    required this.comentario,
    required this.onLike,
    required this.onEliminar,
  });
  final Comentario comentario;
  final VoidCallback onLike, onEliminar;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final activo = estado.usuario != null && comentario.leGusta(estado.uid);
    final puedeEliminar = estado.puedeEditar(comentario.autorId);
    return Tarjeta(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarNuki(
            iniciales: comentario.iniciales,
            tamano: 32,
            colores: const [Colores.celeste, Colores.azulMedio],
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${comentario.autor} · ${comentario.tiempo}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colores.gris,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comentario.texto,
                  style: const TextStyle(fontSize: 12.5, height: 1.4),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    InkWell(
                      onTap: onLike,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              activo
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 14,
                              color: activo ? Colores.coral : Colores.gris,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${comentario.reacciones}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colores.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (puedeEliminar)
                      InkWell(
                        onTap: onEliminar,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 15,
                            color: Colores.coral,
                          ),
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

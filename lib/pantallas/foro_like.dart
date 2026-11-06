part of 'foro.dart';

class _MiniLike extends StatelessWidget {
  const _MiniLike({required this.comentario, required this.onTap});
  final Comentario comentario;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final activo = estado.usuario != null && comentario.leGusta(estado.uid);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activo ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 13,
              color: activo ? Colores.coral : Colores.gris,
            ),
            if (comentario.reacciones > 0) ...[
              const SizedBox(width: 2),
              Text(
                '${comentario.reacciones}',
                style: const TextStyle(fontSize: 9, color: Colores.gris),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

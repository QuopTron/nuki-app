part of 'foro.dart';

class _CabeceraForo extends StatelessWidget {
  const _CabeceraForo({required this.activos});
  final int activos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Foro',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Aprende en comunidad',
                  style: TextStyle(color: Colores.gris, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: Colores.cielo,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people_alt_rounded,
                  size: 14,
                  color: Colores.azulMedio,
                ),
                const SizedBox(width: 5),
                Text(
                  '$activos activos',
                  style: const TextStyle(
                    color: Colores.azulMedio,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

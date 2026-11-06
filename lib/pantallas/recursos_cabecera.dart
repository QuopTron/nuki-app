part of 'recursos.dart';

class _CabeceraRecursos extends StatelessWidget {
  const _CabeceraRecursos();

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
                  'Recursos',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Biblioteca académica versionada',
                  style: TextStyle(color: Colores.gris, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colores.cielo,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_library_rounded,
              color: Colores.azulMedio,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _PestanasRecursos extends StatelessWidget {
  const _PestanasRecursos({
    required this.pestanas,
    required this.activa,
    required this.onCambio,
  });
  final List<String> pestanas;
  final int activa;
  final ValueChanged<int> onCambio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: pestanas.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onCambio(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: activa == i ? Colores.azul : Colores.tarjeta,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: activa == i ? Colores.azul : Colores.borde,
              ),
            ),
            child: Text(
              pestanas[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: activa == i ? Colores.fondo : Colores.gris,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

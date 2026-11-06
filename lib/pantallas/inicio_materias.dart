part of 'inicio.dart';

class _MateriaMini extends StatelessWidget {
  const _MateriaMini({required this.materia});
  final Materia materia;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 236,
      child: Tarjeta(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetalleMateriaPantalla(materia: materia),
          ),
        ),
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconoMateria(
                  icono: materia.icono,
                  color: materia.color,
                  tamano: 38,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        materia.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      Text(
                        '${materia.completadas}/${materia.total} temas',
                        style: const TextStyle(
                          color: Colores.gris,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            BarraAvance(valor: materia.avance, color: materia.color, alto: 5),
          ],
        ),
      ),
    );
  }
}

class _Racha extends StatelessWidget {
  const _Racha({required this.racha});
  final int racha;

  static const _dias = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colores.ambar.withValues(alpha: .3)),
        gradient: const LinearGradient(
          colors: [Colores.tarjetaAlta, Colores.tarjeta],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colores.ambar.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colores.ambar,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$racha ${racha == 1 ? 'día seguido' : 'días seguidos'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Colores.texto,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    for (var i = 0; i < _dias.length; i++)
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < racha
                              ? Colores.ambar
                              : Colores.tarjetaAlta,
                        ),
                        child: Text(
                          _dias[i],
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: i < racha ? Colores.fondo : Colores.gris,
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

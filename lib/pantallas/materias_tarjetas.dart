part of 'materias.dart';

class _Pastilla extends StatelessWidget {
  const _Pastilla({
    required this.texto,
    required this.activa,
    required this.onTap,
  });
  final String texto;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: activa ? Colores.azul : Colores.tarjeta,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: activa ? Colores.azul : Colores.borde),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: activa ? Colores.fondo : Colores.gris,
          ),
        ),
      ),
    );
  }
}

class _TarjetaMateria extends StatelessWidget {
  const _TarjetaMateria({required this.materia, required this.onInscribir});
  final Materia materia;
  final VoidCallback onInscribir;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetalleMateriaPantalla(materia: materia),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          IconoMateria(icono: materia.icono, color: materia.color, tamano: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        materia.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (!materia.inscrita)
                      GestureDetector(
                        onTap: onInscribir,
                        child: const Etiqueta(
                          texto: 'Inscribirme',
                          color: Colores.azulMedio,
                        ),
                      )
                    else
                      Text(
                        '${materia.completadas}/${materia.total}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                          color: Colores.gris,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  materia.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colores.gris, fontSize: 11.5),
                ),
                const SizedBox(height: 9),
                BarraAvance(
                  valor: materia.avance,
                  color: materia.color,
                  alto: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: Colores.gris),
        ],
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tarjeta(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.search_off_rounded, size: 36, color: Colores.gris),
            SizedBox(height: 8),
            Text(
              'No encontramos materias',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'Prueba con otro filtro o término.',
              style: TextStyle(color: Colores.gris, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

part of 'inicio.dart';

class _Campana extends StatelessWidget {
  const _Campana({required this.noLeidas});
  final int noLeidas;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificacionesPantalla()),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Colores.tarjeta,
            foregroundColor: Colores.verde,
          ),
        ),
        if (noLeidas > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints: const BoxConstraints(minWidth: 17),
              decoration: const BoxDecoration(
                color: Colores.coral,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$noLeidas',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SigueAvanzando extends StatelessWidget {
  const _SigueAvanzando({required this.materia});
  final Materia materia;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetalleMateriaPantalla(materia: materia),
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sigue avanzando',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colores.gris,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  materia.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: BarraAvance(
                        valor: materia.avance,
                        color: materia.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${materia.completadas}/${materia.total}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colores.gris,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DetalleMateriaPantalla(materia: materia),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      textStyle: const TextStyle(fontSize: 11.5),
                    ),
                    child: const Text('Ver progreso'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        materia.color.withValues(alpha: .22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Visor3D(
                  icono: materia.icono,
                  colores: [materia.color, Colores.azul],
                  tamano: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccesoRapido extends StatelessWidget {
  const _AccesoRapido({
    required this.icono,
    required this.texto,
    required this.color,
    required this.onTap,
  });
  final IconData icono;
  final String texto;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      radio: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconoMateria(icono: icono, color: color, tamano: 40),
          const SizedBox(height: 8),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

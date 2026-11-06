part of 'inicio.dart';

class _EstadisticasInicio extends StatelessWidget {
  const _EstadisticasInicio({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniEstadistica(
            icono: Icons.local_fire_department_rounded,
            valor: '${estado.racha}',
            texto: 'días de racha',
            color: Colores.ambar,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniEstadistica(
            icono: Icons.bolt_rounded,
            valor: estado.promedio > 0
                ? estado.promedio.toStringAsFixed(1)
                : '0.0',
            texto: 'promedio',
            color: Colores.verde,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniEstadistica(
            icono: Icons.workspace_premium_rounded,
            valor: '${estado.logros}',
            texto: 'logros',
            color: Colores.celeste,
          ),
        ),
      ],
    );
  }
}

class _MiniEstadistica extends StatelessWidget {
  const _MiniEstadistica({
    required this.icono,
    required this.valor,
    required this.texto,
    required this.color,
  });
  final IconData icono;
  final String valor, texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colores.borde),
      ),
      child: Column(
        children: [
          Icon(icono, size: 18, color: color),
          const SizedBox(height: 3),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          Text(
            texto,
            style: const TextStyle(
              color: Colores.gris,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PodriaInteresarte extends StatelessWidget {
  const _PodriaInteresarte();

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    if (estado.reels.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TituloSeccion(
          titulo: 'Podría interesarte',
          accion: 'Ver reels',
          onAccion: () => ControlNavegacion.abrir(context, 2),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 142,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: estado.reels.take(6).length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final reel = estado.reels[i];
              return GestureDetector(
                onTap: () => ControlNavegacion.abrir(context, 2),
                child: Container(
                  width: 190,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: reel.color.withValues(alpha: .38),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        reel.color.withValues(alpha: .35),
                        Colores.fondoProfundo,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(reel.icono, color: reel.color, size: 22),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colores.fondo.withValues(alpha: .5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              reel.duracion,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colores.texto,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        reel.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reel.autor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colores.gris,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RutaAprendizaje extends StatelessWidget {
  const _RutaAprendizaje();
  final _colores = const [
    Color(0xFF00E676),
    Color(0xFF6C5CE7),
    Color(0xFF0984E3),
    Color(0xFFFF7675),
  ];

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final materias = estado.materiasInscritas.take(4).toList();
    if (materias.isEmpty) return const SizedBox.shrink();
    return Tarjeta(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu ruta de aprendizaje',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          const Text(
            'Avanza paso a paso por tus materias',
            style: TextStyle(color: Colores.gris, fontSize: 11),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < materias.length; i++)
            _PasoRuta(
              materia: materias[i],
              color: _colores[i % _colores.length],
              ultimo: i == materias.length - 1,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetalleMateriaPantalla(materia: materias[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PasoRuta extends StatelessWidget {
  const _PasoRuta({
    required this.materia,
    required this.color,
    required this.ultimo,
    required this.onTap,
  });
  final Materia materia;
  final Color color;
  final bool ultimo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: .18),
                    border: Border.all(color: color, width: 1.5),
                  ),
                  child: Icon(
                    materia.avance >= 1
                        ? Icons.check_rounded
                        : Icons.play_arrow_rounded,
                    size: 15,
                    color: color,
                  ),
                ),
                if (!ultimo)
                  Expanded(child: Container(width: 2, color: Colores.borde)),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materia.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${materia.completadas} de ${materia.total} temas completados',
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    BarraAvance(valor: materia.avance, color: color, alto: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

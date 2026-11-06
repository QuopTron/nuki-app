part of 'recursos.dart';

class _TarjetaRecurso extends StatelessWidget {
  const _TarjetaRecurso({required this.recurso});
  final Recurso recurso;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      onTap: () => _abrirRecurso(context, AlcanceNuki.de(context), recurso),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 50,
            decoration: BoxDecoration(
              color: recurso.color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(recurso.icono, color: recurso.color, size: 23),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recurso.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  recurso.autor,
                  style: const TextStyle(color: Colores.gris, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Etiqueta(texto: recurso.tipo, color: recurso.color),
                    const SizedBox(width: 6),
                    Text(
                      recurso.tamano,
                      style: const TextStyle(color: Colores.gris, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                _abrirRecurso(context, AlcanceNuki.de(context), recurso),
            icon: const Icon(Icons.download_rounded, color: Colores.azulMedio),
            tooltip: 'Abrir recurso',
          ),
        ],
      ),
    );
  }
}

class _Apuntes extends StatelessWidget {
  const _Apuntes({required this.consulta});
  final String consulta;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final apuntes = estado.apuntes
        .where(
          (a) =>
              a.materia.toLowerCase().contains(consulta.toLowerCase()) ||
              a.titulo.toLowerCase().contains(consulta.toLowerCase()),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        Tarjeta(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ApuntesPantalla())),
          color: Colores.cielo,
          borde: Colores.celeste,
          child: Column(
            children: [
              const Icon(
                Icons.note_add_rounded,
                color: Colores.azulMedio,
                size: 34,
              ),
              const SizedBox(height: 8),
              const Text(
                'Crear nuevo apunte',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                'Escribe, sube o digitaliza\ntus apuntes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colores.gris.withValues(alpha: .9),
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        TituloSeccion(
          titulo: 'Mis carpetas',
          accion: 'Ver todo',
          onAccion: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ApuntesPantalla())),
        ),
        const SizedBox(height: 8),
        for (final apunte in apuntes) ...[
          Tarjeta(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ApuntesPantalla())),
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                IconoMateria(
                  icono: apunte.icono,
                  color: apunte.color,
                  tamano: 42,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apunte.materia,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${apunte.fecha} · ${apunte.titulo}',
                        style: const TextStyle(
                          color: Colores.gris,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colores.gris),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (apuntes.isEmpty)
          const Tarjeta(
            child: Text(
              'No hay apuntes guardados.',
              style: TextStyle(color: Colores.gris),
            ),
          ),
      ],
    );
  }
}

part of 'inicio.dart';

class _TarjetaModelo extends StatelessWidget {
  const _TarjetaModelo({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    if (estado.modelos.isEmpty) return const SizedBox.shrink();
    final modelo = estado.modelos.first;
    return Tarjeta(
      color: Colores.tarjetaAlta,
      borde: Colores.verde.withValues(alpha: .35),
      onTap: () => ControlNavegacion.abrir(context, 3),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Etiqueta(
                  texto: 'MODELO 3D REAL',
                  color: Colores.verde,
                  icono: Icons.threed_rotation_rounded,
                ),
                const SizedBox(height: 8),
                Text(
                  modelo.nombre,
                  style: const TextStyle(
                    color: Colores.texto,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Rota, acerca y explora cada estructura.',
                  style: TextStyle(color: Colores.gris, fontSize: 11),
                ),
              ],
            ),
          ),
          Visor3D(icono: modelo.icono, colores: modelo.colores, tamano: 90),
        ],
      ),
    );
  }
}

class _ResultadosBusqueda extends StatelessWidget {
  const _ResultadosBusqueda({required this.consulta});
  final String consulta;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final q = consulta.toLowerCase();
    final materias = estado.materias
        .where(
          (m) =>
              m.nombre.toLowerCase().contains(q) ||
              m.descripcion.toLowerCase().contains(q),
        )
        .toList();
    final recursos = estado.recursos
        .where(
          (r) =>
              r.titulo.toLowerCase().contains(q) ||
              r.materia.toLowerCase().contains(q),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TituloSeccion(titulo: 'Resultados para "$consulta"'),
        const SizedBox(height: 8),
        if (materias.isEmpty && recursos.isEmpty)
          const Tarjeta(
            child: Text(
              'Sin resultados. Prueba con otro término.',
              style: TextStyle(color: Colores.gris),
            ),
          ),
        for (final materia in materias)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Tarjeta(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetalleMateriaPantalla(materia: materia),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconoMateria(
                    icono: materia.icono,
                    color: materia.color,
                    asset: materia.iconoAsset,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      materia.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Etiqueta(texto: 'Materia', color: Colores.azulMedio),
                ],
              ),
            ),
          ),
        for (final recurso in recursos)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Tarjeta(
              onTap: () => ControlNavegacion.abrir(context, 2),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconoMateria(icono: recurso.icono, color: recurso.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recurso.titulo,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${recurso.tipo} · ${recurso.materia}',
                          style: const TextStyle(
                            color: Colores.gris,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

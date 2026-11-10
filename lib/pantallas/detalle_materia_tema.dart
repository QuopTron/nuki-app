part of 'detalle_materia.dart';

Future<void> _abrirTema(
  BuildContext context,
  EstadoNuki estado,
  Materia materia,
  int indice,
) {
  final tema = materia.temas[indice];
  final contenido = contenidoParaTema(materia.id, tema.titulo);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => DraggableScrollableSheet(
      initialChildSize: .84,
      minChildSize: .5,
      maxChildSize: .96,
      expand: false,
      builder: (contexto, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colores.borde,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconoMateria(
                icono: materia.icono,
                asset: materia.iconoAsset,
                color: materia.color,
                tamano: 52,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tema.titulo,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${materia.nombre} · ${tema.tipo}',
                      style: const TextStyle(
                        color: Colores.gris,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(contexto),
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Cerrar',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Tarjeta(
            padding: const EdgeInsets.all(16),
            color: Colores.tarjetaAlta,
            sombra: false,
            child: Text(
              contenido?.resumen ??
                  'Repasa este tema con los recursos de la materia y complementa tu estudio con las evaluaciones disponibles.',
              style: const TextStyle(fontSize: 13, height: 1.55),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Puntos clave',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          for (final punto
              in contenido?.puntos ??
                  const [
                    'Lee el material y subraya los conceptos principales.',
                    'Relaciona el tema con los demás contenidos de la materia.',
                    'Comprueba lo aprendido resolviendo una evaluación.',
                  ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: materia.color.withValues(alpha: .16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: materia.color,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      punto,
                      style: const TextStyle(fontSize: 12.5, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          if (contenido != null && contenido.dato.isNotEmpty) ...[
            const SizedBox(height: 8),
            Tarjeta(
              padding: const EdgeInsets.all(14),
              color: Colores.ambar.withValues(alpha: .08),
              borde: Colores.ambar.withValues(alpha: .35),
              sombra: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 19,
                    color: Colores.ambar,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      contenido.dato,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.45,
                        color: Colores.ambar,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: tema.completado
                ? OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(contexto);
                      await estado.alternarTema(materia, indice);
                      if (context.mounted) {
                        mostrarMensaje(context, 'Tema marcado como pendiente.');
                      }
                    },
                    icon: const Icon(Icons.undo_rounded, size: 17),
                    label: const Text('Marcar como pendiente'),
                  )
                : FilledButton.icon(
                    onPressed: () async {
                      Navigator.pop(contexto);
                      await estado.alternarTema(materia, indice);
                      if (context.mounted) {
                        mostrarMensaje(context, 'Tema completado. ¡Bien!');
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: materia.color,
                    ),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Marcar como completado'),
                  ),
          ),
        ],
      ),
    ),
  );
}

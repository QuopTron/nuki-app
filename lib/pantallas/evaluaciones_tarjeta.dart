part of 'evaluaciones.dart';

class _EvaluacionTarjeta extends StatelessWidget {
  const _EvaluacionTarjeta({required this.evaluacion});
  final Evaluacion evaluacion;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final intento = estado.resultados[evaluacion.id];
    return Tarjeta(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconoMateria(
            icono: evaluacion.icono,
            color: evaluacion.color,
            tamano: 48,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evaluacion.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${evaluacion.cantidad} preguntas · ${evaluacion.minutos} min',
                  style: const TextStyle(color: Colores.gris, fontSize: 11),
                ),
                const SizedBox(height: 6),
                if (intento != null)
                  Etiqueta(
                    texto: '$intento/${evaluacion.preguntas.length} aciertos',
                    color: Colores.turquesa,
                    icono: Icons.check_circle_rounded,
                  )
                else
                  Text(
                    evaluacion.autor.isEmpty
                        ? evaluacion.materia
                        : '${evaluacion.materia} · ${evaluacion.autor}',
                    style: TextStyle(
                      color: evaluacion.color,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CuestionarioPantalla(evaluacion: evaluacion),
                  ),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                child: Text(intento != null ? 'Repetir' : 'Iniciar'),
              ),
              const SizedBox(height: 2),
              if (estado.puedeEditar(evaluacion.autorId))
                InkWell(
                  onTap: () => _menuEvaluacion(context, estado, evaluacion),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.more_horiz_rounded,
                      color: Colores.gris,
                      size: 18,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colores.gris,
                  size: 18,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _menuEvaluacion(
  BuildContext context,
  EstadoNuki estado,
  Evaluacion evaluacion,
) async {
  final accion = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colores.fondo,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (contexto) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colores.borde,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ListTile(
            leading: Icon(evaluacion.icono, color: evaluacion.color),
            title: Text(evaluacion.titulo),
            subtitle: Text(
              '${evaluacion.materia} · ${evaluacion.tipo} · ${evaluacion.minutos} min',
            ),
          ),
          if (evaluacion.autor.isNotEmpty)
            ListTile(
              leading: const Icon(
                Icons.person_outline_rounded,
                color: Colores.gris,
              ),
              title: Text('Creada por ${evaluacion.autor}'),
            ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: Colores.coral,
            ),
            title: const Text('Eliminar evaluación'),
            onTap: () => Navigator.pop(contexto, 'eliminar'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (accion != 'eliminar' || !context.mounted) return;
  final confirmar = await confirmarNuki(
    context,
    titulo: '¿Eliminar evaluación?',
    mensaje:
        '${evaluacion.titulo} se quitará de evaluaciones.json. Los resultados ya guardados se mantienen.',
    confirmar: 'Eliminar',
  );
  if (confirmar) {
    await estado.eliminarEvaluacion(evaluacion);
    if (context.mounted) mostrarMensaje(context, 'Evaluación eliminada.');
  }
}

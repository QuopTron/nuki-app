part of 'identificacion.dart';

class _JuegoIdentificacion extends StatelessWidget {
  const _JuegoIdentificacion({
    required this.modelo,
    required this.indice,
    required this.total,
    required this.aciertos,
    required this.actual,
    required this.opciones,
    required this.seleccion,
    required this.onElegir,
    required this.onSiguiente,
  });
  final ModeloAnatomico modelo;
  final int indice, total, aciertos;
  final EstructuraAnatomica actual;
  final List<EstructuraAnatomica> opciones;
  final int? seleccion;
  final ValueChanged<int> onElegir;
  final VoidCallback onSiguiente;

  @override
  Widget build(BuildContext context) {
    final acerto =
        seleccion != null && opciones[seleccion!].nombre == actual.nombre;
    final color = modelo.colores.first;
    return Column(
      children: [
        LinearProgressIndicator(
          value: (indice + (seleccion == null ? 0 : 1)) / total,
          minHeight: 5,
          backgroundColor: Colores.borde,
          color: color,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            children: [
              Row(
                children: [
                  Etiqueta(
                    texto: 'Pregunta ${indice + 1} de $total',
                    color: color,
                  ),
                  const Spacer(),
                  Etiqueta(
                    texto: '$aciertos aciertos',
                    color: Colores.turquesa,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: .72)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white70,
                          size: 17,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '¿Qué estructura cumple esta función?',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      actual.funcion.isEmpty
                          ? 'Identifica la estructura ${actual.nombre}.'
                          : actual.funcion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < opciones.length; i++) ...[
                _Opcion(
                  estructura: opciones[i],
                  seleccionada: seleccion == i,
                  esCorrecta: opciones[i].nombre == actual.nombre,
                  revelada: seleccion != null,
                  onTap: () => onElegir(i),
                ),
                const SizedBox(height: 9),
              ],
              if (seleccion != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (acerto ? Colores.turquesa : Colores.coral)
                        .withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (acerto ? Colores.turquesa : Colores.coral)
                          .withValues(alpha: .25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        acerto
                            ? Icons.emoji_events_rounded
                            : Icons.school_rounded,
                        color: acerto ? Colores.turquesa : Colores.coral,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          acerto
                              ? '¡Correcto! ${actual.nombre}: ${actual.funcion}'
                              : 'La respuesta correcta es ${actual.nombre}. ${actual.funcion}',
                          style: const TextStyle(fontSize: 11.5, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: seleccion == null ? null : onSiguiente,
              style: FilledButton.styleFrom(backgroundColor: color),
              child: Text(
                indice + 1 >= total ? 'Ver resultado' : 'Siguiente estructura',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

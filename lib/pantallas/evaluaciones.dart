import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/modales.dart';
import 'cuestionario.dart';

part 'evaluaciones_crear.dart';
part 'evaluaciones_hoja.dart';
part 'evaluaciones_piezas.dart';
part 'evaluaciones_pregunta.dart';
part 'evaluaciones_tarjeta.dart';

class EvaluacionesPantalla extends StatefulWidget {
  const EvaluacionesPantalla({super.key});

  @override
  State<EvaluacionesPantalla> createState() => _EvaluacionesPantallaState();
}

class _EvaluacionesPantallaState extends State<EvaluacionesPantalla> {
  static const _pestanas = ['Tareas', 'Cuestionarios', 'Simulacros'];
  int _pestana = 1;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final tipo = switch (_pestana) {
      0 => 'Tarea',
      1 => 'Cuestionario',
      _ => 'Simulacro',
    };
    final evaluaciones = estado.evaluaciones
        .where((e) => e.tipo == tipo)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Evaluaciones', style: TextStyle(fontSize: 20)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Etiqueta(
              texto: 'Autoevaluación',
              color: Colores.azulMedio,
              icono: Icons.bolt_rounded,
            ),
          ),
        ],
      ),
      floatingActionButton: estado.puedeGestionar
          ? FloatingActionButton.extended(
              heroTag: 'crear-evaluacion',
              onPressed: () => _crearEvaluacion(context, estado),
              backgroundColor: Colores.verde,
              foregroundColor: Colores.fondo,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'Crear',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
        children: [
          Tarjeta(
            color: Colores.azulMedio,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tu progreso académico',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estado.promedio > 0
                            ? estado.promedio.toStringAsFixed(1)
                            : '—',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      const Text(
                        'promedio general',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.task_alt_rounded,
                            size: 14,
                            color: Colores.celeste,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${estado.resultados.length} evaluaciones completadas',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CirculoProgreso(
                  valor: (estado.promedio / 10).clamp(0, 1),
                  tamano: 92,
                  color: Colores.turquesa,
                  texto: estado.promedio > 0
                      ? '${(estado.promedio * 10).round()}%'
                      : '0%',
                  detalle: 'avance',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (var i = 0; i < _pestanas.length; i++) ...[
                _Pestana(
                  texto: _pestanas[i],
                  activa: _pestana == i,
                  onTap: () => setState(() => _pestana = i),
                ),
                if (i != _pestanas.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 14),
          if (evaluaciones.isEmpty) const _SinEvaluaciones(),
          for (final evaluacion in evaluaciones) ...[
            _EvaluacionTarjeta(evaluacion: evaluacion),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.sync_rounded, size: 14, color: Colores.gris),
              SizedBox(width: 5),
              Text(
                'Resultados guardados en el repositorio',
                style: TextStyle(color: Colores.gris, fontSize: 10.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

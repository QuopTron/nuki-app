import 'package:flutter/material.dart';
import '../nucleo/contenido_temas.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/visor3d.dart';
import 'cuestionario.dart';
import 'modelos3d.dart';

part 'detalle_materia_contenido.dart';
part 'detalle_materia_portada.dart';
part 'detalle_materia_recursos.dart';
part 'detalle_materia_tema.dart';

class DetalleMateriaPantalla extends StatefulWidget {
  const DetalleMateriaPantalla({super.key, required this.materia});
  final Materia materia;

  @override
  State<DetalleMateriaPantalla> createState() => _DetalleMateriaPantallaState();
}

class _DetalleMateriaPantallaState extends State<DetalleMateriaPantalla> {
  int _pestana = 0;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final materia = widget.materia;
    final recursos = estado.recursos
        .where((r) => r.materia == materia.nombre)
        .toList();
    final evaluaciones = estado.evaluaciones
        .where((e) => e.materia == materia.nombre)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Materia', style: TextStyle(fontSize: 18)),
        actions: [
          if (!materia.inscrita)
            TextButton(
              onPressed: () => estado.inscribir(materia),
              child: const Text('Inscribirme'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          _Portada(materia: materia),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  materia.nombre,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${materia.completadas}/${materia.total}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: materia.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${materia.completadas} de ${materia.total} temas completados',
            style: const TextStyle(color: Colores.gris, fontSize: 12),
          ),
          const SizedBox(height: 10),
          BarraAvance(valor: materia.avance, color: materia.color, alto: 8),
          const SizedBox(height: 20),
          Row(
            children: [
              _Pestana(
                texto: 'Contenido',
                activa: _pestana == 0,
                onTap: () => setState(() => _pestana = 0),
              ),
              const SizedBox(width: 6),
              _Pestana(
                texto: 'Recursos',
                activa: _pestana == 1,
                onTap: () => setState(() => _pestana = 1),
              ),
              const SizedBox(width: 6),
              _Pestana(
                texto: 'Evaluaciones',
                activa: _pestana == 2,
                onTap: () => setState(() => _pestana = 2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_pestana == 0) _ContenidoMateria(materia: materia),
          if (_pestana == 1) _RecursosMateria(recursos: recursos),
          if (_pestana == 2) _EvaluacionesMateria(evaluaciones: evaluaciones),
        ],
      ),
    );
  }
}

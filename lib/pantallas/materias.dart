import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import 'detalle_materia.dart';

part 'materias_tarjetas.dart';

class MateriasPantalla extends StatefulWidget {
  const MateriasPantalla({super.key});

  @override
  State<MateriasPantalla> createState() => _MateriasPantallaState();
}

class _MateriasPantallaState extends State<MateriasPantalla> {
  String _consulta = '';
  bool _soloMias = true;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final materias = estado.materias.where((m) {
      final coincide =
          m.nombre.toLowerCase().contains(_consulta.toLowerCase()) ||
          m.descripcion.toLowerCase().contains(_consulta.toLowerCase());
      return coincide && (!_soloMias || m.inscrita);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Materias',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Tu plan de estudios, ordenado',
                        style: TextStyle(color: Colores.gris, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colores.cielo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${estado.materiasInscritas.length} activas',
                    style: const TextStyle(
                      color: Colores.azulMedio,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CampoBusqueda(
              hint: 'Buscar materia...',
              onChanged: (v) => setState(() => _consulta = v),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _Pastilla(
                  texto: 'Mis materias',
                  activa: _soloMias,
                  onTap: () => setState(() => _soloMias = true),
                ),
                const SizedBox(width: 8),
                _Pastilla(
                  texto: 'Todas',
                  activa: !_soloMias,
                  onTap: () => setState(() => _soloMias = false),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: materias.isEmpty
                  ? const _Vacio()
                  : LayoutBuilder(
                      builder: (context, restricciones) {
                        final columnas = restricciones.maxWidth >= 820 ? 2 : 1;
                        if (columnas == 1) {
                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: materias.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) => _TarjetaMateria(
                              materia: materias[i],
                              onInscribir: () => estado.inscribir(materias[i]),
                            ),
                          );
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 132,
                              ),
                          itemCount: materias.length,
                          itemBuilder: (_, i) => _TarjetaMateria(
                            materia: materias[i],
                            onInscribir: () => estado.inscribir(materias[i]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

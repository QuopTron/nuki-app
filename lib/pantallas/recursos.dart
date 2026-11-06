import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../nucleo/archivos.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/modales.dart';
import 'apuntes.dart';

part 'recursos_acciones.dart';
part 'recursos_biblioteca.dart';
part 'recursos_cabecera.dart';
part 'recursos_detalle.dart';
part 'recursos_hoja.dart';
part 'recursos_tarjetas.dart';

class RecursosPantalla extends StatefulWidget {
  const RecursosPantalla({super.key});

  @override
  State<RecursosPantalla> createState() => _RecursosPantallaState();
}

class _RecursosPantallaState extends State<RecursosPantalla> {
  static const _pestanas = ['Biblioteca', 'Apuntes', 'Guías', 'Resúmenes'];
  int _pestana = 0;
  String _consulta = '';
  String _filtro = 'Todos';

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final tipoPestana = switch (_pestana) {
      2 => 'Guía',
      3 => 'Resumen',
      _ => null,
    };
    final recursos = estado.recursos.where((r) {
      final coincideTexto =
          r.titulo.toLowerCase().contains(_consulta.toLowerCase()) ||
          r.materia.toLowerCase().contains(_consulta.toLowerCase());
      final coincideTipo = tipoPestana == null
          ? (_filtro == 'Todos' || r.tipo == _filtro)
          : r.tipo == tipoPestana;
      return coincideTexto && coincideTipo;
    }).toList();
    final tipos = [
      'Todos',
      ...{for (final r in estado.recursos) r.tipo},
    ];

    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CabeceraRecursos(),
              const SizedBox(height: 14),
              _PestanasRecursos(
                pestanas: _pestanas,
                activa: _pestana,
                onCambio: (i) => setState(() {
                  _pestana = i;
                  _filtro = 'Todos';
                }),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CampoBusqueda(
                  hint: _pestana == 1
                      ? 'Buscar en tus apuntes...'
                      : 'Buscar en la biblioteca...',
                  onChanged: (v) => setState(() => _consulta = v),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _pestana == 1
                    ? _Apuntes(consulta: _consulta)
                    : RefreshIndicator(
                        onRefresh: estado.cargar,
                        color: Colores.azul,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          children: [
                            if (tipoPestana == null) ...[
                              Wrap(
                                spacing: 7,
                                runSpacing: 7,
                                children: [
                                  for (final tipo in tipos)
                                    ChoiceChip(
                                      label: Text(tipo),
                                      selected: _filtro == tipo,
                                      showCheckmark: false,
                                      labelStyle: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: _filtro == tipo
                                            ? Colores.fondo
                                            : Colores.gris,
                                      ),
                                      onSelected: (_) =>
                                          setState(() => _filtro = tipo),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            Row(
                              children: [
                                Text(
                                  '${recursos.length} resultados',
                                  style: const TextStyle(
                                    color: Colores.gris,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.cloud_done_rounded,
                                  size: 14,
                                  color: Colores.turquesa,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'sincronizado',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colores.gris,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (recursos.isEmpty)
                              const Tarjeta(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.folder_off_rounded,
                                      color: Colores.gris,
                                      size: 32,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'No hay recursos con este filtro.',
                                      style: TextStyle(
                                        color: Colores.gris,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            for (final recurso in recursos) ...[
                              _TarjetaRecurso(recurso: recurso),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
          if (estado.puedeGestionar)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton.extended(
                heroTag: 'subir-recurso',
                onPressed: () => _subirRecurso(context, estado),
                backgroundColor: Colores.verde,
                foregroundColor: Colores.fondo,
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: const Text(
                  'Subir',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

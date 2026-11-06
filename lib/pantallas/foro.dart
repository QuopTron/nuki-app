import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/modales.dart';

part 'foro_adjuntos.dart';
part 'foro_cabecera.dart';
part 'foro_comentarios.dart';
part 'foro_comentario_tarjeta.dart';
part 'foro_crear.dart';
part 'foro_hoja.dart';
part 'foro_menu.dart';
part 'foro_like.dart';
part 'foro_reacciones.dart';
part 'foro_tarjeta.dart';

class ForoPantalla extends StatefulWidget {
  const ForoPantalla({super.key, this.mostrarCabecera = true});
  final bool mostrarCabecera;

  @override
  State<ForoPantalla> createState() => _ForoPantallaState();
}

class _ForoPantallaState extends State<ForoPantalla> {
  String _consulta = '';
  String _filtro = 'Todos';

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final materias = <String>{
      'Todos',
      for (final p in estado.publicaciones) p.materia,
    };
    final publicaciones =
        estado.publicaciones.where((p) {
          final coincideTexto =
              p.contenido.toLowerCase().contains(_consulta.toLowerCase()) ||
              p.autor.toLowerCase().contains(_consulta.toLowerCase());
          return coincideTexto && (_filtro == 'Todos' || p.materia == _filtro);
        }).toList()..sort((a, b) {
          if (a.fijada != b.fijada) return a.fijada ? -1 : 1;
          return b.id.compareTo(a.id);
        });

    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.mostrarCabecera) ...[
                _CabeceraForo(activos: estado.usuariosActivos.length),
                const SizedBox(height: 14),
              ],
              if (!estado.puedeEscribir)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Tarjeta(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    color: Colores.cielo,
                    sombra: false,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility_rounded,
                          size: 16,
                          color: Colores.azulMedio,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Modo invitado: puedes leer, reaccionar requiere una cuenta.',
                            style: TextStyle(
                              color: Colores.gris.withValues(alpha: .95),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CampoBusqueda(
                  hint: 'Buscar en el foro...',
                  onChanged: (v) => setState(() => _consulta = v),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: materias.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 7),
                  itemBuilder: (_, i) {
                    final materia = materias.elementAt(i);
                    final activa = materia == _filtro;
                    return GestureDetector(
                      onTap: () => setState(() => _filtro = materia),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: activa ? Colores.azul : Colores.tarjeta,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: activa ? Colores.azul : Colores.borde,
                          ),
                        ),
                        child: Text(
                          materia,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: activa ? Colores.fondo : Colores.gris,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: publicaciones.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay publicaciones con este filtro.',
                          style: TextStyle(color: Colores.gris),
                        ),
                      )
                    : RefreshIndicator(
                        color: Colores.azul,
                        onRefresh: estado.cargar,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                          itemCount: publicaciones.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) => _PublicacionTarjeta(
                            publicacion: publicaciones[i],
                          ),
                        ),
                      ),
              ),
            ],
          ),
          if (estado.puedeEscribir)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton.extended(
                heroTag: 'nueva-publicacion',
                onPressed: () => _nuevaPublicacion(context, estado),
                backgroundColor: Colores.verde,
                foregroundColor: Colores.fondo,
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text(
                  'Publicar',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

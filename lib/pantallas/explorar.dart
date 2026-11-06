import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/modales.dart';
import 'acceso.dart';
import 'foro.dart';
import 'recursos.dart';

part 'explorar_reels.dart';
part 'explorar_reels_media.dart';
part 'explorar_reels_crear.dart';
part 'explorar_reels_comentarios.dart';

class ExplorarPantalla extends StatefulWidget {
  const ExplorarPantalla({super.key, this.activo = true});

  final bool activo;

  @override
  State<ExplorarPantalla> createState() => _ExplorarPantallaState();
}

class _ExplorarPantallaState extends State<ExplorarPantalla> {
  int _pestana = 0;
  static const _pestanas = [
    (texto: 'Reels', icono: Icons.play_circle_fill_rounded),
    (texto: 'Foro', icono: Icons.forum_rounded),
    (texto: 'Libros', icono: Icons.auto_stories_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explorar',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        'Aprende en comunidad, sin límites',
                        style: TextStyle(color: Colores.gris, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => _abrirSubirReel(context),
                  tooltip: 'Subir un video o enlace',
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colores.tarjeta,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colores.borde),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < _pestanas.length; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _pestana = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _pestana == i
                                ? Colores.verde
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _pestanas[i].icono,
                                size: 15,
                                color: _pestana == i
                                    ? Colores.fondo
                                    : Colores.gris,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _pestanas[i].texto,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: _pestana == i
                                      ? Colores.fondo
                                      : Colores.gris,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: IndexedStack(
              index: _pestana,
              children: [
                _ReelsFeed(activo: widget.activo && _pestana == 0),
                const ForoPantalla(mostrarCabecera: false),
                const BibliotecaExplorar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

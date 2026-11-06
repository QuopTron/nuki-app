import 'dart:io';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/visor3d.dart';
import 'identificacion.dart';

part 'modelos3d_contenido.dart';
part 'modelos3d_escenario.dart';
part 'modelos3d_visor.dart';
part 'modelos3d_utils.dart';

bool get modoPruebaNuki => Platform.environment['FLUTTER_TEST'] == 'true';

class Modelos3DPantalla extends StatefulWidget {
  const Modelos3DPantalla({
    super.key,
    this.indiceInicial = 0,
    this.embebido = false,
  });
  final int indiceInicial;
  final bool embebido;

  @override
  State<Modelos3DPantalla> createState() => _Modelos3DPantallaState();
}

class _Modelos3DPantallaState extends State<Modelos3DPantalla> {
  late int _indice = widget.indiceInicial;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final modelos = estado.modelos;
    if (modelos.isEmpty) {
      return const Center(
        child: Text(
          'El repositorio no contiene modelos.',
          style: TextStyle(color: Colores.gris),
        ),
      );
    }
    final modelo = modelos[_indice.clamp(0, modelos.length - 1)];
    final contenido = _ContenidoModelo(
      modelo: modelo,
      modelos: modelos,
      indice: _indice,
      onSeleccion: (i) => setState(() => _indice = i),
      onCompleto: () => _abrirCompleto(context, modelo),
      onIdentificar: () => _abrirIdentificacion(context, modelo),
    );
    if (widget.embebido) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visor 3D',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -.5,
                          ),
                        ),
                        Text(
                          'Anatomía real para explorar y rotar',
                          style: TextStyle(color: Colores.gris, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Etiqueta(
                    texto: '${modelos.length} modelos',
                    color: Colores.verde,
                    icono: Icons.view_in_ar_rounded,
                  ),
                ],
              ),
            ),
            Expanded(child: contenido),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Modelos 3D', style: TextStyle(fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Etiqueta(
              texto: '${modelos.length} modelos',
              color: Colores.verde,
              icono: Icons.view_in_ar_rounded,
            ),
          ),
        ],
      ),
      body: contenido,
    );
  }

  void _abrirCompleto(BuildContext context, ModeloAnatomico modelo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _VisorCompleto(modelo: modelo),
      ),
    );
  }

  void _abrirIdentificacion(BuildContext context, ModeloAnatomico modelo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IdentificacionAnatomica(modelo: modelo),
      ),
    );
  }
}

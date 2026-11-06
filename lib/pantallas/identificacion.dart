import 'dart:math';
import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/mascota.dart';

part 'identificacion_juego.dart';
part 'identificacion_opcion.dart';
part 'identificacion_resultado.dart';

class IdentificacionAnatomica extends StatefulWidget {
  const IdentificacionAnatomica({super.key, required this.modelo});
  final ModeloAnatomico modelo;

  @override
  State<IdentificacionAnatomica> createState() =>
      _IdentificacionAnatomicaState();
}

class _IdentificacionAnatomicaState extends State<IdentificacionAnatomica> {
  final _azar = Random();
  late List<EstructuraAnatomica> _preguntas;
  late List<EstructuraAnatomica> _opciones;
  int _indice = 0;
  int _aciertos = 0;
  int? _seleccion;
  bool _finalizado = false;

  EstructuraAnatomica get _actual => _preguntas[_indice];

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _reiniciar() {
    final conFuncion = widget.modelo.estructuras
        .where((e) => e.funcion.trim().isNotEmpty)
        .toList();
    _preguntas =
        (conFuncion.isEmpty ? [...widget.modelo.estructuras] : conFuncion)
          ..shuffle(_azar);
    _indice = 0;
    _aciertos = 0;
    _finalizado = false;
    _prepararOpciones();
  }

  void _prepararOpciones() {
    final correcta = _preguntas[_indice];
    final otras =
        widget.modelo.estructuras
            .where((e) => e.nombre != correcta.nombre)
            .toList()
          ..shuffle(_azar);
    _opciones = [correcta, ...otras.take(3)]..shuffle(_azar);
    _seleccion = null;
  }

  void _elegir(int posicion) {
    if (_seleccion != null) return;
    setState(() {
      _seleccion = posicion;
      if (_opciones[posicion].nombre == _actual.nombre) _aciertos++;
    });
  }

  void _siguiente() {
    if (_indice + 1 >= _preguntas.length) {
      _finalizar();
      return;
    }
    setState(() {
      _indice++;
      _prepararOpciones();
    });
  }

  Future<void> _finalizar() async {
    setState(() => _finalizado = true);
    await AlcanceNuki.leer(context).registrarIdentificacion(
      widget.modelo.nombre,
      _aciertos,
      _preguntas.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Identificar estructuras',
          style: TextStyle(fontSize: 19),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Etiqueta(
              texto: widget.modelo.nombre,
              color: widget.modelo.colores.first,
              icono: Icons.view_in_ar_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _finalizado
            ? _Resultado(
                aciertos: _aciertos,
                total: _preguntas.length,
                modelo: widget.modelo,
                onRepetir: () => setState(_reiniciar),
              )
            : _JuegoIdentificacion(
                modelo: widget.modelo,
                indice: _indice,
                total: _preguntas.length,
                aciertos: _aciertos,
                actual: _actual,
                opciones: _opciones,
                seleccion: _seleccion,
                onElegir: _elegir,
                onSiguiente: _siguiente,
              ),
      ),
    );
  }
}

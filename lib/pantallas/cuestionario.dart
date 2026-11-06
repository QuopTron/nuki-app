import 'dart:async';
import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';

part 'cuestionario_cuerpo.dart';
part 'cuestionario_flujo.dart';
part 'cuestionario_mapa.dart';
part 'cuestionario_opcion.dart';
part 'cuestionario_resultado.dart';
part 'cuestionario_revision.dart';

class CuestionarioPantalla extends StatefulWidget {
  const CuestionarioPantalla({super.key, required this.evaluacion});
  final Evaluacion evaluacion;

  @override
  State<CuestionarioPantalla> createState() => _CuestionarioPantallaState();
}

class _CuestionarioPantallaState extends State<CuestionarioPantalla> {
  int _indice = 0;
  late final List<int?> _respuestas = List<int?>.filled(
    widget.evaluacion.preguntas.length,
    null,
  );
  bool _terminado = false;
  late int _restante = widget.evaluacion.minutos * 60;
  Timer? _reloj;

  Pregunta get _pregunta => widget.evaluacion.preguntas[_indice];
  int? get _seleccion => _respuestas[_indice];
  bool get _respondida => _seleccion != null;
  int get _aciertos {
    var total = 0;
    for (var i = 0; i < _respuestas.length; i++) {
      if (_respuestas[i] == widget.evaluacion.preguntas[i].correcta) total++;
    }
    return total;
  }

  int get _contestadas => _respuestas.where((r) => r != null).length;

  void refrescar(VoidCallback fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    if (widget.evaluacion.minutos > 0) {
      _reloj = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _terminado) return;
        setState(() => _restante--);
        if (_restante <= 0) _finalizar(auto: true);
      });
    }
  }

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  void _finalizar({bool auto = false}) {
    if (_terminado) return;
    _reloj?.cancel();
    setState(() => _terminado = true);
    AlcanceNuki.leer(context).guardarResultado(widget.evaluacion, _aciertos);
    if (auto) mostrarMensaje(context, 'Tiempo agotado: evaluación enviada.');
  }

  void _avanzar() {
    if (!_respondida) {
      mostrarMensaje(context, 'Selecciona una respuesta para continuar.');
      return;
    }
    if (_indice >= widget.evaluacion.preguntas.length - 1) {
      _finalizar();
      return;
    }
    setState(() => _indice++);
  }

  void _retroceder() {
    if (_indice > 0) setState(() => _indice--);
  }

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    return PopScope(
      canPop: _terminado,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) salirCuestionario();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: salirCuestionario,
            icon: const Icon(Icons.close_rounded),
          ),
          title: Text(
            _terminado ? 'Resultado' : widget.evaluacion.materia,
            style: const TextStyle(fontSize: 17),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Etiqueta(
                  texto: _terminado
                      ? 'Completado'
                      : (_reloj == null
                            ? '${_indice + 1} / ${_respuestas.length}'
                            : _formatoTiempo(_restante)),
                  color: !_terminado && _restante <= 60
                      ? Colores.coral
                      : widget.evaluacion.color,
                  icono: _terminado ? null : Icons.timer_outlined,
                ),
              ),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _terminado
              ? _Resultado(
                  key: const ValueKey('resultado'),
                  evaluacion: widget.evaluacion,
                  aciertos: _aciertos,
                  promedio: estado.promedio,
                  onRepetir: reiniciarCuestionario,
                  onSalir: () => Navigator.pop(context),
                  onRevisar: () =>
                      _hojaRevision(context, widget.evaluacion, _respuestas),
                )
              : _CuerpoPregunta(
                  key: ValueKey('pregunta-$_indice'),
                  evaluacion: widget.evaluacion,
                  indice: _indice,
                  pregunta: _pregunta,
                  seleccion: _seleccion,
                  respondida: _respondida,
                  contestadas: _contestadas,
                  onSeleccion: (i) => setState(() => _respuestas[_indice] = i),
                  onAvanzar: _avanzar,
                  onRetroceder: _indice > 0 ? _retroceder : null,
                  onMapa: () => _hojaMapa(
                    context,
                    widget.evaluacion,
                    _respuestas,
                    (i) => setState(() => _indice = i),
                  ),
                ),
        ),
      ),
    );
  }
}

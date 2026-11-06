part of 'cuestionario.dart';

extension _FlujoCuestionario on _CuestionarioPantallaState {
  void reiniciarCuestionario() {
    refrescar(() {
      _indice = 0;
      _respuestas.fillRange(0, _respuestas.length, null);
      _terminado = false;
      _restante = widget.evaluacion.minutos * 60;
    });
    _reloj?.cancel();
    if (widget.evaluacion.minutos > 0) {
      _reloj = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _terminado) return;
        refrescar(() => _restante--);
        if (_restante <= 0) _finalizar(auto: true);
      });
    }
  }

  Future<void> salirCuestionario() async {
    if (_terminado) {
      Navigator.pop(context);
      return;
    }
    final salir = await confirmarSalida(context, contestadas: _contestadas);
    if (salir && mounted) Navigator.pop(context);
  }
}

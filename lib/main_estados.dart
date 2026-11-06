part of 'main.dart';

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotaCelula(tamano: 140),
            const SizedBox(height: 18),
            const Text(
              'Nuki',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colores.azul,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sincronizando contenido...',
              style: TextStyle(
                color: Colores.gris,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  minHeight: 6,
                  backgroundColor: Colores.cielo,
                  color: Colores.celeste,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorInicio extends StatelessWidget {
  const _ErrorInicio({required this.mensaje, required this.alReintentar});
  final String mensaje;
  final Future<void> Function()? alReintentar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Tarjeta(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MascotaCelula(tamano: 110),
                  const SizedBox(height: 18),
                  const Text(
                    'No pudimos cargar el contenido',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colores.gris, fontSize: 12.5),
                  ),
                  const SizedBox(height: 20),
                  if (alReintentar != null)
                    FilledButton.icon(
                      onPressed: () => alReintentar!(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reintentar'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

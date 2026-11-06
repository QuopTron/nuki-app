part of 'modelos3d.dart';

class _Escenario extends StatelessWidget {
  const _Escenario({required this.modelo, required this.onPantallaCompleta});
  final ModeloAnatomico modelo;
  final VoidCallback onPantallaCompleta;

  @override
  Widget build(BuildContext context) {
    final color = modelo.colores.first;
    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .22), Colores.fondoProfundo],
        ),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: modelo.archivo == null || modoPruebaNuki
                ? Center(
                    child: Visor3D(
                      icono: modelo.icono,
                      colores: modelo.colores,
                      tamano: 280,
                    ),
                  )
                : ModelViewer(
                    key: ValueKey(modelo.archivo),
                    src: modelo.archivo!,
                    alt: modelo.nombre,
                    ar: false,
                    autoRotate: true,
                    cameraControls: true,
                    backgroundColor: Colores.fondoProfundo,
                    relatedCss: 'body { background: #050A17; }',
                  ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Column(
              children: [
                _BotonIcono(
                  icono: Icons.fullscreen_rounded,
                  onTap: onPantallaCompleta,
                ),
                const SizedBox(height: 8),
                const _BotonIcono(
                  icono: Icons.info_outline_rounded,
                  onTap: null,
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colores.fondo.withValues(alpha: .75),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colores.borde),
              ),
              child: const Row(
                children: [
                  Icon(Icons.autorenew_rounded, size: 13, color: Colores.verde),
                  SizedBox(width: 5),
                  Text(
                    'Rotación automática · CC0',
                    style: TextStyle(
                      color: Colores.texto,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonIcono extends StatelessWidget {
  const _BotonIcono({required this.icono, required this.onTap});
  final IconData icono;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colores.fondo.withValues(alpha: .72),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icono, color: Colores.texto, size: 19),
        ),
      ),
    );
  }
}

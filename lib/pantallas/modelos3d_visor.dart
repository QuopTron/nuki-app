part of 'modelos3d.dart';

class _Miniatura extends StatelessWidget {
  const _Miniatura({
    required this.modelo,
    required this.activo,
    required this.onTap,
  });
  final ModeloAnatomico modelo;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 98,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: activo
              ? modelo.colores.first.withValues(alpha: .12)
              : Colores.tarjeta,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activo ? modelo.colores.first : Colores.borde,
            width: activo ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visor3D(
              icono: modelo.icono,
              colores: modelo.colores,
              tamano: 58,
              animar: false,
            ),
            const SizedBox(height: 4),
            Text(
              modelo.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: activo ? modelo.colores.first : Colores.texto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisorCompleto extends StatelessWidget {
  const _VisorCompleto({required this.modelo});
  final ModeloAnatomico modelo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071B31),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          modelo.nombre,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: modelo.archivo == null || modoPruebaNuki
                  ? Center(
                      child: Visor3D(
                        icono: modelo.icono,
                        colores: modelo.colores,
                        tamano: 340,
                      ),
                    )
                  : ModelViewer(
                      key: ValueKey(modelo.archivo),
                      src: modelo.archivo!,
                      alt: modelo.nombre,
                      ar: false,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: const Color(0xFF050A17),
                      relatedCss: 'body { background: #050A17; }',
                    ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    modelo.descripcion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final estructura in modelo.estructuras)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            estructura.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

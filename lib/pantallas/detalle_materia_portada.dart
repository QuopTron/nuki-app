part of 'detalle_materia.dart';

class _Portada extends StatelessWidget {
  const _Portada({required this.materia});
  final Materia materia;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [materia.color.withValues(alpha: .9), Colores.violeta],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -30,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .06),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: -14,
            bottom: -14,
            child: Visor3D(
              icono: materia.icono,
              colores: [Colors.white, materia.color],
              tamano: 190,
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Etiqueta(
                  texto: 'MODELO INTERACTIVO',
                  color: Colors.white,
                  icono: Icons.threed_rotation_rounded,
                ),
                const SizedBox(height: 8),
                Text(
                  materia.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Arrastra para explorar',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pestana extends StatelessWidget {
  const _Pestana({
    required this.texto,
    required this.activa,
    required this.onTap,
  });
  final String texto;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activa ? Colores.azul : Colores.tarjeta,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: activa ? Colores.azul : Colores.borde),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: activa ? Colores.fondo : Colores.gris,
            ),
          ),
        ),
      ),
    );
  }
}

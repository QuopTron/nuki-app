part of 'evaluaciones.dart';

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

class _SinEvaluaciones extends StatelessWidget {
  const _SinEvaluaciones();

  @override
  Widget build(BuildContext context) {
    return const Tarjeta(
      padding: EdgeInsets.all(26),
      child: Column(
        children: [
          Icon(
            Icons.assignment_turned_in_rounded,
            color: Colores.celeste,
            size: 38,
          ),
          SizedBox(height: 10),
          Text(
            'Nada pendiente por aquí',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'El contenido de esta sección llegará desde el repositorio.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colores.gris, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

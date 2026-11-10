part of 'comunes.dart';

class AvatarNuki extends StatelessWidget {
  const AvatarNuki({
    super.key,
    required this.iniciales,
    this.tamano = 44,
    this.colores = const [Colores.celeste, Colores.azulMedio],
  });
  final String iniciales;
  final double tamano;
  final List<Color> colores;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colores,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colores.last.withValues(alpha: .25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        iniciales,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: tamano * .33,
        ),
      ),
    );
  }
}

class IconoMateria extends StatelessWidget {
  const IconoMateria({
    super.key,
    required this.icono,
    required this.color,
    this.tamano = 46,
    this.asset,
  });
  final IconData icono;
  final Color color;
  final double tamano;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final archivo = asset;
    if (archivo != null) {
      return Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: .28), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .22),
              blurRadius: tamano * .28,
              offset: Offset(0, tamano * .1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          archivo,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, _, _) => Icon(icono, color: color, size: tamano * .5),
        ),
      );
    }
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(tamano * .32),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: .18), color.withValues(alpha: .07)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(icono, color: color, size: tamano * .5),
    );
  }
}

class Etiqueta extends StatelessWidget {
  const Etiqueta({
    super.key,
    required this.texto,
    required this.color,
    this.icono,
  });
  final String texto;
  final Color color;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            texto,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

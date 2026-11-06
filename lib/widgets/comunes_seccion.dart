part of 'comunes.dart';

class TituloSeccion extends StatelessWidget {
  const TituloSeccion({
    super.key,
    required this.titulo,
    this.accion,
    this.onAccion,
  });
  final String titulo;
  final String? accion;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        if (accion != null)
          TextButton(
            onPressed: onAccion,
            style: TextButton.styleFrom(
              foregroundColor: Colores.azulMedio,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              accion!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
      ],
    );
  }
}

class CampoBusqueda extends StatelessWidget {
  const CampoBusqueda({
    super.key,
    required this.hint,
    this.onChanged,
    this.onTap,
    this.controlador,
  });
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controlador;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controlador,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colores.gris,
          size: 21,
        ),
        suffixIcon: onTap != null
            ? const Icon(Icons.tune_rounded, color: Colores.gris, size: 19)
            : null,
      ),
    );
  }
}

void mostrarMensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(texto), duration: const Duration(seconds: 2)),
    );
}

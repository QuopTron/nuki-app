part of 'foro.dart';

Future<void> _nuevaPublicacion(BuildContext context, EstadoNuki estado) async {
  final datos = await showModalBottomSheet<_DatosPublicacion>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HojaPublicacion(estado: estado),
  );
  if (datos == null) return;
  await estado.agregarPublicacion(
    datos.texto,
    datos.materia,
    imagen: datos.imagen,
    imagenNombre: datos.imagenNombre,
  );
  if (context.mounted) mostrarMensaje(context, 'Publicación sincronizada.');
}

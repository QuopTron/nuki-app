part of 'modelos3d.dart';

void _mostrarEstructura(BuildContext context, EstructuraAnatomica estructura) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (contexto) => Container(
      decoration: const BoxDecoration(
        color: Colores.fondo,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colores.borde,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            estructura.nombre,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            estructura.funcion.isEmpty
                ? 'Sin descripción disponible en el repositorio.'
                : estructura.funcion,
            style: const TextStyle(
              color: Colores.gris,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(contexto),
              child: const Text('Entendido'),
            ),
          ),
        ],
      ),
    ),
  );
}

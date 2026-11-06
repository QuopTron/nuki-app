part of 'perfil.dart';

class _Repositorio extends StatelessWidget {
  const _Repositorio({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    final info = estado.infoRepositorio;
    return Tarjeta(
      color: Colores.tarjetaAlta,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.commit_rounded,
                color: Colores.celeste,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  info?.nombre ?? 'repositorio',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              Etiqueta(
                texto: info?.rama ?? 'main',
                color: Colores.turquesa,
                icono: Icons.account_tree_rounded,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            info?.fuente ?? 'Sin conexión',
            style: const TextStyle(color: Colors.white70, fontSize: 10.5),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${info?.archivos ?? 0} archivos · ${info?.mensaje ?? ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ),
              TextButton.icon(
                onPressed: estado.cargar,
                icon: const Icon(Icons.sync_rounded, size: 15),
                label: const Text('Sincronizar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colores.verde,
                  textStyle: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

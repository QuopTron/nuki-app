part of 'admin.dart';

class _TarjetaRepoAdmin extends StatelessWidget {
  const _TarjetaRepoAdmin({required this.info, required this.onRestablecer});
  final InfoRepositorio? info;
  final VoidCallback onRestablecer;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    return Tarjeta(
      color: Colores.tarjetaAlta,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_tree_rounded,
                color: Colores.celeste,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Repositorio de contenido',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Etiqueta(texto: info?.rama ?? 'main', color: Colores.turquesa),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            info?.fuente ?? 'Sin conexión',
            style: const TextStyle(color: Colors.white70, fontSize: 10.5),
          ),
          const SizedBox(height: 4),
          Text(
            '${info?.archivos ?? 0} archivos · ${info?.mensaje ?? ''}',
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              TextButton.icon(
                onPressed: estado.cargar,
                icon: const Icon(Icons.sync_rounded, size: 15),
                label: const Text('Sincronizar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colores.verde,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(fontSize: 11),
                ),
              ),
              const SizedBox(width: 14),
              if (info?.fuente.contains('emulado') ?? false)
                TextButton.icon(
                  onPressed: onRestablecer,
                  icon: const Icon(Icons.restore_rounded, size: 15),
                  label: const Text('Restaurar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colores.celeste,
                    padding: EdgeInsets.zero,
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

class _ReporteAdmin extends StatelessWidget {
  const _ReporteAdmin({required this.cuenta, required this.onBan});
  final Usuario cuenta;
  final VoidCallback onBan;

  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          AvatarNuki(
            iniciales: cuenta.iniciales,
            tamano: 36,
            colores: const [Colores.coral, Color(0xFF8E1B24)],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cuenta.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
                Text(
                  '${cuenta.reportes} reportes · ${cuenta.estado}',
                  style: const TextStyle(color: Colores.gris, fontSize: 10.5),
                ),
              ],
            ),
          ),
          Etiqueta(texto: 'Revisar', color: Colores.ambar),
          const SizedBox(width: 6),
          IconButton(
            onPressed: onBan,
            icon: Icon(
              cuenta.baneado ? Icons.lock_open_rounded : Icons.block_rounded,
              size: 19,
              color: cuenta.baneado ? Colores.turquesa : Colores.coral,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

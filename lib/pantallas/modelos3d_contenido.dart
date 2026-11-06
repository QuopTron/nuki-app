part of 'modelos3d.dart';

class _ContenidoModelo extends StatelessWidget {
  const _ContenidoModelo({
    required this.modelo,
    required this.modelos,
    required this.indice,
    required this.onSeleccion,
    required this.onCompleto,
    required this.onIdentificar,
  });
  final ModeloAnatomico modelo;
  final List<ModeloAnatomico> modelos;
  final int indice;
  final ValueChanged<int> onSeleccion;
  final VoidCallback onCompleto, onIdentificar;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        _Escenario(modelo: modelo, onPantallaCompleta: onCompleto),
        const SizedBox(height: 18),
        Text(
          modelo.nombre,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          modelo.descripcion,
          style: const TextStyle(
            color: Colores.gris,
            fontSize: 12.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(Icons.swipe_rounded, size: 17, color: Colores.azulMedio),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'Arrastra para rotar · doble toque para reiniciar',
                style: TextStyle(color: Colores.gris, fontSize: 11.5),
              ),
            ),
            SizedBox(
              height: 38,
              child: FilledButton.icon(
                onPressed: onCompleto,
                icon: const Icon(Icons.fullscreen_rounded, size: 18),
                label: const Text('Ver en 3D'),
                style: FilledButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const TituloSeccion(titulo: 'Otros modelos'),
        const SizedBox(height: 10),
        SizedBox(
          height: 114,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: modelos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (_, i) => _Miniatura(
              modelo: modelos[i],
              activo: i == indice,
              onTap: () => onSeleccion(i),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const TituloSeccion(titulo: 'Estructuras'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final estructura in modelo.estructuras)
              GestureDetector(
                onTap: () => _mostrarEstructura(context, estructura),
                child: Etiqueta(
                  texto: estructura.nombre,
                  color: modelo.colores.first,
                  icono: Icons.place_rounded,
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Tarjeta(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: modelo.colores.first.withValues(alpha: .12),
                child: Icon(Icons.quiz_rounded, color: modelo.colores.first),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identificación anatómica',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Relaciona cada función con su estructura.',
                      style: TextStyle(color: Colores.gris, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 38,
                child: FilledButton(
                  onPressed: onIdentificar,
                  style: FilledButton.styleFrom(
                    backgroundColor: modelo.colores.first,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Jugar'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Tarjeta(
          color: Colores.violeta,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Colores.ambar,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dato clínico',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      modelo.dato,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

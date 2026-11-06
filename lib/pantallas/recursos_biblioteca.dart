part of 'recursos.dart';

class BibliotecaExplorar extends StatefulWidget {
  const BibliotecaExplorar({super.key});

  @override
  State<BibliotecaExplorar> createState() => _BibliotecaExplorarState();
}

class _BibliotecaExplorarState extends State<BibliotecaExplorar> {
  int _pestana = 0;
  String _consulta = '';
  static const _pestanas = [
    (texto: 'Libros', icono: Icons.auto_stories_rounded),
    (texto: 'Apuntes', icono: Icons.note_alt_rounded),
    (texto: 'PDFs', icono: Icons.picture_as_pdf_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (var i = 0; i < _pestanas.length; i++) ...[
                if (i > 0) const SizedBox(width: 7),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _pestana = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _pestana == i ? Colores.verde : Colores.tarjeta,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _pestana == i ? Colores.verde : Colores.borde,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _pestanas[i].icono,
                            size: 14,
                            color: _pestana == i ? Colores.fondo : Colores.gris,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _pestanas[i].texto,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _pestana == i
                                  ? Colores.fondo
                                  : Colores.gris,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CampoBusqueda(
            hint: _pestana == 1
                ? 'Buscar apuntes...'
                : 'Buscar en la biblioteca...',
            onChanged: (v) => setState(() => _consulta = v),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(child: _contenido(estado)),
      ],
    );
  }

  Widget _contenido(EstadoNuki estado) {
    if (_pestana == 1) return _ApuntesBiblioteca(consulta: _consulta);
    final tipo = _pestana == 2 ? 'PDF' : 'Libro';
    final recursos = estado.recursos.where((r) {
      final texto = '${r.titulo} ${r.autor} ${r.materia}'.toLowerCase();
      return r.tipo == tipo && texto.contains(_consulta.toLowerCase());
    }).toList();
    return RefreshIndicator(
      onRefresh: estado.cargar,
      color: Colores.verde,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        children: [
          Row(
            children: [
              Text(
                '${recursos.length} títulos',
                style: const TextStyle(
                  color: Colores.gris,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.cloud_done_rounded,
                size: 13,
                color: Colores.verde,
              ),
              const SizedBox(width: 4),
              const Text(
                'sincronizado',
                style: TextStyle(fontSize: 10, color: Colores.gris),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (recursos.isEmpty)
            const Tarjeta(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.menu_book_rounded, color: Colores.gris, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Aún no hay títulos en esta categoría.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colores.gris, fontSize: 12),
                  ),
                ],
              ),
            ),
          for (final recurso in recursos) ...[
            _TarjetaRecurso(recurso: recurso),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ApuntesBiblioteca extends StatelessWidget {
  const _ApuntesBiblioteca({required this.consulta});
  final String consulta;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final apuntes = estado.apuntes
        .where(
          (a) => '${a.materia} ${a.titulo}'.toLowerCase().contains(
            consulta.toLowerCase(),
          ),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        Tarjeta(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ApuntesPantalla())),
          color: Colores.verde.withValues(alpha: .10),
          borde: Colores.verde.withValues(alpha: .4),
          child: const Row(
            children: [
              Icon(Icons.note_add_rounded, color: Colores.verde, size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crear nuevo apunte',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Escribe, sube o digitaliza tus notas',
                      style: TextStyle(color: Colores.gris, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colores.gris),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final apunte in apuntes) ...[
          Tarjeta(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ApuntesPantalla())),
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                IconoMateria(
                  icono: apunte.icono,
                  color: apunte.color,
                  tamano: 42,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apunte.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${apunte.materia} · ${apunte.fecha}',
                        style: const TextStyle(
                          color: Colores.gris,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colores.gris),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (apuntes.isEmpty)
          const Tarjeta(
            child: Text(
              'No hay apuntes guardados.',
              style: TextStyle(color: Colores.gris),
            ),
          ),
      ],
    );
  }
}

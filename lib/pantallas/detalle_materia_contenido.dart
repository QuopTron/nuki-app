part of 'detalle_materia.dart';

class _ContenidoMateria extends StatelessWidget {
  const _ContenidoMateria({required this.materia});
  final Materia materia;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    return Column(
      children: [
        Tarjeta(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const Modelos3DPantalla())),
          padding: const EdgeInsets.all(14),
          color: Colores.tarjetaAlta,
          child: Row(
            children: [
              const Icon(
                Icons.view_in_ar_rounded,
                color: Colores.celeste,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explora en 3D',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Rota y descubre cada estructura',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < materia.temas.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Tarjeta(
              onTap: () => _abrirTema(context, estado, materia, i),
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: materia.temas[i].completado
                          ? materia.color.withValues(alpha: .14)
                          : Colores.cielo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      materia.temas[i].completado
                          ? Icons.check_rounded
                          : Icons.play_arrow_rounded,
                      color: materia.temas[i].completado
                          ? materia.color
                          : Colores.azulMedio,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          materia.temas[i].titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          materia.temas[i].tipo,
                          style: const TextStyle(
                            color: Colores.gris,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => estado.alternarTema(materia, i),
                    icon: Icon(
                      materia.temas[i].completado
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: materia.temas[i].completado
                          ? materia.color
                          : Colores.gris,
                      size: 21,
                    ),
                    tooltip: materia.temas[i].completado
                        ? 'Marcar pendiente'
                        : 'Marcar completado',
                    visualDensity: VisualDensity.compact,
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colores.gris),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

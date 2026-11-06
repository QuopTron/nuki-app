import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/mascota.dart';
import '../widgets/navegacion.dart';
import '../widgets/visor3d.dart';
import 'apuntes.dart';
import 'detalle_materia.dart';
import 'evaluaciones.dart';
import 'modelos3d.dart';
import 'notificaciones.dart';

part 'inicio_extra.dart';
part 'inicio_tarjetas.dart';
part 'inicio_materias.dart';
part 'inicio_modelo.dart';

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  String _consulta = '';

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final usuario = estado.usuario;
    if (usuario == null) return const SizedBox.shrink();
    final materias = estado.materiasInscritas;
    final siguiente = materias.cast<Materia?>().firstWhere(
      (m) => (m?.avance ?? 1) < 1,
      orElse: () => materias.isEmpty ? null : materias.first,
    );
    final ancho = MediaQuery.sizeOf(context).width;
    final columnas = ancho >= 1000
        ? 6
        : ancho >= 640
        ? 6
        : 3;

    return SafeArea(
      child: RefreshIndicator(
        color: Colores.azul,
        onRefresh: estado.cargar,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 96),
          children: [
            Row(
              children: [
                const MascotaCelula(tamano: 54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, ${usuario.nombre.split(' ').first}!',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Tu esfuerzo de hoy construye\nal médico del mañana.',
                        style: TextStyle(
                          color: Colores.gris,
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                _Campana(noLeidas: estado.noLeidas),
              ],
            ),
            const SizedBox(height: 14),
            _EstadisticasInicio(estado: estado),
            const SizedBox(height: 18),
            CampoBusqueda(
              hint: 'Buscar materiales, temas, etc...',
              onChanged: (valor) => setState(() => _consulta = valor.trim()),
            ),
            const SizedBox(height: 20),
            if (_consulta.isNotEmpty)
              _ResultadosBusqueda(consulta: _consulta)
            else ...[
              if (siguiente != null) _SigueAvanzando(materia: siguiente),
              const SizedBox(height: 24),
              const _PodriaInteresarte(),
              const SizedBox(height: 24),
              const _RutaAprendizaje(),
              const SizedBox(height: 24),
              const TituloSeccion(titulo: 'Accesos rápidos'),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: columnas,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: ancho >= 640 ? 1.45 : .98,
                children: [
                  _AccesoRapido(
                    icono: Icons.menu_book_rounded,
                    texto: 'Materiales',
                    color: Colores.azulMedio,
                    onTap: () => ControlNavegacion.abrir(context, 1),
                  ),
                  _AccesoRapido(
                    icono: Icons.view_in_ar_rounded,
                    texto: 'Modelos 3D',
                    color: Colores.coral,
                    onTap: () => _abrir(context, const Modelos3DPantalla()),
                  ),
                  _AccesoRapido(
                    icono: Icons.quiz_rounded,
                    texto: 'Evaluaciones',
                    color: Colores.violeta,
                    onTap: () => _abrir(context, const EvaluacionesPantalla()),
                  ),
                  _AccesoRapido(
                    icono: Icons.forum_rounded,
                    texto: 'Foro',
                    color: Colores.turquesa,
                    onTap: () => ControlNavegacion.abrir(context, 3),
                  ),
                  _AccesoRapido(
                    icono: Icons.edit_note_rounded,
                    texto: 'Apuntes',
                    color: Colores.ambar,
                    onTap: () => _abrir(context, const ApuntesPantalla()),
                  ),
                  _AccesoRapido(
                    icono: Icons.local_library_rounded,
                    texto: 'Biblioteca',
                    color: Colores.celeste,
                    onTap: () => ControlNavegacion.abrir(context, 2),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              TituloSeccion(
                titulo: 'Tus materias',
                accion: 'Ver todas',
                onAccion: () => ControlNavegacion.abrir(context, 1),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 118,
                child: materias.isEmpty
                    ? const Tarjeta(
                        child: Center(
                          child: Text(
                            'Aún no tienes materias inscritas.',
                            style: TextStyle(color: Colores.gris),
                          ),
                        ),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: materias.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, i) =>
                            _MateriaMini(materia: materias[i]),
                      ),
              ),
              const SizedBox(height: 22),
              TituloSeccion(titulo: 'Tu racha'),
              const SizedBox(height: 10),
              _Racha(racha: estado.racha),
              const SizedBox(height: 22),
              TituloSeccion(
                titulo: 'Explora en 3D',
                accion: 'Abrir visor',
                onAccion: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Modelos3DPantalla()),
                ),
              ),
              const SizedBox(height: 10),
              _TarjetaModelo(estado: estado),
            ],
          ],
        ),
      ),
    );
  }

  void _abrir(BuildContext context, Widget pantalla) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => pantalla));
  }
}

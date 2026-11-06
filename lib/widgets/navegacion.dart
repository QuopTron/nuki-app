import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/tema.dart';
import '../pantallas/explorar.dart';
import '../pantallas/inicio.dart';
import '../pantallas/materias.dart';
import '../pantallas/modelos3d.dart';
import '../pantallas/perfil.dart';
import 'mascota.dart';

class ControlNavegacion extends InheritedWidget {
  const ControlNavegacion({super.key, required this.irA, required super.child});
  final void Function(int indice) irA;

  static void abrir(BuildContext context, int indice) {
    context.getInheritedWidgetOfExactType<ControlNavegacion>()?.irA(indice);
  }

  @override
  bool updateShouldNotify(covariant ControlNavegacion oldWidget) => false;
}

class NavegacionPrincipal extends StatefulWidget {
  const NavegacionPrincipal({super.key});

  @override
  State<NavegacionPrincipal> createState() => _NavegacionPrincipalState();
}

class _NavegacionPrincipalState extends State<NavegacionPrincipal> {
  int _indice = 0;
  List<Widget> get _paginas => [
    const InicioPantalla(),
    const MateriasPantalla(),
    ExplorarPantalla(activo: _indice == 2),
    const Modelos3DPantalla(embebido: true),
    const PerfilPantalla(),
  ];
  static const _destinos = [
    (
      icono: Icons.home_outlined,
      activo: Icons.home_rounded,
      etiqueta: 'Inicio',
    ),
    (
      icono: Icons.menu_book_outlined,
      activo: Icons.menu_book_rounded,
      etiqueta: 'Materias',
    ),
    (
      icono: Icons.explore_outlined,
      activo: Icons.explore_rounded,
      etiqueta: 'Explorar',
    ),
    (
      icono: Icons.view_in_ar_outlined,
      activo: Icons.view_in_ar_rounded,
      etiqueta: 'Visor 3D',
    ),
    (
      icono: Icons.person_outline_rounded,
      activo: Icons.person_rounded,
      etiqueta: 'Perfil',
    ),
  ];

  void _irA(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final estado = AlcanceNuki.de(context);
    final contenido = ControlNavegacion(
      irA: _irA,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: estado.guardando ? 3 : 0,
            child: const LinearProgressIndicator(
              minHeight: 3,
              color: Colores.azul,
              backgroundColor: Colores.cielo,
            ),
          ),
          Expanded(
            child: IndexedStack(index: _indice, children: _paginas),
          ),
        ],
      ),
    );

    if (ancho >= 900) {
      final extendido = ancho >= 1280;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _indice,
              onDestinationSelected: _irA,
              backgroundColor: Colores.tarjeta,
              indicatorColor: Colores.azul.withValues(alpha: .16),
              extended: extendido,
              minExtendedWidth: 200,
              labelType: extendido
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              groupAlignment: -.7,
              leading: Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 22),
                child: Column(
                  children: [
                    const MascotaCelula(tamano: 46),
                    if (!extendido) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Nuki',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colores.azul,
                          fontSize: 13,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 6),
                      const Text(
                        'Nuki',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colores.azul,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'tu célula aliada',
                        style: TextStyle(fontSize: 9, color: Colores.gris),
                      ),
                    ],
                  ],
                ),
              ),
              destinations: [
                for (final destino in _destinos)
                  NavigationRailDestination(
                    icon: Icon(destino.icono),
                    selectedIcon: Icon(destino.activo),
                    label: Text(destino.etiqueta),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, color: Colores.borde),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: contenido,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: contenido,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _irA,
        destinations: [
          for (final destino in _destinos)
            NavigationDestination(
              icon: Icon(destino.icono),
              selectedIcon: Icon(destino.activo),
              label: destino.etiqueta,
            ),
        ],
      ),
    );
  }
}

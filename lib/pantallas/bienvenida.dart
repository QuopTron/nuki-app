import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/tema.dart';
import '../widgets/mascota.dart';
import 'acceso.dart';

part 'bienvenida_adornos.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final info = estado.infoRepositorio;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: _Mancha(
              color: Colores.celeste.withValues(alpha: .16),
              tamano: 260,
            ),
          ),
          Positioned(
            bottom: -90,
            left: -70,
            child: _Mancha(
              color: Colores.coral.withValues(alpha: .12),
              tamano: 280,
            ),
          ),
          Positioned(
            top: 140,
            left: -40,
            child: _Mancha(
              color: Colores.turquesa.withValues(alpha: .10),
              tamano: 120,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colores.tarjeta.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colores.borde),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_done_rounded,
                              size: 15,
                              color: Colores.turquesa,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              info == null
                                  ? 'repositorio local'
                                  : '${info.rama} · ${info.nombre}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colores.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const MascotaCelula(tamano: 184),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Nuki',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              height: 1,
                              letterSpacing: -2,
                              color: Colores.azul,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              '.',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                height: 1,
                                color: Colores.coral.withValues(alpha: .9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tu célula, tu aliada en el aprendizaje',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colores.coral,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Plataforma digital para el fortalecimiento académico en Medicina.\n(U.M.R.P.S.F.X.CH.)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: Colores.gris,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () => abrirHojaAcceso(context),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Comenzar'),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => abrirHojaAcceso(context),
                          child: const Text('Iniciar sesión'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 6,
                        children: [
                          _MiniAcceso(
                            icono: Icons.view_in_ar_rounded,
                            texto: 'Modelos 3D',
                          ),
                          _MiniAcceso(
                            icono: Icons.quiz_rounded,
                            texto: 'Cuestionarios',
                          ),
                          _MiniAcceso(
                            icono: Icons.forum_rounded,
                            texto: 'Comunidad',
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        info == null
                            ? 'Contenido versionado'
                            : '${info.archivos} archivos versionados · ${info.fuente}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colores.gris.withValues(alpha: .8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

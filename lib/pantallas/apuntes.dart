import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../nucleo/archivos.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';
import '../widgets/modales.dart';

part 'apuntes_detalle.dart';
part 'apuntes_dialogo.dart';
part 'apuntes_hoja.dart';
part 'apuntes_pestana.dart';

class ApuntesPantalla extends StatefulWidget {
  const ApuntesPantalla({super.key});

  @override
  State<ApuntesPantalla> createState() => _ApuntesPantallaState();
}

class _ApuntesPantallaState extends State<ApuntesPantalla> {
  bool _compartidos = false;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final apuntes = estado.apuntes;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Mis apuntes', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () => _crearApunte(context, estado),
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Crear apunte',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Row(
            children: [
              _Pestana(
                texto: 'Mis apuntes',
                activa: !_compartidos,
                onTap: () => setState(() => _compartidos = false),
              ),
              const SizedBox(width: 8),
              _Pestana(
                texto: 'Compartidos',
                activa: _compartidos,
                onTap: () => setState(() => _compartidos = true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_compartidos) ...[
            Tarjeta(
              onTap: () => _crearApunte(context, estado),
              color: Colores.cielo,
              borde: Colores.celeste,
              child: Column(
                children: [
                  const Icon(
                    Icons.note_add_rounded,
                    color: Colores.azulMedio,
                    size: 38,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crear nuevo apunte',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Escribe, sube o digitaliza\ntus apuntes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colores.gris.withValues(alpha: .9),
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TituloSeccion(
              titulo: 'Carpetas',
              accion: '${apuntes.length} en total',
            ),
            const SizedBox(height: 8),
            for (final apunte in apuntes) ...[
              Tarjeta(
                onTap: () => _abrirApunte(context, estado, apunte),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    IconoMateria(
                      icono: apunte.icono,
                      color: apunte.color,
                      tamano: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apunte.materia,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${apunte.fecha} · ${apunte.titulo}',
                            style: const TextStyle(
                              color: Colores.gris,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (apunte.archivo != null)
                      const Icon(
                        Icons.attach_file_rounded,
                        size: 16,
                        color: Colores.gris,
                      ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colores.gris,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (apuntes.isEmpty)
              const Tarjeta(
                child: Text(
                  'Todavía no tienes apuntes. Crea el primero.',
                  style: TextStyle(color: Colores.gris),
                ),
              ),
          ] else
            const Tarjeta(
              padding: EdgeInsets.all(26),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_shared_rounded,
                    size: 40,
                    color: Colores.celeste,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Aún no compartieron apuntes contigo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Cuando alguien comparta un apunte aparecerá aquí.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colores.gris, fontSize: 12),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 18),
          if (estado.infoRepositorio != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.commit_rounded, size: 14, color: Colores.gris),
                const SizedBox(width: 5),
                Text(
                  '${estado.infoRepositorio!.archivos} archivos · ${estado.infoRepositorio!.rama} · ${estado.infoRepositorio!.fuente}',
                  style: const TextStyle(color: Colores.gris, fontSize: 10),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

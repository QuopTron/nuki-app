import 'package:flutter/material.dart';
import '../nucleo/estado.dart';
import '../nucleo/modelos.dart';
import '../nucleo/tema.dart';
import '../widgets/comunes.dart';

part 'notificaciones_tarjeta.dart';

class NotificacionesPantalla extends StatefulWidget {
  const NotificacionesPantalla({super.key});

  @override
  State<NotificacionesPantalla> createState() => _NotificacionesPantallaState();
}

class _NotificacionesPantallaState extends State<NotificacionesPantalla> {
  static const _pestanas = ['Todas', 'Materias', 'Foro', 'Sistema'];
  int _pestana = 0;

  @override
  Widget build(BuildContext context) {
    final estado = AlcanceNuki.de(context);
    final notificaciones = estado.notificaciones
        .where((n) => _pestana == 0 || n.tipo == _pestanas[_pestana])
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Notificaciones', style: TextStyle(fontSize: 20)),
        actions: [
          if (estado.noLeidas > 0)
            TextButton(
              onPressed: () async {
                await estado.marcarTodasLeidas();
                if (context.mounted) {
                  mostrarMensaje(
                    context,
                    'Notificaciones marcadas como leídas.',
                  );
                }
              },
              child: const Text(
                'Marcar leídas',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
              ),
            ),
          if (estado.puedeGestionar)
            IconButton(
              onPressed: () => _avisoRapido(context, estado),
              tooltip: 'Nuevo aviso',
              icon: const Icon(Icons.add_alert_rounded, size: 20),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _pestanas.length,
              separatorBuilder: (_, _) => const SizedBox(width: 7),
              itemBuilder: (_, i) {
                final activa = _pestana == i;
                return GestureDetector(
                  onTap: () => setState(() => _pestana = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activa ? Colores.azul : Colores.tarjeta,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: activa ? Colores.azul : Colores.borde,
                      ),
                    ),
                    child: Text(
                      _pestanas[i],
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: activa ? Colores.fondo : Colores.gris,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: notificaciones.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_off_rounded,
                          size: 38,
                          color: Colores.celeste,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No hay notificaciones aquí.',
                          style: TextStyle(
                            color: Colores.gris,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    itemCount: notificaciones.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) =>
                        _TarjetaNotificacion(notificacion: notificaciones[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

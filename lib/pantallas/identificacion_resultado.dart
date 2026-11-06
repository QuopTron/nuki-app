part of 'identificacion.dart';

class _Resultado extends StatelessWidget {
  const _Resultado({
    required this.aciertos,
    required this.total,
    required this.modelo,
    required this.onRepetir,
  });
  final int aciertos, total;
  final ModeloAnatomico modelo;
  final VoidCallback onRepetir;

  @override
  Widget build(BuildContext context) {
    final perfecto = aciertos == total;
    final mensaje = perfecto
        ? '¡Dominas esta región anatómica!'
        : aciertos >= total / 2
        ? '¡Buen trabajo! Sigue repasando.'
        : 'Repasa las estructuras y vuelve a intentarlo.';
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MascotaCelula(tamano: 130),
            const SizedBox(height: 18),
            Text(
              '$aciertos / $total',
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
            ),
            const Text(
              'estructuras identificadas',
              style: TextStyle(color: Colores.gris, fontSize: 12.5),
            ),
            const SizedBox(height: 10),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            BarraAvance(
              valor: total == 0 ? 0 : aciertos / total,
              color: perfecto ? Colores.turquesa : modelo.colores.first,
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: onRepetir,
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Repetir identificación'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Volver al modelo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

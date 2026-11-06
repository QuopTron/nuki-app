import 'package:flutter_test/flutter_test.dart';
import 'package:nuki/nucleo/configuracion_repo.dart';
import 'package:nuki/nucleo/estado.dart';
import 'package:nuki/nucleo/modelos.dart';
import 'package:nuki/nucleo/repositorio_nuki.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<EstadoNuki> _estadoConAdmin() async {
  SharedPreferences.setMockInitialValues({});
  final fuente = await crearFuenteContenido();
  final estado = EstadoNuki(RepositorioNuki(fuente));
  await estado.cargar();
  estado.iniciarSesion(estado.usuarios.firstWhere((u) => u.esAdmin));
  return estado;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Un docente crea una evaluación y se persiste', () async {
    final estado = await _estadoConAdmin();
    await estado.crearEvaluacion(
      titulo: 'Cardiología básica',
      materia: estado.materias.first.nombre,
      tipo: 'Cuestionario',
      minutos: 15,
      preguntas: [
        Pregunta(
          '¿Cuántas cámaras tiene el corazón?',
          ['2', '3', '4', '5'],
          2,
          'Son cuatro.',
        ),
      ],
    );
    expect(
      estado.evaluaciones.any((e) => e.titulo == 'Cardiología básica'),
      isTrue,
    );
    expect(estado.evaluaciones.first.autorId, estado.uid);
  });

  test('El perfil se edita y se guarda en usuarios.json', () async {
    final estado = await _estadoConAdmin();
    await estado.editarPerfil(
      nombre: 'Carlos Actualizado',
      correo: 'nuevo@usfx.bo',
      iniciales: 'CA',
    );
    expect(estado.usuario!.nombre, 'Carlos Actualizado');
    expect(
      estado.usuarios.any((u) => u.nombre == 'Carlos Actualizado'),
      isTrue,
    );
  });
}

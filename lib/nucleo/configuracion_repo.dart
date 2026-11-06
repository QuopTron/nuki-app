import 'fuente_git.dart';

const versionNuki = '1.0.1';
const apiNuki = String.fromEnvironment('NUKI_API_URL');
const apiNukiClave = String.fromEnvironment('NUKI_APP_KEY');
const usarGitHub = bool.fromEnvironment('NUKI_GITHUB', defaultValue: false);
const repoPropietario = String.fromEnvironment('NUKI_REPO_OWNER');
const repoNombre = String.fromEnvironment('NUKI_REPO_NAME');
const repoRama = String.fromEnvironment(
  'NUKI_REPO_BRANCH',
  defaultValue: 'main',
);
const repoToken = String.fromEnvironment('NUKI_GITHUB_TOKEN');

Future<FuenteContenido> crearFuenteContenido() async {
  if (apiNuki.isNotEmpty) {
    return FuenteNukiCloud(baseUrl: apiNuki, appKey: apiNukiClave);
  }
  if (usarGitHub) {
    if (repoPropietario.isEmpty || repoNombre.isEmpty || repoToken.isEmpty) {
      throw ExcepcionRepositorio(
        'Faltan NUKI_REPO_OWNER, NUKI_REPO_NAME o NUKI_GITHUB_TOKEN en --dart-define.',
      );
    }
    return FuenteGitHub(
      propietario: repoPropietario,
      repositorio: repoNombre,
      rama: repoRama,
      token: repoToken,
    );
  }
  return FuenteGitEmulada.crear();
}

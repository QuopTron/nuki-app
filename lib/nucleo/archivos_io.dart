import 'dart:io';
import 'dart:typed_data';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> abrirArchivo(Uint8List bytes, String nombre) async {
  try {
    final carpeta = await getTemporaryDirectory();
    final seguro = nombre.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final archivo = File('${carpeta.path}/$seguro');
    await archivo.writeAsBytes(bytes, flush: true);
    final resultado = await OpenFilex.open(archivo.path);
    return resultado.type == ResultType.done ? null : resultado.message;
  } catch (e) {
    return 'No se pudo abrir el archivo: $e';
  }
}

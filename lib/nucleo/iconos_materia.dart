const _archivos = <String, String>{
  'anatomia': 'anatomia.webp',
  'anatomia patologica': 'anatomia_patologica.webp',
  'bacteriologia y virologia': 'bacteriologia_y_virologia.webp',
  'bioquimica': 'bioquimica.webp',
  'cirugia i': 'cirugia_i.webp',
  'embriologia': 'embriologia.webp',
  'farmacologia': 'farmacologia.webp',
  'fisiologia': 'fisiologia.webp',
  'fisiopatologia': 'fisiopatologia.webp',
  'histologia': 'histologia.webp',
  'imagenologia': 'imagenologia.webp',
  'ingles i': 'ingles_i.webp',
  'parasitologia y micologia': 'parasitologia_y_micologia.webp',
  'salud mental': 'salud_mental.webp',
  'salud publica i': 'salud_publica_i.webp',
  'semiologia': 'semiologia.webp',
};

const _alias = <String, String>{
  'biologia celular': 'bioquimica',
  'genetica': 'embriologia',
  'microbiologia': 'bacteriologia y virologia',
  'patologia': 'anatomia patologica',
  'anatomia y diseccion': 'anatomia',
};

String _normalizar(String texto) {
  const cambios = {
    'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
    'à': 'a', 'è': 'e', 'ì': 'i', 'ò': 'o', 'ù': 'u',
    'ä': 'a', 'ë': 'e', 'ï': 'i', 'ö': 'o', 'ü': 'u',
    'ñ': 'n', 'ç': 'c',
  };
  var resultado = texto.toLowerCase();
  cambios.forEach((clave, valor) => resultado = resultado.replaceAll(clave, valor));
  return resultado
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

String? iconoMateriaPara(String nombre) {
  final normalizado = _normalizar(nombre);
  final clave = _alias[normalizado] ?? normalizado;
  final archivo = _archivos[clave];
  return archivo == null ? null : 'assets/iconosMateria/$archivo';
}

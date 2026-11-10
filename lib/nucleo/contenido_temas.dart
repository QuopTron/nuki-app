class ContenidoTema {
  const ContenidoTema(this.resumen, this.puntos, {this.dato = ''});
  final String resumen;
  final List<String> puntos;
  final String dato;
}

const contenidosTemas = <String, ContenidoTema>{
  'ana::Sistema cardiovascular': ContenidoTema(
    'El corazón impulsa la sangre a través de dos circuitos: pulmonar y sistémico. Las válvulas mantienen el flujo en una sola dirección y el ciclo cardíaco alterna sístole y diástole.',
    [
      'Corazón: cuatro cámaras, dos aurículas y dos ventrículos.',
      'Circulación menor: ventrículo derecho → pulmones → aurícula izquierda.',
      'Circulación mayor: ventrículo izquierdo → tejidos → aurícula derecha.',
    ],
    dato:
        'El nodo sinoauricular marca el ritmo cardíaco normal: 60–100 latidos por minuto.',
  ),
  'ana::Sistema óseo': ContenidoTema(
    'El esqueleto sostiene el cuerpo, protege órganos y sirve de anclaje a los músculos. Está formado por hueso compacto, hueso esponjoso y periostio.',
    [
      'Axial: cráneo, columna, costillas y esternón.',
      'Apendicular: cinturas escapular y pélvica, extremidades.',
      'Tipos de hueso: largos, cortos, planos, irregulares y sesamoideos.',
    ],
    dato:
        'El adulto tiene 206 huesos; al nacer hay cerca de 270 porque algunos se fusionan.',
  ),
  'ana::Sistema nervioso': ContenidoTema(
    'Coordina las funciones del organismo mediante neuronas y células gliales. Se divide en sistema nervioso central (encéfalo y médula) y periférico.',
    [
      'SNC: procesa la información y genera respuestas.',
      'SNP: nervios craneales, espinales y ganglios.',
      'División funcional: somático (voluntario) y autónomo (involuntario).',
    ],
    dato:
        'El autónomo se divide en simpático —alerta y huida— y parasimpático —descanso y digestión—.',
  ),
  'ana::Sistema respiratorio': ContenidoTema(
    'Intercambia oxígeno y dióxido de carbono entre el aire y la sangre. Comprende vías aéreas superiores, pulmones, bronquios y alvéolos.',
    [
      'Ventilación: entrada y salida de aire por cambios de presión.',
      'Hematosis: intercambio gaseoso en los alvéolos.',
      'Diafragma: principal músculo inspiratorio.',
    ],
    dato:
        'La superficie alveolar total ronda los 70 m², casi como una pista de tenis.',
  ),
  'ana::Sistema renal': ContenidoTema(
    'Los riñones filtran la sangre, regulan el agua y los electrolitos y participan en el equilibrio ácido-base y la presión arterial.',
    [
      'Nefrona: unidad funcional del riñón.',
      'Glomérulo: filtración del plasma.',
      'Túbulos: reabsorción y secreción selectivas.',
    ],
    dato:
        'Los riñones filtran unos 180 litros de plasma al día, pero orinamos alrededor de 1,5 litros.',
  ),
  'fis::Sistema nervioso': ContenidoTema(
    'La función nerviosa depende del potencial de membrana, los potenciales de acción y la sinapsis. La información se integra y transmite a gran velocidad.',
    [
      'Reposo: interior negativo por bomba Na⁺/K⁺.',
      'Potencial de acción: despolarización, repolarización e hiperpolarización.',
      'Sinapsis: liberación de neurotransmisores y respuesta postsinaptica.',
    ],
    dato:
        'La mielina acelera la conducción mediante saltos entre los nodos de Ranvier.',
  ),
  'fis::Sistema cardiovascular': ContenidoTema(
    'La fisiología cardiovascular estudia gasto cardíaco, presión arterial, retorno venoso y regulación del flujo según las necesidades de cada tejido.',
    [
      'Gasto cardíaco = frecuencia × volumen sistólico.',
      'Presión arterial depende del gasto y de la resistencia periférica.',
      'Barorreceptores ajustan la presión de forma rápida.',
    ],
    dato:
        'El reflejo barorreceptor responde en segundos para estabilizar la presión al cambiar de postura.',
  ),
  'fis::Sistema respiratorio': ContenidoTema(
    'La respiración incluye ventilación, difusión, transporte de gases y control nervioso. El objetivo es mantener una oxigenación y un pH adecuados.',
    [
      'Centro respiratorio: bulbo y protuberancia.',
      'CO₂ regula principalmente la ventilación.',
      'Relación ventilación/perfusión: clave para el intercambio eficiente.',
    ],
    dato:
        'La curva de disociación de la hemoglobina se desplaza según pH, CO₂ y temperatura.',
  ),
  'fis::Sistema renal': ContenidoTema(
    'El riñón regula volumen, osmolaridad, electrolitos, pH y presión arterial mediante filtración, reabsorción y secreción.',
    [
      'TFG: volumen filtrado por minuto.',
      'Aldosterona: reabsorbe sodio y excreta potasio.',
      'ADH: concentra la orina al aumentar la reabsorción de agua.',
    ],
    dato:
        'El sistema renina-angiotensina-aldosterona es central en el control de la presión arterial.',
  ),
  'fis::Sistema digestivo': ContenidoTema(
    'El tubo digestivo transforma los alimentos, absorbe nutrientes y elimina residuos. Cada tramo tiene funciones y secreciones especializadas.',
    [
      'Digestión mecánica y química comienzan en la boca.',
      'Estómago: ácido y pepsina inician la digestión proteica.',
      'Intestino delgado: principal absorción de nutrientes.',
    ],
    dato:
        'Las vellosidades intestinales amplían enormemente la superficie de absorción.',
  ),
  'bio::Membrana celular': ContenidoTema(
    'La membrana plasmática es una bicapa de fosfolípidos con proteínas que separa la célula del medio y regula el intercambio de sustancias.',
    [
      'Modelo de mosaico fluido: lípidos y proteínas en movimiento.',
      'Transporte pasivo: difusión y ósmosis.',
      'Transporte activo: requiere ATP, como la bomba Na⁺/K⁺.',
    ],
    dato:
        'El colesterol modula la fluidez de la membrana según la temperatura.',
  ),
  'bio::Núcleo y ADN': ContenidoTema(
    'El núcleo contiene el ADN y dirige la expresión génica. La cromatina se organiza alrededor de histonas y se condensa durante la división celular.',
    [
      'ADN: doble hélice con bases A-T y G-C.',
      'Transcripción: ADN → ARN en el núcleo.',
      'Traducción: ARN → proteína en el citoplasma.',
    ],
    dato:
        'Solo una pequeña parte del ADN corresponde a secuencias codificantes de proteínas.',
  ),
  'bio::Mitocondrias': ContenidoTema(
    'Las mitocondrias producen la mayor parte del ATP mediante respiración celular. Tienen doble membrana y su propio ADN.',
    [
      'Glucólisis: ocurre en el citosol.',
      'Ciclo de Krebs: matriz mitocondrial.',
      'Cadena transportadora de electrones: membrana interna.',
    ],
    dato: 'El ADN mitocondrial se hereda principalmente por vía materna.',
  ),
  'bio::Ciclo celular': ContenidoTema(
    'El ciclo celular comprende interfase y división. La célula crece, duplica su ADN y se divide con control estricto en los puntos de chequeo.',
    [
      'G1: crecimiento y preparación.',
      'S: replicación del ADN.',
      'G2 y M: control final y mitosis.',
    ],
    dato:
        'Las ciclinas y las quinasas dependientes de ciclina impulsan el avance del ciclo.',
  ),
  'bio::Apoptosis': ContenidoTema(
    'La apoptosis es una muerte celular programada que elimina células dañadas o innecesarias sin provocar inflamación.',
    [
      'Vía intrínseca: mitocondrias y citocromo c.',
      'Vía extrínseca: receptores de muerte y caspasas.',
      'Cambios típicos: condensación de cromatina y fragmentación del ADN.',
    ],
    dato:
        'La apoptosis es esencial en el desarrollo embrionario y en el control de células tumorales.',
  ),
  'gen::Genética mendeliana': ContenidoTema(
    'Los principios de Mendel explican la herencia de caracteres mediante alelos dominantes y recesivos y la segregación independiente.',
    [
      'Ley de uniformidad de la primera generación.',
      'Ley de segregación de los alelos.',
      'Ley de distribución independiente de caracteres.',
    ],
    dato: 'Un cruce monohíbrido heterocigoto da una proporción fenotípica 3:1.',
  ),
  'gen::Mutaciones': ContenidoTema(
    'Las mutaciones son cambios en la secuencia del ADN. Pueden ser silenciosas, de sentido erróneo, sin sentido o de cambio de marco.',
    [
      'Sustitución: cambia una base por otra.',
      'Inserción o deleción: puede alterar el marco de lectura.',
      'Reparación del ADN: detecta y corrige daños.',
    ],
    dato:
        'La expansión de repeticiones de trinucleótidos causa varias enfermedades neurodegenerativas.',
  ),
  'gen::Genética molecular': ContenidoTema(
    'Estudia la estructura y función de los genes, la replicación, la transcripción, el procesamiento del ARN y la traducción.',
    [
      'Replicación semiconservativa del ADN.',
      'Splicing: eliminación de intrones y unión de exones.',
      'Código genético: triplete que codifica aminoácidos.',
    ],
    dato: 'El código genético es casi universal entre los seres vivos.',
  ),
  'gen::Epigenética': ContenidoTema(
    'La epigenética estudia cambios heredables en la expresión génica que no alteran la secuencia del ADN.',
    [
      'Metilación del ADN: suele silenciar genes.',
      'Modificación de histonas: regula el acceso a la cromatina.',
      'Factores ambientales pueden modificar el epigenoma.',
    ],
    dato:
        'Los gemelos idénticos pueden mostrar diferencias epigenéticas con el tiempo.',
  ),
  'gen::Terapia génica': ContenidoTema(
    'La terapia génica busca corregir o compensar genes defectuosos mediante vectores virales o no virales.',
    [
      'Terapia ex vivo: células modificadas fuera del paciente.',
      'Terapia in vivo: vector administrado directamente.',
      'Riesgos: respuesta inmune e inserción fuera de lugar.',
    ],
    dato:
        'CRISPR permite editar genes con mayor precisión, pero su uso clínico aún se investiga.',
  ),
  'mic::Bacterias': ContenidoTema(
    'Las bacterias son procariotas con pared celular, membrana, citoplasma y ADN circular. Se clasifican por forma, tinción de Gram y metabolismo.',
    [
      'Cocos, bacilos y espirilos son formas frecuentes.',
      'Gram positivo: pared gruesa de peptidoglicano.',
      'Gram negativo: membrana externa y lipopolisacárido.',
    ],
    dato:
        'La tinción de Gram es una de las pruebas iniciales más útiles en microbiología clínica.',
  ),
  'mic::Virus': ContenidoTema(
    'Los virus son agentes infecciosos acelulares que necesitan una célula huésped para replicarse. Tienen material genético y una cápside.',
    [
      'ADN o ARN, nunca ambos.',
      'Ciclo lítico: replicación y liberación.',
      'Ciclo lisogénico: integración y latencia.',
    ],
    dato:
        'Los virus no responden a antibióticos; algunas infecciones virales se tratan con antivirales.',
  ),
  'mic::Hongos': ContenidoTema(
    'Los hongos son eucariotas con pared de quitina. Pueden ser unicelulares o filamentosos y causar infecciones superficiales o sistémicas.',
    [
      'Levaduras: reproducción por gemación.',
      'Mohos: hifas y micelio.',
      'Micosis: superficiales, subcutáneas y profundas.',
    ],
    dato:
        'Los hongos oportunistas son especialmente peligrosos en pacientes inmunosuprimidos.',
  ),
  'mic::Parásitos': ContenidoTema(
    'Los parásitos viven a expensas de un huésped. Incluyen protozoos, helmintos y artrópodos de importancia médica.',
    [
      'Protozoos: unicelulares, como Plasmodium.',
      'Helmintos: gusanos, como Ascaris.',
      'Ciclos biológicos complejos con vectores o huéspedes intermediarios.',
    ],
    dato:
        'La malaria se transmite por la picadura de mosquitos Anopheles hembra.',
  ),
  'mic::Antibióticos': ContenidoTema(
    'Los antibióticos actúan sobre estructuras bacterianas como la pared, la membrana, los ribosomas o la replicación del ADN.',
    [
      'Betalactámicos: inhiben la síntesis de la pared.',
      'Aminoglucósidos: afectan la síntesis proteica.',
      'El uso inadecuado favorece la resistencia bacteriana.',
    ],
    dato:
        'La resistencia a antibióticos es una de las principales amenazas de salud pública global.',
  ),
  'pat::Inflamación': ContenidoTema(
    'La inflamación es una respuesta vascular y celular frente a lesión o infección que busca eliminar la causa y reparar el tejido.',
    [
      'Signos cardinales: rubor, calor, tumor, dolor y pérdida de función.',
      'Inflamación aguda: neutrófilos y exudado.',
      'Inflamación crónica: macrófagos, linfocitos y fibrosis.',
    ],
    dato:
        'La inflamación puede ser protectora, pero también causar daño tisular si es excesiva.',
  ),
  'pat::Neoplasias': ContenidoTema(
    'Una neoplasia es una proliferación celular anormal e independiente. Puede ser benigna o maligna según invasión y metástasis.',
    [
      'Benigna: bien delimitada y sin metástasis.',
      'Maligna: invasiva y con capacidad metastásica.',
      'Carcinogénesis: acumulación de alteraciones genéticas.',
    ],
    dato:
        'La metástasis requiere invasión, intravasación, supervivencia y colonización de otro tejido.',
  ),
  'pat::Trastornos hemodinámicos': ContenidoTema(
    'Incluyen alteraciones del flujo sanguíneo como trombosis, embolia, isquemia, infarto, hemorragia y shock.',
    [
      'Trombosis: formación de un coágulo dentro de un vaso.',
      'Embolia: desplazamiento del trombo por la circulación.',
      'Infarto: necrosis por falta de irrigación.',
    ],
    dato:
        'La tríada de Virchow resume los factores de trombosis: lesión endotelial, estasis y hipercoagulabilidad.',
  ),
  'pat::Enfermedades infecciosas': ContenidoTema(
    'La patología infecciosa estudia la respuesta del tejido frente a bacterias, virus, hongos y parásitos.',
    [
      'Patrón inflamatorio según el agente.',
      'Granulomas: respuesta típica a algunos patógenos.',
      'Diagnóstico: clínica, cultivo y hallazgos histológicos.',
    ],
    dato:
        'Los granulomas contienen macrófagos activados y células gigantes multinucleadas.',
  ),
  'pat::Patología ambiental': ContenidoTema(
    'Estudia el efecto de factores ambientales como tóxicos, radiación, temperatura y contaminación sobre los tejidos.',
    [
      'Lesión celular por radicales libres.',
      'Radiación: daño directo e indirecto al ADN.',
      'Factores ocupacionales y contaminantes del aire.',
    ],
    dato:
        'Muchas enfermedades ambientales son prevenibles con medidas de protección y salud pública.',
  ),
};

ContenidoTema? contenidoParaTema(String? materiaId, String titulo) {
  if (materiaId == null) return null;
  return contenidosTemas['$materiaId::$titulo'];
}

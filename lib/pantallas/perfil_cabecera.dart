part of 'perfil.dart';

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.estado});
  final EstadoNuki estado;

  @override
  Widget build(BuildContext context) {
    final usuario = estado.usuario!;
    return Tarjeta(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 88,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colores.violeta, Colores.azulMedio],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -34),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colores.tarjeta,
                    shape: BoxShape.circle,
                  ),
                  child: AvatarNuki(
                    iniciales: usuario.iniciales,
                    tamano: 70,
                    colores: [Colores.celeste, Colores.azulMedio],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      usuario.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified_rounded,
                      color: Colores.celeste,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  usuario.esAdmin
                      ? 'Coordinador académico'
                      : usuario.esDocente
                      ? 'Docente'
                      : usuario.esInvitado
                      ? 'Explorando como invitado'
                      : usuario.rol,
                  style: const TextStyle(color: Colores.gris, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Etiqueta(
                  texto: usuario.esInvitado
                      ? 'SOLO LECTURA'
                      : usuario.rol.toUpperCase(),
                  color: usuario.esAdmin
                      ? Colores.coral
                      : usuario.esDocente
                      ? Colores.violeta
                      : Colores.azulMedio,
                  icono: usuario.esAdmin
                      ? Icons.shield_rounded
                      : usuario.esDocente
                      ? Icons.school_rounded
                      : Icons.badge_outlined,
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => usuario.esInvitado
                      ? estado.cerrarSesion()
                      : _editarPerfil(context, estado),
                  icon: Icon(
                    usuario.esInvitado
                        ? Icons.login_rounded
                        : Icons.edit_rounded,
                    size: 15,
                  ),
                  label: Text(
                    usuario.esInvitado ? 'Iniciar sesión' : 'Editar perfil',
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    textStyle: const TextStyle(fontSize: 11.5),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: _Estadistica(
                      valor: '${estado.materiasInscritas.length}',
                      etiqueta: 'Materias',
                    ),
                  ),
                  _Separador(),
                  Expanded(
                    child: _Estadistica(
                      valor: '${estado.logros}',
                      etiqueta: 'Logros',
                    ),
                  ),
                  _Separador(),
                  Expanded(
                    child: _Estadistica(
                      valor: '${estado.racha}',
                      etiqueta: 'Días racha',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: Colores.borde);
}

class _Estadistica extends StatelessWidget {
  const _Estadistica({required this.valor, required this.etiqueta});
  final String valor, etiqueta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colores.azul,
          ),
        ),
        Text(
          etiqueta,
          style: const TextStyle(
            fontSize: 10.5,
            color: Colores.gris,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

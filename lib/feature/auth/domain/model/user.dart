class User {
  final int id;
  final String email;
  final int idEmpresa;
  final String nombreEmpresa;
  final String razonSocial;
  final String ruc;
  final int rolId;
  final String rolNombre;
  final String token;
  final bool verificado;

  User({
    required this.id,
    required this.email,
    required this.idEmpresa,
    required this.nombreEmpresa,
    required this.razonSocial,
    required this.ruc,
    required this.rolId,
    required this.rolNombre,
    required this.token,
    required this.verificado,
  });
}

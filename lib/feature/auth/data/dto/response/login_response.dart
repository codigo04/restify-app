class LoginResponse {
  final int code;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message, 'data': data.toJson()};
  }
}

class LoginData {
  final Empresa empresa;
  final int idUsuario;
  final String token;
  final bool verificado;

  LoginData({
    required this.empresa,
    required this.idUsuario,
    required this.token,
    required this.verificado,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      empresa: Empresa.fromJson(json['empresa'] ?? {}),
      idUsuario: json['idUsuario'] ?? 0,
      token: json['token'] ?? '',
      verificado: json['verificado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empresa': empresa.toJson(),
      'idUsuario': idUsuario,
      'token': token,
      'verificado': verificado,
    };
  }
}

class Empresa {
  final int idEmpresa;
  final String nombreComercial;
  final String razonSocial;
  final String ruc;

  Empresa({
    required this.idEmpresa,
    required this.nombreComercial,
    required this.razonSocial,
    required this.ruc,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      idEmpresa: json['idEmpresa'] ?? 0,
      nombreComercial: json['nombreComercial'] ?? '',
      razonSocial: json['razonSocial'] ?? '',
      ruc: json['ruc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEmpresa': idEmpresa,
      'nombreComercial': nombreComercial,
      'razonSocial': razonSocial,
      'ruc': ruc,
    };
  }
}


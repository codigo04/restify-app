class MesaResponse {
  final int code;
  final String message;
  final List<MesaData> data;

  MesaResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MesaResponse.fromJson(Map<String, dynamic> json) {
    return MesaResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MesaData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MesaData {
  final int capacidad;
  final String estado;
  final int id;
  final int idempresa;
  final String numeromesa;

  MesaData({
    required this.capacidad,
    required this.estado,
    required this.id,
    required this.idempresa,
    required this.numeromesa,
  });

  factory MesaData.fromJson(Map<String, dynamic> json) {
    return MesaData(
      capacidad: json['capacidad'] ?? 0,
      estado: json['estado']?.toString() ?? '0',
      id: json['id'] ?? 0,
      idempresa: json['idempresa'] ?? 0,
      numeromesa: json['numeromesa']?.toString() ?? '',
    );
  }
}

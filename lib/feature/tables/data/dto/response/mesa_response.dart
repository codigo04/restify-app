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
  final int mesaId;
  final int empresaId;
  final String numeroMesa;
  final String nombre;
  final int capacidad;
  final String? ubicacion;
  final String estadoMesa;
  final bool isActive;
  final bool isDeleted;

  MesaData({
    required this.mesaId,
    required this.empresaId,
    required this.numeroMesa,
    required this.nombre,
    required this.capacidad,
    this.ubicacion,
    required this.estadoMesa,
    required this.isActive,
    required this.isDeleted,
  });

  factory MesaData.fromJson(Map<String, dynamic> json) {
    return MesaData(
      mesaId: json['mesaId'] ?? 0,
      empresaId: json['empresaId'] ?? 0,
      numeroMesa: json['numeroMesa']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      capacidad: json['capacidad'] ?? 0,
      ubicacion: json['ubicacion']?.toString(),
      estadoMesa: json['estadoMesa']?.toString() ?? 'LIBRE',
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}

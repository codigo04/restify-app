class CategoriaResponse {
  final List<CategoriaData> data;

  CategoriaResponse({required this.data});

  factory CategoriaResponse.fromJson(Map<String, dynamic> json) {
    return CategoriaResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CategoriaData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CategoriaData {
  final int categoriaId;
  final int empresaId;
  final int? categoriaPadreId;
  final String nombre;
  final String? descripcion;
  final int? orden;
  final bool isActive;
  final bool isDeleted;

  CategoriaData({
    required this.categoriaId,
    required this.empresaId,
    this.categoriaPadreId,
    required this.nombre,
    this.descripcion,
    this.orden,
    required this.isActive,
    required this.isDeleted,
  });

  factory CategoriaData.fromJson(Map<String, dynamic> json) {
    return CategoriaData(
      categoriaId: json['categoriaId'] ?? 0,
      empresaId: json['empresaId'] ?? 0,
      categoriaPadreId: json['categoriaPadreId'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion']?.toString(),
      orden: json['orden'],
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}

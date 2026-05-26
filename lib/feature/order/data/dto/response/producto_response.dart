class ProductoResponse {
  final List<ProductoData> data;

  ProductoResponse({required this.data});

  factory ProductoResponse.fromJson(Map<String, dynamic> json) {
    return ProductoResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ProductoData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductoData {
  final int id;
  final String nombre;
  final double precio;
  final String? descripcion;
  final String? imagen;
  final bool estado;
  final bool eliminado;
  final String? porcion;
  final int stock;
  final String? litros;
  final int idCategoria;
  final int idUnidadMedida;
  final String? codigoSunat;
  final int idEmpresa;

  ProductoData({
    required this.id,
    required this.nombre,
    required this.precio,
    this.descripcion,
    this.imagen,
    required this.estado,
    required this.eliminado,
    this.porcion,
    required this.stock,
    this.litros,
    required this.idCategoria,
    required this.idUnidadMedida,
    this.codigoSunat,
    required this.idEmpresa,
  });

  factory ProductoData.fromJson(Map<String, dynamic> json) {
    return ProductoData(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      descripcion: json['descripcion']?.toString(),
      imagen: json['imagen']?.toString(),
      estado: json['estado'] ?? true,
      eliminado: json['eliminado'] ?? false,
      porcion: json['porcion']?.toString(),
      stock: json['stock'] ?? 0,
      litros: json['litros']?.toString(),
      idCategoria: json['idCategoria'] ?? 0,
      idUnidadMedida: json['idUnidadMedida'] ?? 0,
      codigoSunat: json['codigoSunat']?.toString(),
      idEmpresa: json['idEmpresa'] ?? 0,
    );
  }
}

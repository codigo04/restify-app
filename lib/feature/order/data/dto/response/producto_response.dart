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
  final int productoId;
  final int empresaId;
  final int categoriaId;
  final String? categoriaNombre;
  final int unidadMedidaId;
  final String? unidadMedidaNombre;
  final String? unidadMedidaCodigoSunat;
  final String? codigoProducto;
  final String nombre;
  final String? descripcion;
  final String? tipoProducto;
  final double precioVenta;
  final bool afectaIgv;
  final String? imagenUrl;
  final bool isActive;
  final bool isDeleted;

  ProductoData({
    required this.productoId,
    required this.empresaId,
    required this.categoriaId,
    this.categoriaNombre,
    required this.unidadMedidaId,
    this.unidadMedidaNombre,
    this.unidadMedidaCodigoSunat,
    this.codigoProducto,
    required this.nombre,
    this.descripcion,
    this.tipoProducto,
    required this.precioVenta,
    required this.afectaIgv,
    this.imagenUrl,
    required this.isActive,
    required this.isDeleted,
  });

  factory ProductoData.fromJson(Map<String, dynamic> json) {
    return ProductoData(
      productoId: json['productoId'] ?? 0,
      empresaId: json['empresaId'] ?? 0,
      categoriaId: json['categoriaId'] ?? 0,
      categoriaNombre: json['categoriaNombre']?.toString(),
      unidadMedidaId: json['unidadMedidaId'] ?? 0,
      unidadMedidaNombre: json['unidadMedidaNombre']?.toString(),
      unidadMedidaCodigoSunat: json['unidadMedidaCodigoSunat']?.toString(),
      codigoProducto: json['codigoProducto']?.toString(),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion']?.toString(),
      tipoProducto: json['tipoProducto']?.toString(),
      precioVenta: (json['precioVenta'] as num?)?.toDouble() ?? 0.0,
      afectaIgv: json['afectaIgv'] ?? false,
      imagenUrl: json['imagenUrl']?.toString(),
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}

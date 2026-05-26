class ProductoModel {
  final int id;
  final String nombre;
  final double precio;
  final String? descripcion;
  final String? imagen;
  final bool estado;
  final int stock;
  final String? litros;
  final int idCategoria;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    this.descripcion,
    this.imagen,
    required this.estado,
    required this.stock,
    this.litros,
    required this.idCategoria,
  });

  bool get disponible => estado && stock > 0;
}

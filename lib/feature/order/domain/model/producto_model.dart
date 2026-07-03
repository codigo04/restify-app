class ProductoModel {
  final int id;
  final String nombre;
  final double precio;
  final String? descripcion;
  final String? imagen;
  final bool estado;
  final int idCategoria;
  final String? categoriaNombre;

  ProductoModel({
    required this.id,
    required this.nombre,
    required this.precio,
    this.descripcion,
    this.imagen,
    required this.estado,
    required this.idCategoria,
    this.categoriaNombre,
  });

  bool get disponible => estado;
}

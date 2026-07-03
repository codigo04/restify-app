import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/order/data/datasource/producto_datasource.dart';
import 'package:restifyapp/feature/order/data/dto/response/producto_response.dart';
import 'package:restifyapp/feature/order/domain/model/producto_model.dart';
import 'package:restifyapp/feature/order/domain/repository/producto_repository.dart';

@LazySingleton(as: ProductoRepository)
class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoDataSource dataSource;

  ProductoRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductoModel>> getProductosByEmpresa(int idEmpresa) async {
    final response = await dataSource.getProductosByEmpresa(idEmpresa);
    return response.data.map(_toModel).toList();
  }

  @override
  Future<List<ProductoModel>> getProductosByCategoria(int categoriaId) async {
    final response = await dataSource.getProductosByCategoria(categoriaId);
    return response.data.map(_toModel).toList();
  }

  @override
  Future<List<ProductoModel>> buscarProductos({
    required String search,
    int? categoriaId,
  }) async {
    final response = await dataSource.buscarProductos(
      search: search,
      categoriaId: categoriaId,
    );
    return response.data.map(_toModel).toList();
  }

  ProductoModel _toModel(ProductoData producto) {
    return ProductoModel(
      id: producto.productoId,
      nombre: producto.nombre,
      precio: producto.precioVenta,
      descripcion: producto.descripcion,
      imagen: producto.imagenUrl,
      estado: producto.isActive,
      idCategoria: producto.categoriaId,
      categoriaNombre: producto.categoriaNombre,
    );
  }
}

import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/order/data/datasource/producto_datasource.dart';
import 'package:restifyapp/feature/order/domain/model/producto_model.dart';
import 'package:restifyapp/feature/order/domain/repository/producto_repository.dart';

@LazySingleton(as: ProductoRepository)
class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoDataSource dataSource;

  ProductoRepositoryImpl({required this.dataSource});

  @override
  Future<List<ProductoModel>> getProductosByEmpresa(int idEmpresa) async {
    try {
      final response = await dataSource.getProductosByEmpresa(idEmpresa);
      return response.data.map((producto) {
        return ProductoModel(
          id: producto.id,
          nombre: producto.nombre,
          precio: producto.precio,
          descripcion: producto.descripcion,
          imagen: producto.imagen,
          estado: producto.estado,
          stock: producto.stock,
          litros: producto.litros,
          idCategoria: producto.idCategoria,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}

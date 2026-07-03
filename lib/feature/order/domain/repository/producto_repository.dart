import 'package:restifyapp/feature/order/domain/model/producto_model.dart';

abstract class ProductoRepository {
  Future<List<ProductoModel>> getProductosByEmpresa(int idEmpresa);
  Future<List<ProductoModel>> getProductosByCategoria(int categoriaId);
  Future<List<ProductoModel>> buscarProductos({
    required String search,
    int? categoriaId,
  });
}

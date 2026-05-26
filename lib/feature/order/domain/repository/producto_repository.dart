import 'package:restifyapp/feature/order/domain/model/producto_model.dart';

abstract class ProductoRepository {
  Future<List<ProductoModel>> getProductosByEmpresa(int idEmpresa);
}

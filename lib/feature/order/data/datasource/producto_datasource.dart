import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/order/data/dto/response/producto_response.dart';

abstract class ProductoDataSource {
  Future<ProductoResponse> getProductosByEmpresa(int idEmpresa);
}

@LazySingleton(as: ProductoDataSource)
class ProductoDataSourceImpl implements ProductoDataSource {
  final ApiClient _client;

  ProductoDataSourceImpl(this._client);

  @override
  Future<ProductoResponse> getProductosByEmpresa(int idEmpresa) async {
    try {
      final response =
          await _client.dio.get('/api/v1/menu/producto/empresa/$idEmpresa');

      if (response.statusCode == 200) {
        return ProductoResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener productos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

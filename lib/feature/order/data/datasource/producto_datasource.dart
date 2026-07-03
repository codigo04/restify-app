import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/order/data/dto/response/producto_response.dart';

abstract class ProductoDataSource {
  Future<ProductoResponse> getProductosByEmpresa(int idEmpresa);
  Future<ProductoResponse> getProductosByCategoria(int categoriaId);
  Future<ProductoResponse> buscarProductos({
    required String search,
    int? categoriaId,
  });
}

@LazySingleton(as: ProductoDataSource)
class ProductoDataSourceImpl implements ProductoDataSource {
  final ApiClient _client;

  ProductoDataSourceImpl(this._client);

  @override
  Future<ProductoResponse> getProductosByEmpresa(int idEmpresa) async {
    try {
      final response = await _client.dio.get(
        '/api/v1/catalogo-service/productos',
      );

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

  @override
  Future<ProductoResponse> getProductosByCategoria(int categoriaId) async {
    try {
      final response = await _client.dio.get(
        '/api/v1/catalogo-service/productos/categoria/$categoriaId',
      );

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

  @override
  Future<ProductoResponse> buscarProductos({
    required String search,
    int? categoriaId,
  }) async {
    try {
      final response = await _client.dio.get(
        '/api/v1/catalogo-service/productos/buscar',
        queryParameters: {
          if (search.isNotEmpty) 'search': search,
          if (categoriaId != null) 'categoriaId': categoriaId,
          'soloActivos': true,
        },
      );

      if (response.statusCode == 200) {
        return ProductoResponse.fromJson(response.data);
      } else {
        throw Exception('Error al buscar productos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

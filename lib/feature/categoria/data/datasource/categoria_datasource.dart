import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/categoria/data/dto/response/categoria_response.dart';

abstract class CategoriaDataSource {
  Future<CategoriaResponse> getCategoriasActivas();
}

@LazySingleton(as: CategoriaDataSource)
class CategoriaDataSourceImpl implements CategoriaDataSource {
  final ApiClient _client;

  CategoriaDataSourceImpl(this._client);

  @override
  Future<CategoriaResponse> getCategoriasActivas() async {
    try {
      final response = await _client.dio.get(
        '/api/v1/catalogo-service/categorias/activos',
      );

      if (response.statusCode == 200) {
        return CategoriaResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener categorías: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

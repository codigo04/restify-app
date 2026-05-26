import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/tables/data/dto/response/mesa_response.dart';

abstract class MesaDataSource {
  Future<MesaResponse> getMesas();
}

@LazySingleton(as: MesaDataSource)
class MesaDataSourceImpl implements MesaDataSource {
  final ApiClient _client;

  MesaDataSourceImpl(this._client);

  @override
  Future<MesaResponse> getMesas() async {
    try {
      final response = await _client.dio.get('/api/v1/order/mesa');

      if (response.statusCode == 200) {
        return MesaResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener mesas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

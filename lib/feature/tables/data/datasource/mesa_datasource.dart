import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/tables/data/dto/response/mesa_response.dart';

abstract class MesaDataSource {
  Future<MesaResponse> getMesas();
  Future<void> cambiarEstado(int mesaId, String estadoMesa);
}

@LazySingleton(as: MesaDataSource)
class MesaDataSourceImpl implements MesaDataSource {
  final ApiClient _client;

  MesaDataSourceImpl(this._client);

  @override
  Future<MesaResponse> getMesas() async {
    try {
      final response = await _client.dio.get('/api/v1/pedido-service/mesas');

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

  @override
  Future<void> cambiarEstado(int mesaId, String estadoMesa) async {
    try {
      final response = await _client.dio.patch(
        '/api/v1/pedido-service/mesas/$mesaId/estado',
        data: {'estadoMesa': estadoMesa},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Error al cambiar el estado de la mesa: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

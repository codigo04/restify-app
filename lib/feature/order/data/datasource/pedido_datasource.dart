import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restifyapp/core/network/api_client.dart';
import 'package:restifyapp/feature/order/data/dto/request/pedido_create_request.dart';
import 'package:restifyapp/feature/order/data/dto/response/pedido_response.dart';

abstract class PedidoDataSource {
  Future<PedidoResponse> crearPedido(PedidoCreateRequest request);
  Future<PedidoListResponse> getPedidosActivos();
  Future<PedidoListResponse> getTodosLosPedidos();
  Future<PedidoResponse> cambiarEstado(int pedidoId, String estadoPedido);
}

@LazySingleton(as: PedidoDataSource)
class PedidoDataSourceImpl implements PedidoDataSource {
  final ApiClient _client;

  PedidoDataSourceImpl(this._client);

  @override
  Future<PedidoResponse> crearPedido(PedidoCreateRequest request) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/pedido-service/pedidos',
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PedidoResponse.fromJson(response.data);
      } else {
        throw Exception('Error al crear el pedido: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<PedidoListResponse> getPedidosActivos() async {
    try {
      final response = await _client.dio.get(
        '/api/v1/pedido-service/pedidos/activos',
      );

      if (response.statusCode == 200) {
        return PedidoListResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener pedidos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<PedidoListResponse> getTodosLosPedidos() async {
    try {
      final response = await _client.dio.get('/api/v1/pedido-service/pedidos');

      if (response.statusCode == 200) {
        return PedidoListResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener pedidos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<PedidoResponse> cambiarEstado(int pedidoId, String estadoPedido) async {
    try {
      final response = await _client.dio.patch(
        '/api/v1/pedido-service/pedidos/$pedidoId/estado',
        data: {'estadoPedido': estadoPedido},
      );

      if (response.statusCode == 200) {
        return PedidoResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Error al cambiar el estado del pedido: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Error inesperado: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

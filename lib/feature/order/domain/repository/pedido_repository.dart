import 'package:restifyapp/feature/order/data/dto/request/pedido_create_request.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';

abstract class PedidoRepository {
  Future<PedidoModel> crearPedido(PedidoCreateRequest request);
  Future<List<PedidoModel>> getPedidosActivos();
  Future<List<PedidoModel>> getTodosLosPedidos();
  Future<PedidoModel> cambiarEstado(int pedidoId, String estadoPedido);
}

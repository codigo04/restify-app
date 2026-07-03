import 'package:injectable/injectable.dart';
import 'package:restifyapp/feature/order/data/datasource/pedido_datasource.dart';
import 'package:restifyapp/feature/order/data/dto/request/pedido_create_request.dart';
import 'package:restifyapp/feature/order/data/dto/response/pedido_response.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';
import 'package:restifyapp/feature/order/domain/repository/pedido_repository.dart';

@LazySingleton(as: PedidoRepository)
class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoDataSource dataSource;

  PedidoRepositoryImpl({required this.dataSource});

  @override
  Future<PedidoModel> crearPedido(PedidoCreateRequest request) async {
    final response = await dataSource.crearPedido(request);
    return _toModel(response.data);
  }

  @override
  Future<List<PedidoModel>> getPedidosActivos() async {
    final response = await dataSource.getPedidosActivos();
    return response.data.map(_toModel).toList();
  }

  @override
  Future<List<PedidoModel>> getTodosLosPedidos() async {
    final response = await dataSource.getTodosLosPedidos();
    return response.data.map(_toModel).toList();
  }

  @override
  Future<PedidoModel> cambiarEstado(int pedidoId, String estadoPedido) async {
    final response = await dataSource.cambiarEstado(pedidoId, estadoPedido);
    return _toModel(response.data);
  }

  PedidoModel _toModel(PedidoData pedido) {
    return PedidoModel(
      id: pedido.pedidoId,
      mesaId: pedido.mesaId,
      usuarioMeseroId: pedido.usuarioMeseroId,
      numeroPedido: pedido.numeroPedido,
      estado: pedido.estadoPedido,
      fechaPedido: pedido.fechaPedido,
      subtotal: pedido.subtotal,
      igv: pedido.igv,
      total: pedido.total,
      isActive: pedido.isActive,
      detalles: pedido.detalles
          .map(
            (d) => DetallePedidoModel(
              id: d.detallePedidoId,
              productoId: d.productoId,
              nombre: d.descripcionItem ?? 'Producto',
              cantidad: d.cantidad,
              observacion: d.observacion,
            ),
          )
          .toList(),
    );
  }
}

class PedidoModel {
  final int id;
  final int? mesaId;
  final int? usuarioMeseroId;
  final String? numeroPedido;
  final String? estado;
  final DateTime? fechaPedido;
  final double subtotal;
  final double igv;
  final double total;
  final bool isActive;
  final List<DetallePedidoModel> detalles;

  PedidoModel({
    required this.id,
    this.mesaId,
    this.usuarioMeseroId,
    this.numeroPedido,
    this.estado,
    this.fechaPedido,
    required this.subtotal,
    required this.igv,
    required this.total,
    required this.isActive,
    this.detalles = const [],
  });
}

class DetallePedidoModel {
  final int id;
  final int? productoId;
  final String nombre;
  final double cantidad;
  final String? observacion;

  DetallePedidoModel({
    required this.id,
    this.productoId,
    required this.nombre,
    required this.cantidad,
    this.observacion,
  });
}

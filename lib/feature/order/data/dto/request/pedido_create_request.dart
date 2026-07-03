class PedidoCreateRequest {
  final int mesaId;
  final String? observacion;
  final List<DetallePedidoRequest> detalles;

  PedidoCreateRequest({
    required this.mesaId,
    this.observacion,
    required this.detalles,
  });

  Map<String, dynamic> toJson() {
    return {
      'mesaId': mesaId,
      'tipoPedido': 'MESA',
      if (observacion != null) 'observacion': observacion,
      'detalles': detalles.map((d) => d.toJson()).toList(),
    };
  }
}

class DetallePedidoRequest {
  final int productoId;
  final String? descripcionItem;
  final num cantidad;
  final double precioUnitario;
  final String? observacion;

  DetallePedidoRequest({
    required this.productoId,
    this.descripcionItem,
    required this.cantidad,
    required this.precioUnitario,
    this.observacion,
  });

  Map<String, dynamic> toJson() {
    return {
      'productoId': productoId,
      if (descripcionItem != null) 'descripcionItem': descripcionItem,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      if (observacion != null) 'observacion': observacion,
    };
  }
}

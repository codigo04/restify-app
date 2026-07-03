/// El backend envía `LocalDateTime` sin offset (hora del servidor, UTC).
/// Si se interpreta como hora local del dispositivo, la diferencia de
/// zonas horarias produce minutos transcurridos absurdos (ej. "300m").
DateTime? _parseFechaUtc(dynamic value) {
  if (value == null) return null;
  final raw = value.toString();
  final hasOffset = raw.endsWith('Z') || RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(raw);
  final parsed = DateTime.tryParse(hasOffset ? raw : '${raw}Z');
  return parsed?.toLocal();
}

class PedidoResponse {
  final PedidoData data;

  PedidoResponse({required this.data});

  factory PedidoResponse.fromJson(Map<String, dynamic> json) {
    return PedidoResponse(
      data: PedidoData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class PedidoListResponse {
  final List<PedidoData> data;

  PedidoListResponse({required this.data});

  factory PedidoListResponse.fromJson(Map<String, dynamic> json) {
    return PedidoListResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PedidoData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PedidoData {
  final int pedidoId;
  final int? mesaId;
  final int? usuarioMeseroId;
  final String? numeroPedido;
  final String? estadoPedido;
  final DateTime? fechaPedido;
  final double subtotal;
  final double igv;
  final double total;
  final bool isActive;
  final List<DetallePedidoData> detalles;

  PedidoData({
    required this.pedidoId,
    this.mesaId,
    this.usuarioMeseroId,
    this.numeroPedido,
    this.estadoPedido,
    this.fechaPedido,
    required this.subtotal,
    required this.igv,
    required this.total,
    required this.isActive,
    this.detalles = const [],
  });

  factory PedidoData.fromJson(Map<String, dynamic> json) {
    return PedidoData(
      pedidoId: json['pedidoId'] ?? 0,
      mesaId: json['mesaId'],
      usuarioMeseroId: json['usuarioMeseroId'],
      numeroPedido: json['numeroPedido']?.toString(),
      estadoPedido: json['estadoPedido']?.toString(),
      fechaPedido: _parseFechaUtc(json['fechaPedido']),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      igv: (json['igv'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? true,
      detalles: (json['detalles'] as List<dynamic>? ?? [])
          .map((e) => DetallePedidoData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DetallePedidoData {
  final int detallePedidoId;
  final int? productoId;
  final String? descripcionItem;
  final double cantidad;
  final String? observacion;

  DetallePedidoData({
    required this.detallePedidoId,
    this.productoId,
    this.descripcionItem,
    required this.cantidad,
    this.observacion,
  });

  factory DetallePedidoData.fromJson(Map<String, dynamic> json) {
    return DetallePedidoData(
      detallePedidoId: json['detallePedidoId'] ?? 0,
      productoId: json['productoId'],
      descripcionItem: json['descripcionItem']?.toString(),
      cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0.0,
      observacion: json['observacion']?.toString(),
    );
  }
}

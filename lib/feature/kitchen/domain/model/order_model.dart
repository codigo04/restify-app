import 'package:restifyapp/feature/order/domain/model/product_model.dart';

enum OrderStatus { pending, preparing, ready, delivered }

class OrderItemModel {
  final ProductModel product;
  final int quantity;
  final String notes;

  OrderItemModel({
    required this.product,
    this.quantity = 1,
    this.notes = '',
  });
}

class OrderModel {
  final String id;
  final String tableName;
  final List<OrderItemModel> items;
  final DateTime timestamp;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.tableName,
    required this.items,
    required this.timestamp,
    this.status = OrderStatus.pending,
  });
}

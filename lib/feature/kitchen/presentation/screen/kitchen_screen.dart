import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/kitchen/domain/model/order_model.dart';
import 'package:restifyapp/feature/order/domain/model/product_model.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  // Datos de prueba: Comandas activas en cocina
  final List<OrderModel> _activeOrders = [
    OrderModel(
      id: '101',
      tableName: 'Mesa 2',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      status: OrderStatus.preparing,
      items: [
        OrderItemModel(product: ProductModel(id: '3', name: 'Lomo Saltado', price: 45, category: 'Fondo', description: ''), quantity: 2),
        OrderItemModel(product: ProductModel(id: '6', name: 'Chicha Morada', price: 15, category: 'Bebida', description: ''), quantity: 1),
      ],
    ),
    OrderModel(
      id: '102',
      tableName: 'Mesa 6',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: OrderStatus.pending,
      items: [
        OrderItemModel(product: ProductModel(id: '2', name: 'Ceviche Clásico', price: 35, category: 'Entrada', description: ''), quantity: 1, notes: 'Sin mucho picante'),
        OrderItemModel(product: ProductModel(id: '5', name: 'Arroz con Mariscos', price: 48, category: 'Fondo', description: ''), quantity: 1),
      ],
    ),
    OrderModel(
      id: '103',
      tableName: 'Mesa 9',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      status: OrderStatus.pending,
      items: [
        OrderItemModel(product: ProductModel(id: '1', name: 'Tequeños', price: 12, category: 'Entrada', description: ''), quantity: 3),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Color oscuro para KDS (estándar industrial)
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'COCINA (KDS)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${_activeOrders.length} PEDIDOS',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: _activeOrders.isEmpty
          ? const Center(child: Text('Sin pedidos pendientes', style: TextStyle(color: Colors.white54)))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: _activeOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderTicket(_activeOrders[index]);
              },
            ),
    );
  }

  Widget _buildOrderTicket(OrderModel order) {
    final minutesAgo = DateTime.now().difference(order.timestamp).inMinutes;
    final bool isLate = minutesAgo > 10;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLate ? Colors.red : Colors.grey.shade800,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del Ticket
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isLate ? Colors.red.withOpacity(0.2) : Colors.grey.shade900,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.tableName.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '${minutesAgo}m',
                  style: TextStyle(
                    color: isLate ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: order.items.length,
              itemBuilder: (context, idx) {
                final item = order.items[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.quantity}x ',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      if (item.notes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24, top: 4),
                          child: Text(
                            '• ${item.notes}',
                            style: const TextStyle(color: Colors.orangeAccent, fontSize: 13, fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Botones de Acción
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _activeOrders.remove(order);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${order.tableName} marcado como LISTO')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text('LISTO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

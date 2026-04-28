import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/order/presentation/screen/order_taking_screen.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  // Datos de prueba simulando las mesas del restaurante
  final List<TableModel> _mockTables = [
    TableModel(id: '1', name: 'Mesa 1', capacity: 4, status: TableStatus.available),
    TableModel(id: '2', name: 'Mesa 2', capacity: 2, status: TableStatus.occupied),
    TableModel(id: '3', name: 'Mesa 3', capacity: 4, status: TableStatus.reserved),
    TableModel(id: '4', name: 'Mesa 4', capacity: 6, status: TableStatus.available),
    TableModel(id: '5', name: 'Mesa 5', capacity: 2, status: TableStatus.cleaning),
    TableModel(id: '6', name: 'Mesa 6', capacity: 4, status: TableStatus.occupied),
    TableModel(id: '7', name: 'Mesa 7', capacity: 8, status: TableStatus.available),
    TableModel(id: '8', name: 'Mesa 8', capacity: 4, status: TableStatus.available),
    TableModel(id: '9', name: 'Mesa 9', capacity: 2, status: TableStatus.occupied),
    TableModel(id: '10', name: 'Mesa 10', capacity: 4, status: TableStatus.reserved),
    TableModel(id: '11', name: 'Mesa 11', capacity: 6, status: TableStatus.available),
    TableModel(id: '12', name: 'Mesa 12', capacity: 2, status: TableStatus.cleaning),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Salón Principal',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            onPressed: () {
              // Recargar estado de mesas
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildStatusLegend(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 mesas por fila
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: _mockTables.length,
              itemBuilder: (context, index) {
                final table = _mockTables[index];
                return _buildTableCard(table);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legendItem('Libre', AppColors.success),
          _legendItem('Ocupada', AppColors.error),
          _legendItem('Reservada', Colors.blue),
          _legendItem('Limpiando', Colors.orange),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTableCard(TableModel table) {
    Color statusColor;
    switch (table.status) {
      case TableStatus.available:
        statusColor = AppColors.success;
        break;
      case TableStatus.occupied:
        statusColor = AppColors.error;
        break;
      case TableStatus.reserved:
        statusColor = Colors.blue;
        break;
      case TableStatus.cleaning:
        statusColor = Colors.orange;
        break;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTakingScreen(table: table),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                table.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              Icons.table_restaurant,
              size: 32,
              color: statusColor,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 2),
                Text(
                  '${table.capacity}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

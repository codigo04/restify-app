import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/order/domain/model/product_model.dart';

class OrderTakingScreen extends StatefulWidget {
  final TableModel table;

  const OrderTakingScreen({super.key, required this.table});

  @override
  State<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends State<OrderTakingScreen> {
  // Lista temporal para almacenar los productos seleccionados (el "carrito" de la mesa)
  final List<ProductModel> _currentOrder = [];
  
  String _selectedCategory = 'Entradas';

  final List<String> _categories = ['Entradas', 'Platos de Fondo', 'Bebidas', 'Postres'];

  // Datos simulados del menú
  final List<ProductModel> _mockMenu = [
    ProductModel(id: '1', name: 'Tequeños de Queso', description: 'Con salsa de palta', price: 12.0, category: 'Entradas'),
    ProductModel(id: '2', name: 'Ceviche Clásico', description: 'Pescado fresco del día', price: 35.0, category: 'Entradas'),
    ProductModel(id: '3', name: 'Lomo Saltado', description: 'Con papas fritas y arroz', price: 45.0, category: 'Platos de Fondo'),
    ProductModel(id: '4', name: 'Ají de Gallina', description: 'Receta tradicional', price: 30.0, category: 'Platos de Fondo'),
    ProductModel(id: '5', name: 'Arroz con Mariscos', description: 'Mixtura de mariscos frescos', price: 48.0, category: 'Platos de Fondo'),
    ProductModel(id: '6', name: 'Chicha Morada', description: 'Jarra de 1 litro', price: 15.0, category: 'Bebidas'),
    ProductModel(id: '7', name: 'Limonada Frozen', description: 'Vaso personal', price: 8.0, category: 'Bebidas'),
    ProductModel(id: '8', name: 'Suspiro a la Limeña', description: 'Postre clásico', price: 12.0, category: 'Postres'),
    ProductModel(id: '9', name: 'Torta de Chocolate', description: 'Porción generosa', price: 15.0, category: 'Postres'),
  ];

  List<ProductModel> get _filteredProducts {
    return _mockMenu.where((p) => p.category == _selectedCategory).toList();
  }

  void _addToOrder(ProductModel product) {
    setState(() {
      _currentOrder.add(product);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tomar Pedido',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${widget.table.name} • ${_currentOrder.length} ítems',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {
              // Buscar producto
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _buildProductsGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _currentOrder.isNotEmpty ? _buildBottomCart() : null,
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) {
      return const Center(child: Text('No hay productos en esta categoría'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas en teléfonos, en tablet podrían ser más
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return InkWell(
          onTap: () => _addToOrder(product),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simulación de imagen del producto
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(Icons.fastfood, color: Colors.grey.shade400, size: 40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomCart() {
    final total = _currentOrder.fold(0.0, (sum, item) => sum + item.price);
    
    return Container(
      padding: EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total (${_currentOrder.length} ítems)',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                Text(
                  'S/ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navegar al resumen del carrito y enviar comanda a cocina
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comanda enviada a cocina')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enviar Comanda', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

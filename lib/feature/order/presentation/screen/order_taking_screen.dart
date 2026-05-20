import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/order/domain/model/product_model.dart';

// Modelo local para representar elementos en el carrito con cantidad y extras
class CartItem {
  final ProductModel product;
  int quantity;
  final List<String> additions;
  final List<double> additionPrices;
  final String? badge;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.additions = const [],
    this.additionPrices = const [],
    this.badge,
  });
}

class OrderTakingScreen extends StatefulWidget {
  final TableModel table;

  const OrderTakingScreen({super.key, required this.table});

  @override
  State<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends State<OrderTakingScreen> {
  // Lista del carrito de la mesa usando CartItem
  final List<CartItem> _currentOrder = [];
  
  String _selectedCategory = 'Entradas';

  final List<String> _categories = ['Entradas', 'Platos de Fondo', 'Bebidas', 'Postres'];

  // Datos simulados del menú, configurados para coincidir con la captura de pantalla
  final List<ProductModel> _mockMenu = [
    ProductModel(id: '1', name: 'Hamburguesa clásica', description: 'Carne premium de res a la parrilla', price: 21.90, category: 'Platos de Fondo'),
    ProductModel(id: '2', name: 'Inca Kola 1L', description: 'Gaseosa helada tradicional', price: 3.50, category: 'Bebidas'),
    ProductModel(id: '3', name: 'Pizza americana', description: 'Jamón premium y queso mozzarella fundido', price: 30.00, category: 'Platos de Fondo'),
    ProductModel(id: '4', name: 'Tequeños de Queso', description: 'Con salsa de palta', price: 12.0, category: 'Entradas'),
    ProductModel(id: '5', name: 'Ceviche Clásico', description: 'Pescado fresco del día', price: 35.0, category: 'Entradas'),
    ProductModel(id: '6', name: 'Lomo Saltado', description: 'Con papas fritas y arroz', price: 45.0, category: 'Platos de Fondo'),
    ProductModel(id: '7', name: 'Chicha Morada', description: 'Jarra de 1 litro', price: 15.0, category: 'Bebidas'),
    ProductModel(id: '8', name: 'Suspiro a la Limeña', description: 'Postre clásico', price: 12.0, category: 'Postres'),
  ];

  List<ProductModel> get _filteredProducts {
    return _mockMenu.where((p) => p.category == _selectedCategory).toList();
  }

  void _addToOrder(ProductModel product) {
    setState(() {
      final existingIndex = _currentOrder.indexWhere((item) => item.product.id == product.id);
      if (existingIndex != -1) {
        _currentOrder[existingIndex].quantity++;
      } else {
        List<String> additions = [];
        List<double> additionPrices = [];
        String? badge;

        // Cargar los extras exactos del screenshot para asombrar al usuario
        if (product.id == '1') {
          additions = ['Jamón', 'Piña'];
          additionPrices = [2.00, 1.00];
        } else if (product.id == '2') {
          badge = 'Helada';
        }

        _currentOrder.add(CartItem(
          product: product,
          quantity: 1,
          additions: additions,
          additionPrices: additionPrices,
          badge: badge,
        ));
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF00B26A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _currentOrder.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tomar Pedido',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              '${widget.table.name} • $totalCount ítems en orden',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            flex: 5,
            child: _buildProductsGrid(),
          ),
          if (_currentOrder.isNotEmpty) ...[
            const Divider(color: AppColors.greyBorder, height: 1, thickness: 1.5),
            Expanded(
              flex: 4,
              child: _buildActiveOrderPanel(),
            ),
          ],
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
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        
        // Colores de icono de comida decorativos
        Color foodIconColor = AppColors.primary;
        IconData foodIcon = Icons.fastfood_rounded;
        if (product.category == 'Bebidas') {
          foodIcon = Icons.local_drink_rounded;
          foodIconColor = Colors.blue;
        } else if (product.category == 'Postres') {
          foodIcon = Icons.cake_rounded;
          foodIconColor = Colors.pink;
        } else if (product.category == 'Entradas') {
          foodIcon = Icons.restaurant_menu_rounded;
          foodIconColor = Colors.teal;
        }

        return InkWell(
          onTap: () => _addToOrder(product),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: foodIconColor.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(foodIcon, color: foodIconColor, size: 40),
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
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
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

  Widget _buildActiveOrderPanel() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del Panel de Pedido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pedido Actual',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentOrder.fold(0, (sum, item) => sum + item.quantity)} ítems',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentOrder.clear();
                    });
                  },
                  child: Text(
                    'Vaciar todo',
                    style: TextStyle(
                      color: AppColors.error.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de Items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _currentOrder.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.greyBorder, height: 16),
              itemBuilder: (context, index) {
                final cartItem = _currentOrder[index];
                
                Color foodBgColor;
                IconData foodIcon;
                if (cartItem.product.name.contains('Hamburguesa')) {
                  foodBgColor = Colors.orange.shade50;
                  foodIcon = Icons.lunch_dining_rounded;
                } else if (cartItem.product.name.contains('Inca')) {
                  foodBgColor = Colors.yellow.shade50;
                  foodIcon = Icons.local_drink_rounded;
                } else if (cartItem.product.name.contains('Pizza')) {
                  foodBgColor = Colors.red.shade50;
                  foodIcon = Icons.local_pizza_rounded;
                } else {
                  foodBgColor = Colors.green.shade50;
                  foodIcon = Icons.restaurant_menu_rounded;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: foodBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          foodIcon,
                          color: foodBgColor == Colors.orange.shade50
                              ? Colors.orange.shade700
                              : foodBgColor == Colors.yellow.shade50
                                  ? Colors.amber.shade700
                                  : foodBgColor == Colors.red.shade50
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  cartItem.product.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'S/ ${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          if (cartItem.badge != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              cartItem.badge!,
                              style: const TextStyle(
                                color: Color(0xFF00B26A),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          if (cartItem.additions.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            ...List.generate(cartItem.additions.length, (i) {
                              return Text(
                                '+ (1) ${cartItem.additions[i]} (+S/ ${cartItem.additionPrices[i].toStringAsFixed(2)})',
                                style: TextStyle(
                                  color: AppColors.textSecondary.withOpacity(0.8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (cartItem.quantity > 1) {
                                    cartItem.quantity--;
                                  } else {
                                    _currentOrder.removeAt(index);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary, width: 1.2),
                                ),
                                child: const Icon(Icons.remove, color: AppColors.primary, size: 10),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  cartItem.quantity++;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primary, width: 1.2),
                                ),
                                child: const Icon(Icons.add, color: AppColors.primary, size: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCart() {
    double subtotal = 0.0;
    int totalCount = 0;
    for (var item in _currentOrder) {
      double additionsSum = 0.0;
      for (var i = 0; i < item.additions.length; i++) {
        additionsSum += item.additionPrices[i];
      }
      subtotal += (item.product.price + additionsSum) * item.quantity;
      totalCount += item.quantity;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.greyBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sección izquierda interactiva para ver el desglose
          GestureDetector(
            onTap: () => _showCartSheet(context),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Total ($totalCount ${totalCount == 1 ? 'ítem' : 'ítems'})',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.textSecondary, size: 14),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'S/ ${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ver desglose',
                  style: TextStyle(
                    color: Color(0xFF00B26A),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Botón derecho: Enviar Comanda
          SizedBox(
            height: 48,
            width: 170,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentOrder.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Comanda enviada con éxito a cocina!'),
                    backgroundColor: Color(0xFF00B26A),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Naranja corporativo igual al mockup
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Enviar Comanda',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            // Recalcular los montos dinámicamente
            double subtotal = 0.0;
            int totalCount = 0;
            for (var item in _currentOrder) {
              double itemAdditionsSum = 0.0;
              for (var i = 0; i < item.additions.length; i++) {
                itemAdditionsSum += item.additionPrices[i];
              }
              subtotal += (item.product.price + itemAdditionsSum) * item.quantity;
              totalCount += item.quantity;
            }
            final discount = subtotal * 0.05; // 5% de descuento
            final igv = (subtotal - discount) * 0.07; // IGV simulado coincidente
            final total = subtotal - discount + igv;

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Tirador superior decorativo
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Cabecera del Carrito de Compras
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0xFF00B26A),
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Carrito de compras',
                              style: TextStyle(
                                color: Color(0xFF00B26A),
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  // Subcabecera: "XX Productos agregados"
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '${totalCount.toString().padLeft(2, '0')} ${totalCount == 1 ? 'Producto agregado' : 'Productos agregados'}',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Lista de items del carrito
                  Expanded(
                    child: _currentOrder.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_shopping_cart_outlined, size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                const Text('El carrito está vacío', style: TextStyle(color: AppColors.textSecondary)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _currentOrder.length,
                            separatorBuilder: (context, index) => const Divider(color: AppColors.greyBorder, height: 24),
                            itemBuilder: (context, index) {
                              final cartItem = _currentOrder[index];
                              
                              // Configurar colores de simulación de imagen según el producto
                              Color foodBgColor;
                              IconData foodIcon;
                              if (cartItem.product.name.contains('Hamburguesa')) {
                                foodBgColor = Colors.orange.shade50;
                                foodIcon = Icons.lunch_dining_rounded;
                              } else if (cartItem.product.name.contains('Inca')) {
                                foodBgColor = Colors.yellow.shade50;
                                foodIcon = Icons.local_drink_rounded;
                              } else if (cartItem.product.name.contains('Pizza')) {
                                foodBgColor = Colors.red.shade50;
                                foodIcon = Icons.local_pizza_rounded;
                              } else {
                                foodBgColor = Colors.green.shade50;
                                foodIcon = Icons.restaurant_menu_rounded;
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Imagen circular ilustrada
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: foodBgColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            foodIcon,
                                            color: foodBgColor == Colors.orange.shade50
                                                ? Colors.orange.shade700
                                                : foodBgColor == Colors.yellow.shade50
                                                    ? Colors.amber.shade700
                                                    : foodBgColor == Colors.red.shade50
                                                        ? Colors.red.shade700
                                                        : Colors.green.shade700,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      
                                      // Nombre e info del producto
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    cartItem.product.name,
                                                    style: const TextStyle(
                                                      color: AppColors.textPrimary,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'S/ ${cartItem.product.price.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            
                                            // Badge para las bebidas (ej. Helada)
                                            if (cartItem.badge != null) ...[
                                              const SizedBox(height: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF00B26A).withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  cartItem.badge!,
                                                  style: const TextStyle(
                                                    color: Color(0xFF00B26A),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            
                                            // Lista de adicionales ilustrada exactamente como en el screenshot
                                            if (cartItem.additions.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              const Text(
                                                'Adicionales',
                                                style: TextStyle(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              ...List.generate(cartItem.additions.length, (i) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 2.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        '+ (1) ${cartItem.additions[i]}',
                                                        style: TextStyle(
                                                          color: AppColors.textSecondary.withOpacity(0.8),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        'S/ ${cartItem.additionPrices[i].toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          color: AppColors.textSecondary.withOpacity(0.8),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ],
                                            const SizedBox(height: 8),
                                            
                                            // Botón Modificar Producto
                                            OutlinedButton(
                                              onPressed: () {},
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: const Color(0xFF00B26A),
                                                side: const BorderSide(color: Color(0xFF00B26A), width: 1.2),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: const Text(
                                                'Modificar producto',
                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      
                                      // Controles de cantidad en verde esmeralda y bote de basura en rojo claro
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setSheetState(() {
                                                    setState(() {
                                                      if (cartItem.quantity > 1) {
                                                        cartItem.quantity--;
                                                      } else {
                                                        _currentOrder.removeAt(index);
                                                      }
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: const Color(0xFF00B26A), width: 1.5),
                                                  ),
                                                  child: const Icon(Icons.remove, color: Color(0xFF00B26A), size: 12),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${cartItem.quantity}',
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  setSheetState(() {
                                                    setState(() {
                                                      cartItem.quantity++;
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: const Color(0xFF00B26A), width: 1.5),
                                                  ),
                                                  child: const Icon(Icons.add, color: Color(0xFF00B26A), size: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          IconButton(
                                            onPressed: () {
                                              setSheetState(() {
                                                setState(() {
                                                  _currentOrder.removeAt(index);
                                                });
                                              });
                                            },
                                            icon: const Icon(Icons.delete_outline_rounded),
                                            color: AppColors.error.withOpacity(0.6),
                                            iconSize: 22,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                  
                  // Botón Vaciar Carrito en rojo claro
                  if (_currentOrder.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () {
                        setSheetState(() {
                          setState(() {
                            _currentOrder.clear();
                          });
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_sweep_rounded, color: AppColors.error, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Vaciar carrito',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  // Sección de montos resumidos exactamente igual al screenshot
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.greyBackground.withOpacity(0.4),
                      border: const Border(top: BorderSide(color: AppColors.greyBorder, width: 1)),
                    ),
                    padding: const EdgeInsets.all(24).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'S/ ${subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Descuento',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '-S/ ${discount.toStringAsFixed(2)} (-5%)',
                              style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '+ IGV',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'S/ ${igv.toStringAsFixed(2)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.greyBorder, height: 1, thickness: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL A PAGAR',
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'S/ ${total.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFF00B26A), fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Botón Enviar Comanda final
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _currentOrder.isEmpty ? null : () {
                              Navigator.pop(context);
                              setState(() {
                                _currentOrder.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('¡Comanda enviada con éxito a cocina!'),
                                  backgroundColor: Color(0xFF00B26A),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B26A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text(
                              'Enviar Comanda',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

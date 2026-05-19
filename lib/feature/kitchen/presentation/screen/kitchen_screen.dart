import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/kitchen/domain/model/order_model.dart';
import 'package:restifyapp/feature/order/domain/model/product_model.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<OrderModel> _activeOrders;

  // Temporizador para actualizar la UI en tiempo real (tiempos transcurridos)
  Timer? _realTimeTimer;

  // Estado del checklist de ítems individuales: clave es 'orderId_productId'
  final Map<String, bool> _completedItems = {};

  // Estado de los filtros
  String _selectedStatusFilter =
      'Todos'; // 'Todos', 'Pendientes', 'Preparando', 'Urgentes'
  String _selectedCategoryFilter =
      'Todos'; // 'Todos', 'Entrada', 'Fondo', 'Bebida'

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();

    // Inicialización con datos de prueba realistas
    _activeOrders = [
      OrderModel(
        id: '101',
        tableName: 'Mesa 2',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        status: OrderStatus.preparing,
        items: [
          OrderItemModel(
            product: ProductModel(
              id: '3',
              name: 'Lomo Saltado',
              price: 45,
              category: 'Fondo',
              description: '',
            ),
            quantity: 2,
          ),
          OrderItemModel(
            product: ProductModel(
              id: '6',
              name: 'Chicha Morada Jarra',
              price: 15,
              category: 'Bebida',
              description: '',
            ),
            quantity: 1,
          ),
        ],
      ),
      OrderModel(
        id: '102',
        tableName: 'Mesa 6',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        status: OrderStatus.pending,
        items: [
          OrderItemModel(
            product: ProductModel(
              id: '2',
              name: 'Ceviche Clásico',
              price: 35,
              category: 'Entrada',
              description: '',
            ),
            quantity: 1,
            notes: 'Sin mucho picante',
          ),
          OrderItemModel(
            product: ProductModel(
              id: '5',
              name: 'Arroz con Mariscos',
              price: 48,
              category: 'Fondo',
              description: '',
            ),
            quantity: 1,
          ),
        ],
      ),
      OrderModel(
        id: '103',
        tableName: 'Mesa 9',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        status: OrderStatus.pending,
        items: [
          OrderItemModel(
            product: ProductModel(
              id: '1',
              name: 'Tequeños con Guacamole',
              price: 12,
              category: 'Entrada',
              description: '',
            ),
            quantity: 3,
          ),
        ],
      ),
    ];

    // Iniciar temporizador que se actualiza cada 30 segundos para incrementar los cronómetros
    _realTimeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _realTimeTimer?.cancel();
    super.dispose();
  }

  // Generador de simulaciones de comandas nuevas
  void _simulateNewOrder() {
    final random = Random();
    final tableNum = random.nextInt(15) + 1;
    final orderId = (104 + _activeOrders.length + random.nextInt(100))
        .toString();

    final sampleProducts = [
      ProductModel(
        id: '1',
        name: 'Tequeños con Guacamole',
        price: 12,
        category: 'Entrada',
        description: '',
      ),
      ProductModel(
        id: '2',
        name: 'Ceviche Clásico',
        price: 35,
        category: 'Entrada',
        description: '',
      ),
      ProductModel(
        id: '3',
        name: 'Lomo Saltado',
        price: 45,
        category: 'Fondo',
        description: '',
      ),
      ProductModel(
        id: '4',
        name: 'Ají de Gallina',
        price: 38,
        category: 'Fondo',
        description: '',
      ),
      ProductModel(
        id: '5',
        name: 'Arroz con Mariscos',
        price: 48,
        category: 'Fondo',
        description: '',
      ),
      ProductModel(
        id: '6',
        name: 'Chicha Morada Jarra',
        price: 15,
        category: 'Bebida',
        description: '',
      ),
      ProductModel(
        id: '7',
        name: 'Pisco Sour',
        price: 22,
        category: 'Bebida',
        description: '',
      ),
      ProductModel(
        id: '8',
        name: 'Suspiro a la Limeña',
        price: 14,
        category: 'Postre',
        description: '',
      ),
    ];

    final notesOptions = [
      'Sin cebolla por favor',
      'Bien cocido el lomo',
      'Extra limón en salsa',
      'Hielo aparte para bebida',
      'Sin picante',
      '',
    ];

    // Crear de 1 a 3 ítems aleatorios
    final numItems = random.nextInt(3) + 1;
    final List<OrderItemModel> items = [];

    for (int i = 0; i < numItems; i++) {
      final product = sampleProducts[random.nextInt(sampleProducts.length)];
      final quantity = random.nextInt(3) + 1;
      final notes = random.nextDouble() > 0.6
          ? notesOptions[random.nextInt(notesOptions.length)]
          : '';

      // Evitar duplicar producto en el mismo pedido de simulación
      if (!items.any((item) => item.product.id == product.id)) {
        items.add(
          OrderItemModel(product: product, quantity: quantity, notes: notes),
        );
      }
    }

    final newOrder = OrderModel(
      id: orderId,
      tableName: 'Mesa $tableNum',
      timestamp: DateTime.now(),
      status: OrderStatus.pending,
      items: items,
    );

    setState(() {
      _activeOrders.insert(0, newOrder);
    });

    // Animación corta
    _animationController.reset();
    _animationController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'NUEVA COMANDA EN ENTRADA: Mesa $tableNum con ${items.length} item(s)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Filtrado reactivo de comandas
  List<OrderModel> get _filteredOrders {
    return _activeOrders.where((order) {
      final minutesAgo = DateTime.now().difference(order.timestamp).inMinutes;

      // 1. Filtrar por estado
      if (_selectedStatusFilter == 'Pendientes' &&
          order.status != OrderStatus.pending) {
        return false;
      }
      if (_selectedStatusFilter == 'Preparando' &&
          order.status != OrderStatus.preparing) {
        return false;
      }
      if (_selectedStatusFilter == 'Urgentes' && minutesAgo <= 10) {
        return false;
      }

      // 2. Filtrar por categorías de plato dentro de la comanda
      if (_selectedCategoryFilter != 'Todos') {
        final hasCategoryItem = order.items.any(
          (item) =>
              item.product.category.toLowerCase() ==
              _selectedCategoryFilter.toLowerCase(),
        );
        if (!hasCategoryItem) return false;
      }

      return true;
    }).toList();
  }

  // Contadores para el panel superior
  int get _countTotal => _activeOrders.length;
  int get _countPending =>
      _activeOrders.where((o) => o.status == OrderStatus.pending).length;
  int get _countPreparing =>
      _activeOrders.where((o) => o.status == OrderStatus.preparing).length;

  int get _countUrgent {
    return _activeOrders.where((o) {
      final mins = DateTime.now().difference(o.timestamp).inMinutes;
      return mins > 10;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1300
        ? 3
        : screenWidth > 750
        ? 2
        : 1;

    final filteredList = _filteredOrders;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyText.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              border: const Border(
                bottom: BorderSide(color: AppColors.greyBorder, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu_rounded,
                            color: AppColors.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'MONITOR DE COCINA',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'Gestión de Comandas en Tiempo Real',
                              style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Acciones en la cabecera
                    Row(
                      children: [
                        // Botón simulador de comandas premium
                        ElevatedButton.icon(
                          onPressed: _simulateNewOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_alert_rounded, size: 20),
                          label: const Text(
                            '+ PEDIDO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // 1. Panel de Métricas de Cocina
            _buildStatsDashboard(),

            // 2. Barra de Filtros interactiva
            _buildFiltersBar(),

            // 3. Grid de comandas
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final order = filteredList[index];
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: Tween<double>(begin: 0.95, end: 1.0)
                                  .animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                        (index * 0.08).clamp(0.0, 1.0),
                                        ((index + 1) * 0.08).clamp(0.0, 1.0),
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  )
                                  .value,
                              child: child,
                            );
                          },
                          child: _buildOrderCard(order),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Panel con Métricas Reales en vivo
  Widget _buildStatsDashboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: Colors.black), // O tu configuración de Border
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          return GridView.count(
            crossAxisCount: isSmall ? 2 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
            childAspectRatio: isSmall ? 2.2 : 3.8,
            children: [
              _buildStatCard(
                'Total Activas',
                '$_countTotal',
                Icons.assignment_rounded,
                AppColors.primary,
              ),
              _buildStatCard(
                'En Espera',
                '$_countPending',
                Icons.hourglass_empty_rounded,
                AppColors.greyMedium,
              ),
              _buildStatCard(
                'Preparando',
                '$_countPreparing',
                Icons.local_fire_department_rounded,
                AppColors.statBlue,
              ),
              _buildStatCard(
                'Urgentes',
                '$_countUrgent',
                Icons.timer_3_rounded,
                AppColors.error,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Barra Superior de Filtros
  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Filtros de Estado
            const Text(
              'Estado:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            _buildFilterChip('Todos', _selectedStatusFilter, (val) {
              setState(() => _selectedStatusFilter = val);
            }),
            _buildFilterChip('Pendientes', _selectedStatusFilter, (val) {
              setState(() => _selectedStatusFilter = val);
            }),
            _buildFilterChip('Preparando', _selectedStatusFilter, (val) {
              setState(() => _selectedStatusFilter = val);
            }),
            _buildFilterChip('Urgentes', _selectedStatusFilter, (val) {
              setState(() => _selectedStatusFilter = val);
            }),

            const SizedBox(width: 24),
            Container(height: 20, width: 1, color: AppColors.greyBorder),
            const SizedBox(width: 24),

            // Filtros de Categorías
            const Text(
              'Categoría:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            _buildFilterChip('Todos', _selectedCategoryFilter, (val) {
              setState(() => _selectedCategoryFilter = val);
            }, isCategory: true),
            _buildFilterChip('Entrada', _selectedCategoryFilter, (val) {
              setState(() => _selectedCategoryFilter = val);
            }, isCategory: true),
            _buildFilterChip('Fondo', _selectedCategoryFilter, (val) {
              setState(() => _selectedCategoryFilter = val);
            }, isCategory: true),
            _buildFilterChip('Bebida', _selectedCategoryFilter, (val) {
              setState(() => _selectedCategoryFilter = val);
            }, isCategory: true),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String currentValue,
    Function(String) onSelected, {
    bool isCategory = false,
  }) {
    final isSelected = currentValue == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.greyText,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) onSelected(label);
        },
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.greyLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.greyBorder,
            width: 1,
          ),
        ),
        elevation: 0,
        pressElevation: 2,
        checkmarkColor: Colors.white,
        showCheckmark: false,
      ),
    );
  }

  // Tarjeta de Comanda
  Widget _buildOrderCard(OrderModel order) {
    final minutesAgo = DateTime.now().difference(order.timestamp).inMinutes;

    // Configuración visual basada en el estado e inactividad
    final isUrgent = minutesAgo > 10;

    Color indicatorColor;
    String statusLabel;

    if (isUrgent) {
      indicatorColor = AppColors.error;
      statusLabel = 'URGENTE';
    } else if (order.status == OrderStatus.preparing) {
      indicatorColor = AppColors.statBlue;
      statusLabel = 'EN PREPARACIÓN';
    } else {
      indicatorColor = AppColors.primary;
      statusLabel = 'PENDIENTE';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent
              ? AppColors.error.withOpacity(0.5)
              : AppColors.greyBorder,
          width: isUrgent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isUrgent
                ? AppColors.error.withOpacity(0.05)
                : AppColors.greyText.withOpacity(0.04),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la Comanda
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUrgent
                  ? AppColors.error.withOpacity(0.04)
                  : AppColors.greyLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: const Border(
                bottom: BorderSide(color: AppColors.greyBorder, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.tableName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: indicatorColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: indicatorColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                // Cronómetro Transcurrido
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isUrgent ? AppColors.error : AppColors.greyBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 14,
                        color: isUrgent ? Colors.white : AppColors.greyText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$minutesAgo min',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isUrgent
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Listado de Ítems
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return _buildItemRow(order.id, item);
              },
            ),
          ),

          // Botón de Workflow Dinámico (Dos pasos)
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildWorkflowButton(order),
          ),
        ],
      ),
    );
  }

  // Ítem de Comanda con Checklist Interactivo
  Widget _buildItemRow(String orderId, OrderItemModel item) {
    final itemKey = '${orderId}_${item.product.id}';
    final isCompleted = _completedItems[itemKey] ?? false;

    // Colores basados en la categoría del producto
    Color categoryColor;
    if (item.product.category.toLowerCase() == 'entrada') {
      categoryColor = AppColors.categoryEntrada;
    } else if (item.product.category.toLowerCase() == 'bebida') {
      categoryColor = AppColors.categoryBebida;
    } else {
      categoryColor = AppColors.primary;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _completedItems[itemKey] = !isCompleted;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.greyLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted ? AppColors.greyBorder : AppColors.greyBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cantidad estilizada
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.greyMedium.withOpacity(0.15)
                        : categoryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.quantity}x',
                    style: TextStyle(
                      color: isCompleted ? AppColors.greyMedium : categoryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Nombre del producto y categoría
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? AppColors.greyMedium
                              : AppColors.textPrimary,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.product.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isCompleted
                              ? AppColors.greyMedium
                              : categoryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icono interactivo de checklist
                AnimatedCrossFade(
                  firstChild: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 24,
                  ),
                  secondChild: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.greyBorder, width: 2),
                    ),
                  ),
                  crossFadeState: isCompleted
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
            // Notas de cocina de la comanda
            if (item.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: AppColors.orangeAlert,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.notes,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.orangeAlert,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Botón Dinámico de Workflow según estado actual de comanda
  Widget _buildWorkflowButton(OrderModel order) {
    if (order.status == OrderStatus.pending) {
      // Estado Pendiente: Iniciar Preparación (Naranja bordeado/limpio)
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () {
            setState(() {
              // Buscar y actualizar el estado
              final index = _activeOrders.indexWhere((o) => o.id == order.id);
              if (index != -1) {
                _activeOrders[index] = OrderModel(
                  id: order.id,
                  tableName: order.tableName,
                  items: order.items,
                  timestamp: order.timestamp,
                  status: OrderStatus.preparing,
                );
              }
            });
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 2),
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
          label: const Text(
            'INICIAR PREPARACIÓN',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else {
      // Estado En Preparación: Marcar como listo (Naranja corporativo premium)
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () {
            _showCompleteDialog(order);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
          label: const Text(
            'MARCAR COMO LISTO',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }
  }

  // Diálogo de Completado Moderno y Estilizado
  void _showCompleteDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '¿Confirmar Despacho?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Estás por marcar la ${order.tableName} (${order.items.length} plato(s)) como finalizada. Se enviará a la estación de despacho.',
            style: const TextStyle(
              color: AppColors.greyText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  color: AppColors.greyText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _activeOrders.removeWhere((o) => o.id == order.id);
                  // Limpiar los estados del checklist para este pedido
                  _completedItems.removeWhere(
                    (key, val) => key.startsWith('${order.id}_'),
                  );
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${order.tableName} despachada con éxito',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'DESPACHAR',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  // Estado Vacío cuando no hay pedidos coincidentes
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 72,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¡Todo al día en Cocina!',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay pedidos pendientes que coincidan con los filtros.',
            style: TextStyle(
              color: AppColors.greyText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

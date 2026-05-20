import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/order/presentation/screen/order_taking_screen.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen>
    with SingleTickerProviderStateMixin {
  TableStatus? _selectedFilter;
  String _selectedZone = 'Todos';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Datos de prueba simulando las mesas del restaurante asignadas a diferentes zonas
  final List<TableModel> _mockTables = [
    TableModel(
      id: '1',
      name: 'Mesa 01',
      capacity: 4,
      status: TableStatus.available,
      zone: 'Salón Central',
    ),
    TableModel(
      id: '2',
      name: 'Mesa 02',
      capacity: 2,
      status: TableStatus.occupied,
      zone: 'Salón Central',
    ),
    TableModel(
      id: '3',
      name: 'Mesa 03',
      capacity: 4,
      status: TableStatus.reserved,
      zone: 'Zona VIP',
    ),
    TableModel(
      id: '4',
      name: 'Mesa 04',
      capacity: 6,
      status: TableStatus.available,
      zone: 'Salón Central',
    ),
    TableModel(
      id: '5',
      name: 'Mesa 05',
      capacity: 2,
      status: TableStatus.cleaning,
      zone: 'Terraza',
    ),
    TableModel(
      id: '6',
      name: 'Mesa 06',
      capacity: 4,
      status: TableStatus.occupied,
      zone: 'Terraza',
    ),
    TableModel(
      id: '7',
      name: 'Mesa 07',
      capacity: 8,
      status: TableStatus.available,
      zone: 'Zona VIP',
    ),
    TableModel(
      id: '8',
      name: 'Mesa 08',
      capacity: 4,
      status: TableStatus.available,
      zone: 'Salón Central',
    ),
    TableModel(
      id: '9',
      name: 'Mesa 09',
      capacity: 2,
      status: TableStatus.occupied,
      zone: 'Barra',
    ),
    TableModel(
      id: '10',
      name: 'Mesa 10',
      capacity: 4,
      status: TableStatus.reserved,
      zone: 'Barra',
    ),
    TableModel(
      id: '11',
      name: 'Mesa 11',
      capacity: 6,
      status: TableStatus.available,
      zone: 'Terraza',
    ),
    TableModel(
      id: '12',
      name: 'Mesa 12',
      capacity: 2,
      status: TableStatus.cleaning,
      zone: 'Zona VIP',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  int _getCountByStatus(TableStatus? status) {
    // Si hay una zona seleccionada que no sea 'Todos', primero filtramos por zona
    final zoneTables = _selectedZone == 'Todos'
        ? _mockTables
        : _mockTables.where((t) => t.zone == _selectedZone).toList();

    if (status == null) return zoneTables.length;
    return zoneTables.where((t) => t.status == status).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    final zoneFiltered = _selectedZone == 'Todos'
        ? _mockTables
        : _mockTables.where((t) => t.zone == _selectedZone).toList();

    final filteredTables = _selectedFilter == null
        ? zoneFiltered
        : zoneFiltered.where((t) => t.status == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Salón Principal',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Monitoreo visual y asignación de mesas',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.sync_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              tooltip: 'Sincronizar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Estado de mesas actualizado'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsRow(),
          _buildZoneSelector(),
          const Divider(color: AppColors.greyBorder, height: 1),
          Expanded(
            child: filteredTables.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              2, // 2 mesas por fila para un diseño premium
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: filteredTables.length,
                    itemBuilder: (context, index) {
                      final table = filteredTables[index];
                      return _buildTableCard(table);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_bar_rounded,
            size: 64,
            color: AppColors.greyMedium.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay mesas en este estado o zona',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Dashboard de estadísticas flotante
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildStatCard(
              null,
              'Todas',
              Colors.blueGrey,
              Icons.grid_view_rounded,
            ),
            _buildStatCard(
              TableStatus.available,
              'Libres',
              AppColors.success,
              Icons.check_circle_rounded,
            ),
            _buildStatCard(
              TableStatus.occupied,
              'Ocupadas',
              AppColors.error,
              Icons.restaurant_rounded,
            ),
            _buildStatCard(
              TableStatus.reserved,
              'Reservadas',
              Colors.blue,
              Icons.bookmark_rounded,
            ),
            _buildStatCard(
              TableStatus.cleaning,
              'Limpieza',
              Colors.orange,
              Icons.cleaning_services_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    TableStatus? status,
    String label,
    Color color,
    IconData icon,
  ) {
    final isSelected = _selectedFilter == status;
    final count = _getCountByStatus(status);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = status;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.greyBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? color : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Selector Premium de Zonas
  Widget _buildZoneSelector() {
    final zones = ['Todos', 'Salón Central', 'Terraza', 'Zona VIP', 'Barra'];

    return Container(
      height: 48,
      color: AppColors.surface,
      padding: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          final isSelected = _selectedZone == zone;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(zone),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedZone = zone;
                  });
                }
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.greyBackground,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 12,
              ),
              elevation: isSelected ? 3 : 0,
              pressElevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Tarjeta de Mesa Premium
  Widget _buildTableCard(TableModel table) {
    Color statusColor;
    IconData statusIcon;
    String statusLabel;
    bool shouldPulse = false;

    switch (table.status) {
      case TableStatus.available:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_outline_rounded;
        statusLabel = 'Libre';
        break;
      case TableStatus.occupied:
        statusColor = AppColors.error;
        statusIcon = Icons.restaurant_rounded;
        statusLabel = 'Ocupada';
        shouldPulse = true;
        break;
      case TableStatus.reserved:
        statusColor = Colors.blue;
        statusIcon = Icons.bookmark_rounded;
        statusLabel = 'Reservada';
        break;
      case TableStatus.cleaning:
        statusColor = Colors.orange;
        statusIcon = Icons.cleaning_services_rounded;
        statusLabel = 'Limpieza';
        shouldPulse = true;
        break;
    }

    Widget cardContent = Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withOpacity(0.18), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fila Superior: Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.airline_seat_recline_normal_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${table.capacity}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Centro: Mesa
            _buildVisualTable(table, statusColor),

            // Fila Inferior: Info de estado
            _buildCardFooter(table, statusColor),
          ],
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final scale = shouldPulse ? _pulseAnimation.value : 1.0;
        return Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTakingScreen(table: table),
                  ),
                );
              },
              onLongPress: () => _showQuickActionsBottomSheet(table),
              borderRadius: BorderRadius.circular(24),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: cardContent,
            ),
          ),
        );
      },
    );
  }

  // Representación visual premium de la mesa con sillas
  Widget _buildVisualTable(TableModel table, Color statusColor) {
    final double tableSize = table.capacity > 4 ? 70.0 : 60.0;
    final isRound = table.capacity <= 4;

    List<Widget> seats = [];
    final seatColor = statusColor.withOpacity(0.7);

    Widget seatDot() => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: seatColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );

    if (table.capacity == 2) {
      seats.add(
        Positioned(left: 6, top: 0, bottom: 0, child: Center(child: seatDot())),
      );
      seats.add(
        Positioned(
          right: 6,
          top: 0,
          bottom: 0,
          child: Center(child: seatDot()),
        ),
      );
    } else if (table.capacity == 4) {
      seats.add(
        Positioned(top: 6, left: 0, right: 0, child: Center(child: seatDot())),
      );
      seats.add(
        Positioned(
          bottom: 6,
          left: 0,
          right: 0,
          child: Center(child: seatDot()),
        ),
      );
      seats.add(
        Positioned(left: 6, top: 0, bottom: 0, child: Center(child: seatDot())),
      );
      seats.add(
        Positioned(
          right: 6,
          top: 0,
          bottom: 0,
          child: Center(child: seatDot()),
        ),
      );
    } else {
      int sideCount = table.capacity ~/ 2;
      seats.add(
        Positioned(
          top: 4,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(sideCount, (_) => seatDot()),
          ),
        ),
      );
      seats.add(
        Positioned(
          bottom: 4,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(sideCount, (_) => seatDot()),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...seats,
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: table.capacity > 4 ? 90.0 : tableSize,
            height: tableSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor, statusColor.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: isRound ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isRound ? null : BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.15,
                  child: Icon(
                    table.status == TableStatus.occupied
                        ? Icons.restaurant_rounded
                        : Icons.flatware_rounded,
                    color: Colors.white,
                    size: tableSize * 0.45,
                  ),
                ),
                Text(
                  table.name.replaceAll('Mesa ', 'M'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Footer dinámico de tarjeta
  Widget _buildCardFooter(TableModel table, Color statusColor) {
    switch (table.status) {
      case TableStatus.occupied:
        return Column(
          children: [
            const Divider(color: AppColors.greyBorder, height: 1),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on_rounded,
                  size: 12,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Consumo: S/ 85.00',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        );
      case TableStatus.reserved:
        return const Column(
          children: [
            Divider(color: AppColors.greyBorder, height: 1),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded, size: 12, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  'Reserva: 8:30 PM',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        );
      case TableStatus.cleaning:
        return const Column(
          children: [
            Divider(color: AppColors.greyBorder, height: 1),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Acondicionando...',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        );
      case TableStatus.available:
        return const Column(
          children: [
            Divider(color: AppColors.greyBorder, height: 1),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4),
                Text(
                  'Toca para comanda',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  // Panel de acciones rápidas al sostener una mesa
  void _showQuickActionsBottomSheet(TableModel table) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            table.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Zona: ${table.zone}  •  Capacidad: ${table.capacity} personas',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greyBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.lock_clock,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Acciones rápidas',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.greyBorder),
                  const SizedBox(height: 16),
                  const Text(
                    'CAMBIAR ESTADO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStateButton(
                        table,
                        TableStatus.available,
                        'Libre',
                        AppColors.success,
                      ),
                      _buildStateButton(
                        table,
                        TableStatus.occupied,
                        'Ocupar',
                        AppColors.error,
                      ),
                      _buildStateButton(
                        table,
                        TableStatus.reserved,
                        'Reservar',
                        Colors.blue,
                      ),
                      _buildStateButton(
                        table,
                        TableStatus.cleaning,
                        'Limpieza',
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Acción principal
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderTakingScreen(table: table),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded),
                      label: const Text(
                        'Abrir Comanda / Pedido',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStateButton(
    TableModel table,
    TableStatus targetStatus,
    String label,
    Color color,
  ) {
    final isCurrent = table.status == targetStatus;
    return InkWell(
      onTap: () {
        setState(() {
          final idx = _mockTables.indexWhere((t) => t.id == table.id);
          if (idx != -1) {
            _mockTables[idx] = TableModel(
              id: table.id,
              name: table.name,
              capacity: table.capacity,
              status: targetStatus,
              zone: table.zone,
            );
          }
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${table.name} cambiada a $label'),
            backgroundColor: color,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isCurrent ? color.withOpacity(0.12) : AppColors.greyBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                color: isCurrent ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

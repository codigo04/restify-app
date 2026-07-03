import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/auth/domain/model/user.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';
import 'package:restifyapp/feature/order/presentation/provider/pedido_provider.dart';

const _estadosActivos = {'PENDIENTE', 'EN_PROCESO'};

class DashboardScreen extends StatefulWidget {
  final User user;
  final UserRole role;
  final Function(int) onTabChange;

  const DashboardScreen({
    super.key,
    required this.user,
    required this.role,
    required this.onTabChange,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.role == UserRole.waiter) {
        context.read<PedidoProvider>().loadMisPedidos(widget.user.id);
      } else if (widget.role == UserRole.kitchen) {
        context.read<PedidoProvider>().loadPedidosCocina();
      }
    });
  }

  String _getRoleName() {
    switch (widget.role) {
      case UserRole.waiter:
        return 'Mesero';
      case UserRole.kitchen:
        return 'Jefe de Cocina';
      case UserRole.SUPER_ADMIN:
        return 'Administrador';
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '¡Buenos días!';
    } else if (hour < 19) {
      return '¡Buenas tardes!';
    } else {
      return '¡Buenas noches!';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final days = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
    ];
    return '${days[now.weekday % 7]}, ${now.day} de ${months[now.month - 1]}';
  }

  String _getUserGreetingName() {
    final email = widget.user.email;
    final atIndex = email.indexOf('@');
    return atIndex > 0 ? email.substring(0, atIndex) : email;
  }

  int _getProfileIndex() {
    switch (widget.role) {
      case UserRole.waiter:
        return 3;
      case UserRole.kitchen:
        return 3;
      case UserRole.SUPER_ADMIN:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.role == UserRole.waiter ||
                      widget.role == UserRole.kitchen) ...[
                    _buildMetricsSection(),
                    const SizedBox(height: 24),
                  ],
                  _buildQuickActionsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header estilizado con degradado y tarjeta de perfil
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, ${_getUserGreetingName()}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getGreeting(),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icono circular o avatar de perfil a un costado de forma elegante
                  InkWell(
                    onTap: () => widget.onTabChange(_getProfileIndex()),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.role == UserRole.SUPER_ADMIN
                            ? Icons.admin_panel_settings_rounded
                            : widget.role == UserRole.kitchen
                            ? Icons.soup_kitchen_rounded
                            : Icons.person_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.greyBorder, height: 1),
              const SizedBox(height: 16),
              // Pequeño renglón informativo con la fecha y el rol
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getRoleName(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _getFormattedDate(),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métricas reales del día, calculadas a partir de los pedidos del backend.
  Widget _buildMetricsSection() {
    return Consumer<PedidoProvider>(
      builder: (context, provider, _) {
        final isWaiter = widget.role == UserRole.waiter;
        final isLoading = isWaiter
            ? provider.isLoadingMisPedidos
            : provider.isLoadingCocina;

        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final metrics = isWaiter
            ? _buildWaiterMetrics(provider)
            : _buildKitchenMetrics(provider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RESUMEN DE HOY',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: metrics
                  .map(
                    (m) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _MetricCard(metric: m),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  List<_Metric> _buildWaiterMetrics(PedidoProvider provider) {
    final today = DateTime.now();
    final pedidosHoy = provider.misPedidos.where((p) {
      final fecha = p.fechaPedido;
      return fecha != null &&
          fecha.year == today.year &&
          fecha.month == today.month &&
          fecha.day == today.day;
    }).toList();

    final mesasHoy = pedidosHoy.map((p) => p.mesaId).whereType<int>().toSet();
    final ventasHoy = pedidosHoy
        .where((p) => (p.estado ?? '').toUpperCase() == 'PAGADO')
        .fold<double>(0, (sum, p) => sum + p.total);
    final pedidosActivos = pedidosHoy
        .where((p) => _estadosActivos.contains((p.estado ?? '').toUpperCase()))
        .length;

    return [
      _Metric(
        label: 'Mesas hoy',
        value: '${mesasHoy.length}',
        icon: Icons.table_bar_rounded,
        color: AppColors.primary,
      ),
      _Metric(
        label: 'Ventas cobradas',
        value: 'S/ ${ventasHoy.toStringAsFixed(2)}',
        icon: Icons.monetization_on_rounded,
        color: AppColors.success,
      ),
      _Metric(
        label: 'Pedidos activos',
        value: '$pedidosActivos',
        icon: Icons.receipt_long_rounded,
        color: Colors.blueAccent,
      ),
    ];
  }

  List<_Metric> _buildKitchenMetrics(PedidoProvider provider) {
    final pedidos = provider.pedidosCocina;
    final pendientes = pedidos
        .where((p) => (p.estado ?? '').toUpperCase() == 'PENDIENTE')
        .length;
    final enProceso = pedidos
        .where((p) => (p.estado ?? '').toUpperCase() == 'EN_PROCESO')
        .length;

    return [
      _Metric(
        label: 'Pendientes',
        value: '$pendientes',
        icon: Icons.hourglass_empty_rounded,
        color: Colors.orange,
      ),
      _Metric(
        label: 'En preparación',
        value: '$enProceso',
        icon: Icons.soup_kitchen_rounded,
        color: AppColors.primary,
      ),
      _Metric(
        label: 'Total en cola',
        value: '${pedidos.length}',
        icon: Icons.receipt_long_rounded,
        color: AppColors.success,
      ),
    ];
  }

  // Acciones Rápidas con callback interactivo para cambiar de tabs
  Widget _buildQuickActionsSection() {
    List<Map<String, dynamic>> actions = [];

    if (widget.role == UserRole.waiter) {
      actions = [
        {
          'title': 'Ver Mesas',
          'subtitle': 'Gestionar salón principal',
          'icon': Icons.table_bar_rounded,
          'color': AppColors.primary,
          'tabIndex': 1,
        },
        {
          'title': 'Mis Pedidos',
          'subtitle': 'Historial y estados',
          'icon': Icons.history_edu_rounded,
          'color': AppColors.secondary,
          'tabIndex': 2,
        },
        {
          'title': 'Ver Mi Perfil',
          'subtitle': 'Configuración y datos',
          'icon': Icons.account_circle_outlined,
          'color': Colors.blueGrey,
          'tabIndex': 3,
        },
      ];
    } else if (widget.role == UserRole.kitchen) {
      actions = [
        {
          'title': 'Monitor Cocina',
          'subtitle': 'Ver comandas entrantes',
          'icon': Icons.soup_kitchen_rounded,
          'color': AppColors.primary,
          'tabIndex': 1,
        },
        {
          'title': 'Historial KDS',
          'subtitle': 'Platos servidos hoy',
          'icon': Icons.checklist_rounded,
          'color': Colors.orange,
          'tabIndex': 2,
        },
        {
          'title': 'Inventario',
          'subtitle': 'Stock de ingredientes',
          'icon': Icons.inventory_2_outlined,
          'color': Colors.brown,
          'tabIndex': 3,
        },
      ];
    } else {
      // Admin
      actions = [
        {
          'title': 'Mesa & Salón',
          'subtitle': 'Ver estado de salón',
          'icon': Icons.table_restaurant_rounded,
          'color': AppColors.primary,
          'tabIndex': 1,
        },
        {
          'title': 'Cocina KDS',
          'subtitle': 'Monitor en vivo',
          'icon': Icons.kitchen_rounded,
          'color': AppColors.secondary,
          'tabIndex': 2,
        },
        {
          'title': 'Pedidos por Cobrar',
          'subtitle': 'Registrar pagos',
          'icon': Icons.payments_rounded,
          'color': AppColors.success,
          'tabIndex': 3,
        },
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACCIONES RÁPIDAS',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        ...actions.map((act) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onTabChange(act['tabIndex'] as int),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (act['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          act['icon'] as IconData,
                          color: act['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              act['title'] as String,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              act['subtitle'] as String,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.greyMedium,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _Metric {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _Metric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _MetricCard extends StatelessWidget {
  final _Metric metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: metric.color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(metric.icon, color: metric.color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

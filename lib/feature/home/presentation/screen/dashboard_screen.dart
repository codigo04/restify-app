import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';

class DashboardScreen extends StatelessWidget {
  final UserRole role;
  final Function(int) onTabChange;

  const DashboardScreen({
    super.key,
    required this.role,
    required this.onTabChange,
  });

  String _getRoleName() {
    switch (role) {
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
    switch (role) {
      case UserRole.waiter:
        return 'Salomón';
      case UserRole.kitchen:
        return 'Chef Gustavo';
      case UserRole.SUPER_ADMIN:
        return 'Administrador';
    }
  }

  int _getProfileIndex() {
    switch (role) {
      case UserRole.waiter:
        return 3;
      case UserRole.kitchen:
        return 4;
      case UserRole.SUPER_ADMIN:
        return 5;
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
                children: [_buildQuickActionsSection()],
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${_getUserGreetingName()}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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
                  // Icono circular o avatar de perfil a un costado de forma elegante
                  InkWell(
                    onTap: () => onTabChange(_getProfileIndex()),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        role == UserRole.SUPER_ADMIN
                            ? Icons.admin_panel_settings_rounded
                            : role == UserRole.kitchen
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

  // Acciones Rápidas con callback interactivo para cambiar de tabs
  Widget _buildQuickActionsSection() {
    List<Map<String, dynamic>> actions = [];

    if (role == UserRole.waiter) {
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
    } else if (role == UserRole.kitchen) {
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
                onTap: () => onTabChange(act['tabIndex'] as int),
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

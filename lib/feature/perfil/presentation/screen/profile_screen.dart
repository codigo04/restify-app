import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';
import 'package:restifyapp/feature/auth/presentation/screen/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserRole role;

  const ProfileScreen({super.key, required this.role});

  String _getUserName() {
    switch (role) {
      case UserRole.waiter:
        return 'Salomón Guerrero';
      case UserRole.kitchen:
        return 'Chef Gustavo Olivera';
      case UserRole.SUPER_ADMIN:
        return 'Administrador Principal';
    }
  }

  String _getUserEmail() {
    switch (role) {
      case UserRole.waiter:
        return 'salomon.mesero@restify.com';
      case UserRole.kitchen:
        return 'gustavo.cocina@restify.com';
      case UserRole.SUPER_ADMIN:
        return 'admin@restify.com';
    }
  }

  String _getRoleName() {
    switch (role) {
      case UserRole.waiter:
        return 'Mesero Profesional';
      case UserRole.kitchen:
        return 'Jefe de Cocina / KDS';
      case UserRole.SUPER_ADMIN:
        return 'Administrador del Sistema';
    }
  }

  IconData _getRoleIcon() {
    switch (role) {
      case UserRole.waiter:
        return Icons.room_service_rounded;
      case UserRole.kitchen:
        return Icons.soup_kitchen_rounded;
      case UserRole.SUPER_ADMIN:
        return Icons.admin_panel_settings_rounded;
    }
  }

  Widget _buildRoleAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(child: Icon(_getRoleIcon(), color: Colors.white, size: 48)),
    );
  }

  List<Map<String, dynamic>> _getStats() {
    switch (role) {
      case UserRole.waiter:
        return [
          {
            'label': 'Mesas hoy',
            'value': '18',
            'icon': Icons.table_bar_rounded,
            'color': AppColors.primary,
          },
          {
            'label': 'Ventas',
            'value': 'S/ 1,420.00',
            'icon': Icons.monetization_on_rounded,
            'color': AppColors.success,
          },
          {
            'label': 'Calificación',
            'value': '4.9 ★',
            'icon': Icons.star_rate_rounded,
            'color': Colors.amber,
          },
        ];
      case UserRole.kitchen:
        return [
          {
            'label': 'Platos despachados',
            'value': '42',
            'icon': Icons.flatware_rounded,
            'color': Colors.orange,
          },
          {
            'label': 'Tiempo prom.',
            'value': '11 min',
            'icon': Icons.timer_rounded,
            'color': AppColors.secondary,
          },
          {
            'label': 'Eficiencia',
            'value': '99.2%',
            'icon': Icons.offline_bolt_rounded,
            'color': AppColors.success,
          },
        ];
      case UserRole.SUPER_ADMIN:
        return [
          {
            'label': 'Ingresos hoy',
            'value': 'S/ 8,240.00',
            'icon': Icons.payments_rounded,
            'color': AppColors.success,
          },
          {
            'label': 'Mesas ocupadas',
            'value': '8 / 12',
            'icon': Icons.grid_view_rounded,
            'color': AppColors.primary,
          },
          {
            'label': 'Personal activo',
            'value': '6',
            'icon': Icons.people_alt_rounded,
            'color': Colors.blue,
          },
        ];
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error, size: 28),
              SizedBox(width: 12),
              Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            '¿Está seguro de que desea salir del aplicativo? Deberá ingresar sus credenciales nuevamente.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada correctamente'),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Salir',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStats();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Sección Cabecera Perfil
            Center(
              child: Column(
                children: [
                  _buildRoleAvatar(),
                  const SizedBox(height: 16),
                  Text(
                    _getUserName(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getUserEmail(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Badge de Estado En Línea
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sección de Métricas / Rendimiento
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'RENDIMIENTO DE HOY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: stats.map((stat) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.greyBorder,
                        width: 1.5,
                      ),
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
                            color: (stat['color'] as Color).withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            stat['icon'] as IconData,
                            color: stat['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          stat['value'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stat['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Opciones de Configuración
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'AJUSTES DE CUENTA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.greyBorder, width: 1.5),
              ),
              child: Column(
                children: [
                  _buildOptionItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notificaciones',
                    subtitle: 'Alertas de pedidos y cocina',
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.greyBorder, height: 1),
                  _buildOptionItem(
                    icon: Icons.shield_outlined,
                    title: 'Seguridad y Privacidad',
                    subtitle: 'Cambiar contraseña y PIN',
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.greyBorder, height: 1),
                  _buildOptionItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Ayuda y Soporte',
                    subtitle: 'Preguntas frecuentes y tutoriales',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Botón de Cerrar Sesión Prominente
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withOpacity(0.08),
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(
                  'Cerrar Sesión Activa',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.secondary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.greyMedium,
        size: 22,
      ),
      onTap: onTap,
    );
  }
}

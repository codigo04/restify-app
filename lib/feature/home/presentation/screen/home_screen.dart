import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/presentation/screen/tables_screen.dart';
import 'package:restifyapp/feature/kitchen/presentation/screen/kitchen_screen.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';
import 'package:restifyapp/feature/auth/presentation/screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserRole role;

  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _buildNavigation();
  }

  void _buildNavigation() {
    if (widget.role == UserRole.waiter) {
      _screens = [
        const TablesScreen(),
        const _PlaceholderScreen(title: 'Mis Pedidos', icon: Icons.history, color: AppColors.primary),
        const _PlaceholderScreen(title: 'Perfil', icon: Icons.person_outline, color: AppColors.secondary),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), activeIcon: Icon(Icons.room_service), label: 'Mesas'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ];
    } else if (widget.role == UserRole.kitchen) {
      _screens = [
        const KitchenScreen(),
        const _PlaceholderScreen(title: 'Historial Cocina', icon: Icons.checklist, color: Colors.orange),
        const _PlaceholderScreen(title: 'Inventario', icon: Icons.inventory_2_outlined, color: Colors.brown),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.soup_kitchen_outlined), activeIcon: Icon(Icons.soup_kitchen), label: 'Cocina'),
        BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stock'),
      ];
    } else {
      // Admin o por defecto
      _screens = [
        const TablesScreen(),
        const KitchenScreen(),
        const _PlaceholderScreen(title: 'Caja (POS)', icon: Icons.point_of_sale_outlined, color: Colors.green),
        const _PlaceholderScreen(title: 'Ajustes', icon: Icons.settings_outlined, color: AppColors.secondary),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), label: 'Mesas'),
        BottomNavigationBarItem(icon: Icon(Icons.soup_kitchen_outlined), label: 'Cocina'),
        BottomNavigationBarItem(icon: Icon(Icons.point_of_sale_outlined), label: 'Caja'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
      ];
    }
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            '¿Cerrar sesión?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '¿Está seguro de que desea cerrar su sesión?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Tooltip(
                message: 'Cerrar sesión',
                child: IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  onPressed: () => _logout(context),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 8,
        items: _navItems,
      ),
    );
  }
}

// Pantalla temporal para módulos en construcción
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Módulo $title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Próximamente',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

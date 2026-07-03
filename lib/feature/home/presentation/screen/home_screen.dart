import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/presentation/screen/tables_screen.dart';
import 'package:restifyapp/feature/kitchen/presentation/screen/kitchen_screen.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';
import 'package:restifyapp/feature/home/presentation/screen/dashboard_screen.dart';
import 'package:restifyapp/feature/perfil/presentation/screen/profile_screen.dart';
import 'package:restifyapp/feature/order/presentation/screen/my_orders_screen.dart';

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
        DashboardScreen(
          role: widget.role,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const TablesScreen(),
        const MyOrdersScreen(),
        ProfileScreen(role: widget.role),
      ];
      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.room_service_outlined),
          activeIcon: Icon(Icons.room_service),
          label: 'Mesas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Pedidos'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];
    } else if (widget.role == UserRole.kitchen) {
      _screens = [
        DashboardScreen(
          role: widget.role,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const KitchenScreen(),
        const _PlaceholderScreen(
          title: 'Historial Cocina',
          icon: Icons.checklist,
          color: Colors.orange,
        ),
        const _PlaceholderScreen(
          title: 'Inventario',
          icon: Icons.inventory_2_outlined,
          color: Colors.brown,
        ),
        ProfileScreen(role: widget.role),
      ];
      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.soup_kitchen_outlined),
          activeIcon: Icon(Icons.soup_kitchen),
          label: 'Cocina',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist),
          label: 'Historial',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Stock',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];
    } else {
      // Admin o por defecto
      _screens = [
        DashboardScreen(
          role: widget.role,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const TablesScreen(),
        const KitchenScreen(),
        ProfileScreen(role: widget.role),
      ];
      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.room_service_outlined),
          label: 'Mesas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.soup_kitchen_outlined),
          label: 'Cocina',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

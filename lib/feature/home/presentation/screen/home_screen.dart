import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/tables/presentation/screen/tables_screen.dart';
import 'package:restifyapp/feature/kitchen/presentation/screen/kitchen_screen.dart';
import 'package:restifyapp/feature/kitchen/presentation/screen/kitchen_history_screen.dart';
import 'package:restifyapp/feature/auth/domain/model/user.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';
import 'package:restifyapp/feature/home/presentation/screen/dashboard_screen.dart';
import 'package:restifyapp/feature/perfil/presentation/screen/profile_screen.dart';
import 'package:restifyapp/feature/order/presentation/screen/my_orders_screen.dart';
import 'package:restifyapp/feature/order/presentation/screen/admin_billing_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final UserRole role;

  const HomeScreen({super.key, required this.user, required this.role});

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
          user: widget.user,
          role: widget.role,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const TablesScreen(),
        const MyOrdersScreen(),
        ProfileScreen(user: widget.user, role: widget.role),
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
          user: widget.user,
          role: widget.role,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const KitchenScreen(),
        const KitchenHistoryScreen(),
        ProfileScreen(user: widget.user, role: widget.role),
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
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];
    } else {
      // Admin o por defecto
      _screens = [
        DashboardScreen(
          user: widget.user,
          role: widget.role,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        const TablesScreen(),
        const KitchenScreen(),
        const AdminBillingScreen(),
        ProfileScreen(user: widget.user, role: widget.role),
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
          icon: Icon(Icons.payments_outlined),
          activeIcon: Icon(Icons.payments),
          label: 'Cobros',
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

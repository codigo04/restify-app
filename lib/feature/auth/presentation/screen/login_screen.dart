import 'package:flutter/material.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/auth/presentation/widget/custom_text_field.dart';
import 'package:restifyapp/feature/auth/presentation/widget/primary_button.dart';
import 'package:restifyapp/feature/home/presentation/screen/home_screen.dart';
import 'package:restifyapp/feature/auth/domain/model/user_role.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final user = _userController.text.trim().toLowerCase();
    final pass = _passwordController.text.trim();

    debugPrint('Intentando login con: $user');

    UserRole? selectedRole;

    if (user == 'mesero' && pass == '123456') {
      selectedRole = UserRole.waiter;
    } else if (user == 'cocina' && pass == '123456') {
      selectedRole = UserRole.kitchen;
    } else if (user == 'admin' && pass == 'admin') {
      selectedRole = UserRole.admin;
    }

    if (selectedRole != null) {
      debugPrint('Login exitoso como $user');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen(role: selectedRole!)),
      );
    } else {
      debugPrint('Credenciales incorrectas');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o contraseña incorrectos'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              // Logo o Icono de la App
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              // Título de Bienvenida
              const Text(
                'Restify',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bienvenido de nuevo a tu panel',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              // Formulario
              CustomTextField(
                label: 'Usuario o Correo',
                hint: 'ejemplo: mesero o cocina',
                icon: Icons.person_outline,
                controller: _userController,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Contraseña',
                hint: '123456',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 40),
              // Botón de Inicio de Sesión
              PrimaryButton(
                text: 'ENTRAR',
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 40),
              // Decoración o Pie de página minimalista
              const Text(
                'Gestión de Restaurante Inteligente',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

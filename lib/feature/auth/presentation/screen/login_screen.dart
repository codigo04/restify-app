import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/auth/presentation/provider/login_provider.dart';
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
    final email = _userController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    debugPrint('Intentando login con: $email');

    final provider = context.read<LoginProvider>();
    provider
        .login(email, password)
        .then((success) {
          if (success && mounted) {
            final user = provider.user;
            if (user != null) {
              debugPrint('Login exitoso como $email - Rol: ${user.rolNombre}');

              // Mapear rol del backend al enum local
              UserRole? selectedRole;
              if (user.rolNombre.toLowerCase().contains('mesero')) {
                selectedRole = UserRole.waiter;
              } else if (user.rolNombre.toLowerCase().contains('cocina')) {
                selectedRole = UserRole.kitchen;
              } else if (user.rolNombre.toLowerCase().contains('admin')) {
                selectedRole = UserRole.admin;
              }

              if (selectedRole != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(role: selectedRole!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Rol no reconocido: ${user.rolNombre}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          }
        })
        .catchError((e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.error ?? 'Error desconocido'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        });
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
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              // Error message
              Consumer<LoginProvider>(
                builder: (context, loginProvider, _) {
                  if (loginProvider.error != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: AppColors.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                loginProvider.error!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => loginProvider.clearError(),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              // Formulario
              CustomTextField(
                label: 'Usuario o Correo',
                hint: 'ejemplo@correo.com',
                icon: Icons.person_outline,
                controller: _userController,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Contraseña',
                hint: 'Tu contraseña',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 40),
              // Botón de Inicio de Sesión
              Consumer<LoginProvider>(
                builder: (context, loginProvider, _) {
                  return PrimaryButton(
                    text: loginProvider.isLoading ? 'INGRESANDO...' : 'ENTRAR',
                    onPressed: loginProvider.isLoading ? () {} : _handleLogin,
                  );
                },
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

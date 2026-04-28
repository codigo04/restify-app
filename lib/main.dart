import 'package:flutter/material.dart';
import 'package:restifyapp/feature/auth/presentation/screen/login_screen.dart';
import 'package:restifyapp/core/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        fontFamily: 'Roboto', // Puedes cambiar esto si tienes una fuente específica
      ),
      home: const LoginScreen(),
    );
  }
}

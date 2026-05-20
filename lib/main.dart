import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/feature/auth/data/repository/test3.dart';
import 'package:restifyapp/feature/auth/presentation/screen/login_screen.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/core/di/injection.dart';
import 'package:restifyapp/feature/auth/presentation/provider/login_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(repository: getIt<LoginRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Restify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

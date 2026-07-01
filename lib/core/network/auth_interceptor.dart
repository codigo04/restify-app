import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restifyapp/core/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  static const _publicPaths = ['/api/v1/auth-service/authentication/login'];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((path) => options.path.contains(path));
    options.headers.remove('Authorization');

    if (!isPublic) {
      try {
        final token = await _storage.read(key: 'token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        // Silenciar errores de lectura de storage
        // print('Error reading token from storage: $e');
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isPublic = _publicPaths.any(
      (path) => err.requestOptions.path.contains(path),
    );

    if (err.response?.statusCode == 401 && !isPublic) {
      await _forceLogout();
    }

    handler.next(err);
  }

  Future<void> _forceLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await _storage.deleteAll();
    await prefs.remove('auth_session');

    appRouter.go('/login');
  }
}

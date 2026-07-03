import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restifyapp/feature/auth/data/repository/test3.dart';
import 'package:restifyapp/feature/auth/domain/model/user.dart';

class LoginProvider extends ChangeNotifier {
  final LoginRepository repository;
  final FlutterSecureStorage _secureStorage;

  User? _user;
  bool _isLoading = false;
  String? _error;

  LoginProvider({required this.repository, FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Getters
  User? get user => _user;
  String? get token => _user?.token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// Realiza el login con email y contraseña
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await repository.login(username, password);

      // Guardar token en FlutterSecureStorage
      if (_user?.token != null && (_user?.token ?? '').isNotEmpty) {
        await _secureStorage.write(key: 'token', value: _user!.token);
      }

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _user = null;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cierra la sesión: limpia el usuario en memoria y toda la sesión persistida
  /// (token seguro + preferencias), igual que el logout forzado por 401.
  Future<void> logout() async {
    _user = null;
    _error = null;
    _isLoading = false;

    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_session');

    notifyListeners();
  }

  /// Limpia el error actual
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Parsea el error para mostrar mensaje amigable
  String _parseError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('Error de conexión')) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (errorStr.contains('401')) {
      return 'Credenciales inválidas.';
    } else if (errorStr.contains('Error en login')) {
      return 'Error al procesar la solicitud.';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }
}

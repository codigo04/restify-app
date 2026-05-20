import 'package:flutter/foundation.dart';
import 'package:restifyapp/feature/auth/data/repository/test3.dart';
import 'package:restifyapp/feature/auth/domain/model/user.dart';

class LoginProvider extends ChangeNotifier {
  final LoginRepository repository;

  User? _user;
  bool _isLoading = false;
  String? _error;

  LoginProvider({required this.repository});

  // Getters
  User? get user => _user;
  String? get token => _user?.token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// Realiza el login con email y contraseña
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await repository.login(email, password);
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

  /// Cierra la sesión
  void logout() {
    _user = null;
    _error = null;
    _isLoading = false;
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

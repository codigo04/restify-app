import 'package:flutter/foundation.dart';
import 'package:restifyapp/feature/categoria/domain/model/categoria_model.dart';
import 'package:restifyapp/feature/categoria/domain/repository/categoria_repository.dart';

class CategoriaProvider extends ChangeNotifier {
  final CategoriaRepository repository;

  List<CategoriaModel> _categorias = [];
  bool _isLoading = false;
  String? _error;

  CategoriaProvider({required this.repository});

  List<CategoriaModel> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga las categorías activas de la empresa del token
  Future<void> loadCategorias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categorias = await repository.getCategoriasActivas();
      _error = null;
    } catch (e) {
      _error = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Parsea el error para mostrar mensaje amigable
  String _parseError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('Error de conexión')) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (errorStr.contains('401')) {
      return 'Sesión expirada. Inicia sesión nuevamente.';
    }
    return 'No se pudieron cargar las categorías. Intenta de nuevo.';
  }
}

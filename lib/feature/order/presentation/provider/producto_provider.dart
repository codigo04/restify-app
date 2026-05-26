import 'package:flutter/foundation.dart';
import 'package:restifyapp/feature/order/domain/model/producto_model.dart';
import 'package:restifyapp/feature/order/domain/repository/producto_repository.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoRepository repository;

  List<ProductoModel> _productos = [];
  List<ProductoModel> _productosFiltrados = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  ProductoProvider({required this.repository});

  // Getters
  List<ProductoModel> get productos => _productos;
  List<ProductoModel> get productosFiltrados => _productosFiltrados;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Carga productos de una empresa
  Future<void> loadProductos(int idEmpresa) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await repository.getProductosByEmpresa(idEmpresa);
      _productosFiltrados = List.from(_productos);
      _error = null;
    } catch (e) {
      _error = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca productos por nombre
  void searchProductos(String query) {
    _searchQuery = query.toLowerCase();

    if (_searchQuery.isEmpty) {
      _productosFiltrados = List.from(_productos);
    } else {
      _productosFiltrados = _productos
          .where((p) => p.nombre.toLowerCase().contains(_searchQuery))
          .toList();
    }

    notifyListeners();
  }

  /// Filtra productos disponibles
  List<ProductoModel> get productosDisponibles {
    return _productosFiltrados.where((p) => p.disponible).toList();
  }

  /// Limpia el error
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
      return 'Sesión expirada. Inicia sesión nuevamente.';
    }
    return 'No se pudieron cargar los productos. Intenta de nuevo.';
  }
}

import 'package:flutter/material.dart';
import 'package:restifyapp/feature/tables/data/repository/mesa_repository.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';

class MesaProvider extends ChangeNotifier {
  final MesaRepository repository;

  List<TableModel> _mesas = [];
  bool _isLoading = false;
  String? _error;

  MesaProvider({required this.repository});

  List<TableModel> get mesas => _mesas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMesas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _mesas = await repository.getMesas();
      _error = null;
    } catch (e) {
      _error = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateTableStatus(String tableId, TableStatus newStatus) {
    final idx = _mesas.indexWhere((t) => t.id == tableId);
    if (idx != -1) {
      _mesas = List.from(_mesas);
      _mesas[idx] = TableModel(
        id: _mesas[idx].id,
        name: _mesas[idx].name,
        capacity: _mesas[idx].capacity,
        status: newStatus,
        zone: _mesas[idx].zone,
      );
      notifyListeners();
    }
  }

  /// Cambia el estado de la mesa en el backend y refleja el cambio localmente.
  Future<bool> cambiarEstado(String tableId, TableStatus newStatus) async {
    final mesaId = int.tryParse(tableId);
    if (mesaId == null) return false;

    try {
      await repository.cambiarEstado(mesaId, newStatus);
      updateTableStatus(tableId, newStatus);
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _parseError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('Error de conexión')) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (errorStr.contains('401')) {
      return 'Sesión expirada. Inicia sesión nuevamente.';
    }
    return 'No se pudieron cargar las mesas. Intenta de nuevo.';
  }
}

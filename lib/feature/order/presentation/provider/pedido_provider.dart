import 'package:flutter/foundation.dart';
import 'package:restifyapp/feature/order/data/dto/request/pedido_create_request.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';
import 'package:restifyapp/feature/order/domain/repository/pedido_repository.dart';

const _estadosCocina = {'PENDIENTE', 'EN_PROCESO'};
const _estadosHistorialCocina = {'ATENDIDO', 'PAGADO'};
const _estadosPorCobrar = {'PENDIENTE', 'EN_PROCESO', 'ATENDIDO'};

class PedidoProvider extends ChangeNotifier {
  final PedidoRepository repository;

  bool _isSending = false;
  String? _error;

  List<PedidoModel> _pedidosCocina = [];
  bool _isLoadingCocina = false;
  String? _cocinaError;

  List<PedidoModel> _misPedidos = [];
  bool _isLoadingMisPedidos = false;
  String? _misPedidosError;

  List<PedidoModel> _historialCocina = [];
  bool _isLoadingHistorialCocina = false;
  String? _historialCocinaError;

  List<PedidoModel> _pedidosPorCobrar = [];
  bool _isLoadingPorCobrar = false;
  String? _porCobrarError;

  PedidoProvider({required this.repository});

  bool get isSending => _isSending;
  String? get error => _error;

  List<PedidoModel> get pedidosCocina => _pedidosCocina;
  bool get isLoadingCocina => _isLoadingCocina;
  String? get cocinaError => _cocinaError;

  List<PedidoModel> get misPedidos => _misPedidos;
  bool get isLoadingMisPedidos => _isLoadingMisPedidos;
  String? get misPedidosError => _misPedidosError;

  List<PedidoModel> get historialCocina => _historialCocina;
  bool get isLoadingHistorialCocina => _isLoadingHistorialCocina;
  String? get historialCocinaError => _historialCocinaError;

  List<PedidoModel> get pedidosPorCobrar => _pedidosPorCobrar;
  bool get isLoadingPorCobrar => _isLoadingPorCobrar;
  String? get porCobrarError => _porCobrarError;

  /// Envía el pedido (comanda) al backend. Devuelve el pedido creado o null si falló.
  Future<PedidoModel?> enviarComanda(PedidoCreateRequest request) async {
    _isSending = true;
    _error = null;
    notifyListeners();

    try {
      final pedido = await repository.crearPedido(request);
      return pedido;
    } catch (e) {
      _error = _parseError(e);
      return null;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  /// Carga los pedidos pendientes de preparar para la vista de cocina (KDS).
  Future<void> loadPedidosCocina() async {
    _isLoadingCocina = true;
    _cocinaError = null;
    notifyListeners();

    try {
      final pedidos = await repository.getPedidosActivos();
      _pedidosCocina =
          pedidos
              .where(
                (p) => _estadosCocina.contains(
                  p.estado?.toUpperCase() ?? '',
                ),
              )
              .toList()
            ..sort((a, b) {
              final fechaA = a.fechaPedido ?? DateTime.now();
              final fechaB = b.fechaPedido ?? DateTime.now();
              return fechaA.compareTo(fechaB);
            });
    } catch (e) {
      _cocinaError = _parseError(e);
    } finally {
      _isLoadingCocina = false;
      notifyListeners();
    }
  }

  /// Marca un pedido como listo (ATENDIDO) y lo retira del tablero de cocina.
  Future<bool> marcarComoListo(int pedidoId) async {
    try {
      await repository.cambiarEstado(pedidoId, 'ATENDIDO');
      _pedidosCocina.removeWhere((p) => p.id == pedidoId);
      notifyListeners();
      return true;
    } catch (e) {
      _cocinaError = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  /// Carga el historial de pedidos creados por el mesero indicado.
  Future<void> loadMisPedidos(int usuarioMeseroId) async {
    _isLoadingMisPedidos = true;
    _misPedidosError = null;
    notifyListeners();

    try {
      final pedidos = await repository.getTodosLosPedidos();
      _misPedidos =
          pedidos.where((p) => p.usuarioMeseroId == usuarioMeseroId).toList()
            ..sort((a, b) {
              final fechaA = a.fechaPedido ?? DateTime.now();
              final fechaB = b.fechaPedido ?? DateTime.now();
              return fechaB.compareTo(fechaA);
            });
    } catch (e) {
      _misPedidosError = _parseError(e);
    } finally {
      _isLoadingMisPedidos = false;
      notifyListeners();
    }
  }

  /// Carga el historial de pedidos ya atendidos por cocina.
  Future<void> loadHistorialCocina() async {
    _isLoadingHistorialCocina = true;
    _historialCocinaError = null;
    notifyListeners();

    try {
      final pedidos = await repository.getTodosLosPedidos();
      _historialCocina =
          pedidos
              .where(
                (p) => _estadosHistorialCocina.contains(
                  p.estado?.toUpperCase() ?? '',
                ),
              )
              .toList()
            ..sort((a, b) {
              final fechaA = a.fechaPedido ?? DateTime.now();
              final fechaB = b.fechaPedido ?? DateTime.now();
              return fechaB.compareTo(fechaA);
            });
    } catch (e) {
      _historialCocinaError = _parseError(e);
    } finally {
      _isLoadingHistorialCocina = false;
      notifyListeners();
    }
  }

  /// Carga los pedidos aún no pagados (PENDIENTE, EN_PROCESO, ATENDIDO) para
  /// que el administrador pueda registrar el cobro.
  Future<void> loadPedidosPorCobrar() async {
    _isLoadingPorCobrar = true;
    _porCobrarError = null;
    notifyListeners();

    try {
      final pedidos = await repository.getTodosLosPedidos();
      _pedidosPorCobrar =
          pedidos
              .where(
                (p) => _estadosPorCobrar.contains(
                  p.estado?.toUpperCase() ?? '',
                ),
              )
              .toList()
            ..sort((a, b) {
              final fechaA = a.fechaPedido ?? DateTime.now();
              final fechaB = b.fechaPedido ?? DateTime.now();
              return fechaB.compareTo(fechaA);
            });
    } catch (e) {
      _porCobrarError = _parseError(e);
    } finally {
      _isLoadingPorCobrar = false;
      notifyListeners();
    }
  }

  /// Marca un pedido como pagado y lo retira de la lista de pedidos por cobrar.
  Future<bool> marcarComoPagado(int pedidoId) async {
    try {
      await repository.cambiarEstado(pedidoId, 'PAGADO');
      _pedidosPorCobrar.removeWhere((p) => p.id == pedidoId);
      notifyListeners();
      return true;
    } catch (e) {
      _porCobrarError = _parseError(e);
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
    return 'No se pudo completar la operación. Intenta de nuevo.';
  }
}

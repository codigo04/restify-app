import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/auth/presentation/provider/login_provider.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';
import 'package:restifyapp/feature/order/presentation/provider/pedido_provider.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/tables/presentation/provider/mesa_provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MesaProvider>().loadMesas();
      _load();
    });
  }

  void _load() {
    final userId = context.read<LoginProvider>().user?.id;
    if (userId != null) {
      context.read<PedidoProvider>().loadMisPedidos(userId);
    }
  }

  Future<void> _refresh() async {
    final userId = context.read<LoginProvider>().user?.id;
    if (userId != null) {
      await context.read<PedidoProvider>().loadMisPedidos(userId);
    }
  }

  String _nombreMesa(int? mesaId, List<TableModel> mesas) {
    if (mesaId == null) return 'Sin mesa';
    for (final mesa in mesas) {
      if (mesa.id == mesaId.toString()) return mesa.name;
    }
    return 'Mesa $mesaId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Text(
          'Mis Pedidos',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            onPressed: _refresh,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer2<PedidoProvider, MesaProvider>(
        builder: (context, pedidoProvider, mesaProvider, _) {
          if (pedidoProvider.isLoadingMisPedidos &&
              pedidoProvider.misPedidos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pedidoProvider.misPedidosError != null &&
              pedidoProvider.misPedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pedidoProvider.misPedidosError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final pedidos = pedidoProvider.misPedidos;

          if (pedidos.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                  const Icon(
                    Icons.history_rounded,
                    size: 64,
                    color: AppColors.greyBorder,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Aún no has creado pedidos',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Los pedidos que tomes aparecerán aquí',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return _OrderCard(
                  pedido: pedido,
                  nombreMesa: _nombreMesa(pedido.mesaId, mesaProvider.mesas),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final PedidoModel pedido;
  final String nombreMesa;

  const _OrderCard({required this.pedido, required this.nombreMesa});

  _EstadoStyle _estadoStyle(String estado) {
    switch (estado.toUpperCase()) {
      case 'PENDIENTE':
        return _EstadoStyle('PENDIENTE', Colors.orange);
      case 'EN_PROCESO':
        return _EstadoStyle('EN PREPARACIÓN', Colors.blueAccent);
      case 'ATENDIDO':
        return _EstadoStyle('ATENDIDO', AppColors.success);
      case 'PAGADO':
        return _EstadoStyle('PAGADO', AppColors.primary);
      case 'ANULADO':
        return _EstadoStyle('ANULADO', AppColors.error);
      default:
        return _EstadoStyle(estado.toUpperCase(), AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estadoStyle(pedido.estado ?? 'PENDIENTE');
    final totalItems = pedido.detalles.fold<double>(
      0,
      (sum, d) => sum + d.cantidad,
    );
    final fecha = pedido.fechaPedido;
    final fechaStr = fecha != null
        ? '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')} · ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}'
        : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreMesa,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    if (pedido.numeroPedido != null)
                      Text(
                        '#${pedido.numeroPedido}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: estado.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  estado.label,
                  style: TextStyle(
                    color: estado.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.greyBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 15,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    totalItems == totalItems.truncateToDouble()
                        ? '${totalItems.toInt()} ítems'
                        : '${totalItems.toStringAsFixed(1)} ítems',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (fechaStr.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      fechaStr,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                'S/ ${pedido.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (pedido.detalles.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: pedido.detalles
                  .map(
                    (d) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${d.cantidad == d.cantidad.truncateToDouble() ? d.cantidad.toInt() : d.cantidad}x ${d.nombre}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _EstadoStyle {
  final String label;
  final Color color;

  _EstadoStyle(this.label, this.color);
}

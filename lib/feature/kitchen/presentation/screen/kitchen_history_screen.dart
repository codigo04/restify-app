import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';
import 'package:restifyapp/feature/order/presentation/provider/pedido_provider.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/tables/presentation/provider/mesa_provider.dart';

const _kdsBackground = AppColors.greyBackground;
const _kdsSurface = AppColors.surface;

class KitchenHistoryScreen extends StatefulWidget {
  const KitchenHistoryScreen({super.key});

  @override
  State<KitchenHistoryScreen> createState() => _KitchenHistoryScreenState();
}

class _KitchenHistoryScreenState extends State<KitchenHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MesaProvider>().loadMesas();
      context.read<PedidoProvider>().loadHistorialCocina();
    });
  }

  Future<void> _refresh() async {
    await context.read<PedidoProvider>().loadHistorialCocina();
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
      backgroundColor: _kdsBackground,
      appBar: AppBar(
        backgroundColor: _kdsSurface,
        elevation: 0,
        title: const Text(
          'Historial Cocina',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.greyMedium),
            onPressed: _refresh,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer2<PedidoProvider, MesaProvider>(
        builder: (context, pedidoProvider, mesaProvider, _) {
          if (pedidoProvider.isLoadingHistorialCocina &&
              pedidoProvider.historialCocina.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (pedidoProvider.historialCocinaError != null &&
              pedidoProvider.historialCocina.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pedidoProvider.historialCocinaError!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final pedidos = pedidoProvider.historialCocina;

          if (pedidos.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Icon(
                    Icons.checklist_rounded,
                    size: 56,
                    color: AppColors.greyMedium,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Sin pedidos atendidos aún',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return _HistorialTile(
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

class _HistorialTile extends StatelessWidget {
  final PedidoModel pedido;
  final String nombreMesa;

  const _HistorialTile({required this.pedido, required this.nombreMesa});

  @override
  Widget build(BuildContext context) {
    final estado = (pedido.estado ?? '').toUpperCase();
    final totalItems = pedido.detalles.fold<double>(
      0,
      (sum, d) => sum + d.cantidad,
    );
    final fecha = pedido.fechaPedido;
    final fechaStr = fecha != null
        ? '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')} · ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}'
        : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kdsSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreMesa.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalItems == totalItems.truncateToDouble()
                      ? '${totalItems.toInt()} ítems · $fechaStr'
                      : '${totalItems.toStringAsFixed(1)} ítems · $fechaStr',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              estado,
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

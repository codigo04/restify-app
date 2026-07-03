import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';
import 'package:restifyapp/feature/order/presentation/provider/pedido_provider.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/tables/presentation/provider/mesa_provider.dart';

const _estadosQueOcupanMesa = {'PENDIENTE', 'EN_PROCESO', 'ATENDIDO'};

class AdminBillingScreen extends StatefulWidget {
  const AdminBillingScreen({super.key});

  @override
  State<AdminBillingScreen> createState() => _AdminBillingScreenState();
}

class _AdminBillingScreenState extends State<AdminBillingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MesaProvider>().loadMesas();
      context.read<PedidoProvider>().loadPedidosPorCobrar();
    });
  }

  Future<void> _refresh() async {
    await context.read<PedidoProvider>().loadPedidosPorCobrar();
  }

  String _nombreMesa(int? mesaId, List<TableModel> mesas) {
    if (mesaId == null) return 'Sin mesa';
    for (final mesa in mesas) {
      if (mesa.id == mesaId.toString()) return mesa.name;
    }
    return 'Mesa $mesaId';
  }

  Future<void> _confirmarCobro(PedidoModel pedido, String nombreMesa) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.payments_rounded, color: AppColors.success, size: 26),
              SizedBox(width: 10),
              Text(
                'Confirmar cobro',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          content: Text(
            '¿Confirmas que $nombreMesa pagó S/ ${pedido.total.toStringAsFixed(2)}? '
            'El pedido pasará a estado PAGADO.',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar pago'),
            ),
          ],
        );
      },
    );

    if (confirmado != true) return;
    if (!mounted) return;

    final provider = context.read<PedidoProvider>();
    final ok = await provider.marcarComoPagado(pedido.id);

    if (!mounted) return;

    if (ok && pedido.mesaId != null) {
      final quedanPedidosActivos = provider.pedidosPorCobrar.any(
        (p) =>
            p.mesaId == pedido.mesaId &&
            _estadosQueOcupanMesa.contains((p.estado ?? '').toUpperCase()),
      );

      if (!quedanPedidosActivos) {
        await context.read<MesaProvider>().cambiarEstado(
          pedido.mesaId.toString(),
          TableStatus.available,
        );
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? '$nombreMesa marcada como PAGADA'
              : (provider.porCobrarError ?? 'No se pudo registrar el pago'),
        ),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: const Text(
          'Pedidos por Cobrar',
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
          if (pedidoProvider.isLoadingPorCobrar &&
              pedidoProvider.pedidosPorCobrar.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pedidoProvider.porCobrarError != null &&
              pedidoProvider.pedidosPorCobrar.isEmpty) {
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
                    pedidoProvider.porCobrarError!,
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

          final pedidos = pedidoProvider.pedidosPorCobrar;

          if (pedidos.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                  const Icon(
                    Icons.task_alt_rounded,
                    size: 64,
                    color: AppColors.greyBorder,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'No hay pedidos pendientes de cobro',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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
                final nombreMesa = _nombreMesa(
                  pedido.mesaId,
                  mesaProvider.mesas,
                );
                return _BillingCard(
                  pedido: pedido,
                  nombreMesa: nombreMesa,
                  onCobrar: () => _confirmarCobro(pedido, nombreMesa),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BillingCard extends StatelessWidget {
  final PedidoModel pedido;
  final String nombreMesa;
  final VoidCallback onCobrar;

  const _BillingCard({
    required this.pedido,
    required this.nombreMesa,
    required this.onCobrar,
  });

  _EstadoStyle _estadoStyle(String estado) {
    switch (estado.toUpperCase()) {
      case 'PENDIENTE':
        return _EstadoStyle('PENDIENTE', Colors.orange);
      case 'EN_PROCESO':
        return _EstadoStyle('EN PREPARACIÓN', Colors.blueAccent);
      case 'ATENDIDO':
        return _EstadoStyle('ATENDIDO', AppColors.success);
      default:
        return _EstadoStyle(estado.toUpperCase(), AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estadoStyle(pedido.estado ?? 'PENDIENTE');
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
          const SizedBox(height: 10),
          if (fechaStr.isNotEmpty)
            Row(
              children: [
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
          const SizedBox(height: 14),
          const Divider(color: AppColors.greyBorder, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total a cobrar',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'S/ ${pedido.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onCobrar,
                icon: const Icon(Icons.payments_rounded, size: 18),
                label: const Text(
                  'Marcar como pagado',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
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

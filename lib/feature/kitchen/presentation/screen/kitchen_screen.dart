import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restifyapp/core/theme/app_colors.dart';
import 'package:restifyapp/feature/order/domain/model/pedido_model.dart';
import 'package:restifyapp/feature/order/presentation/provider/pedido_provider.dart';
import 'package:restifyapp/feature/tables/domain/model/table_model.dart';
import 'package:restifyapp/feature/tables/presentation/provider/mesa_provider.dart';

const _kdsBackground = Color(0xFF121212);
const _kdsSurface = Color(0xFF1E1E1E);
const _kdsSurfaceAlt = Color(0xFF262626);
const _kdsWarning = Color(0xFFFFB300);

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MesaProvider>().loadMesas();
      context.read<PedidoProvider>().loadPedidosCocina();
    });
  }

  Future<void> _refresh() async {
    await context.read<PedidoProvider>().loadPedidosCocina();
  }

  String _nombreMesa(int? mesaId, List<TableModel> mesas) {
    if (mesaId == null) return 'Sin mesa';
    for (final mesa in mesas) {
      if (mesa.id == mesaId.toString()) return mesa.name;
    }
    return 'Mesa $mesaId';
  }

  Future<void> _marcarComoListo(PedidoModel pedido, String nombreMesa) async {
    final ok = await context.read<PedidoProvider>().marcarComoListo(
      pedido.id,
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nombreMesa marcada como LISTA'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final error =
          context.read<PedidoProvider>().cocinaError ??
          'No se pudo actualizar el pedido';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kdsBackground,
      appBar: AppBar(
        backgroundColor: _kdsSurface,
        elevation: 0,
        title: const Text(
          'COCINA (KDS)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Consumer<PedidoProvider>(
            builder: (context, provider, _) {
              final count = provider.pedidosCocina.length;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  count == 1 ? '1 PEDIDO' : '$count PEDIDOS',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _refresh,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer2<PedidoProvider, MesaProvider>(
        builder: (context, pedidoProvider, mesaProvider, _) {
          if (pedidoProvider.isLoadingCocina &&
              pedidoProvider.pedidosCocina.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (pedidoProvider.cocinaError != null &&
              pedidoProvider.pedidosCocina.isEmpty) {
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
                    pedidoProvider.cocinaError!,
                    style: const TextStyle(color: Colors.white54),
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

          final pedidos = pedidoProvider.pedidosCocina;

          if (pedidos.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Icon(
                    Icons.restaurant_rounded,
                    size: 56,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Sin pedidos pendientes',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Los nuevos pedidos aparecerán aquí',
                      style: TextStyle(color: Colors.white24, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 260)
                    .floor()
                    .clamp(1, 6);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    final nombreMesa = _nombreMesa(
                      pedido.mesaId,
                      mesaProvider.mesas,
                    );
                    return _OrderTicket(
                      pedido: pedido,
                      nombreMesa: nombreMesa,
                      onListo: () => _marcarComoListo(pedido, nombreMesa),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderTicket extends StatelessWidget {
  final PedidoModel pedido;
  final String nombreMesa;
  final VoidCallback onListo;

  const _OrderTicket({
    required this.pedido,
    required this.nombreMesa,
    required this.onListo,
  });

  @override
  Widget build(BuildContext context) {
    final minutesAgo = pedido.fechaPedido != null
        ? DateTime.now().difference(pedido.fechaPedido!).inMinutes.clamp(
            0,
            999,
          )
        : null;
    final bool isLate = minutesAgo != null && minutesAgo > 10;
    final bool isWarning = minutesAgo != null && minutesAgo > 5 && !isLate;
    final borderColor = isLate
        ? Colors.redAccent
        : isWarning
        ? _kdsWarning
        : Colors.grey.shade800;
    final estado = (pedido.estado ?? 'PENDIENTE').toUpperCase();
    final totalItems = pedido.detalles.fold<double>(
      0,
      (sum, d) => sum + d.cantidad,
    );

    return Container(
      decoration: BoxDecoration(
        color: _kdsSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isLate || isWarning ? 2 : 1,
        ),
        boxShadow: [
          if (isLate)
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del ticket
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isLate
                  ? Colors.redAccent.withValues(alpha: 0.18)
                  : _kdsSurfaceAlt,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreMesa.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _EstadoBadge(estado: estado),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: isLate
                              ? Colors.redAccent
                              : isWarning
                              ? _kdsWarning
                              : Colors.white54,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          minutesAgo != null ? '${minutesAgo}m' : '--',
                          style: TextStyle(
                            color: isLate
                                ? Colors.redAccent
                                : isWarning
                                ? _kdsWarning
                                : Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalItems == totalItems.truncateToDouble()
                          ? '${totalItems.toInt()} ítems'
                          : '${totalItems.toStringAsFixed(1)} ítems',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // Lista de items
          Expanded(
            child: pedido.detalles.isEmpty
                ? const Center(
                    child: Text(
                      'Sin ítems',
                      style: TextStyle(color: Colors.white24),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: pedido.detalles.length,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final item = pedido.detalles[idx];
                      final cantidadStr =
                          item.cantidad == item.cantidad.truncateToDouble()
                          ? item.cantidad.toInt().toString()
                          : item.cantidad.toStringAsFixed(1);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              cantidadStr,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nombre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                                if (item.observacion != null &&
                                    item.observacion!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      item.observacion!,
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Botón de acción
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: onListo,
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text(
                  'LISTO',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final String estado;

  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final isEnProceso = estado == 'EN_PROCESO';
    final color = isEnProceso ? _kdsWarning : Colors.lightBlueAccent;
    final label = isEnProceso ? 'EN PREPARACIÓN' : 'NUEVO';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

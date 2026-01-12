import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/enums/order_status.dart';
import 'package:foody/core/enums/payment_method.dart';
import 'package:foody/core/ui/app_error_view.dart';
import 'package:foody/core/ui/app_loading_view.dart';
import 'package:foody/features/orders/bloc/order_cubit.dart';
import 'package:foody/features/orders/bloc/order_state.dart';
import 'package:foody/features/orders/bloc/order_with_item.dart';
import 'package:foody/features/orders/widgets/order_card.dart';
import 'package:foody/features/orders/widgets/order_status_tabs.dart';
import 'package:foody/features/orders/widgets/payment_method_tile.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoaded &&
              state.selectedStatus == OrderStatus.pending &&
              state.filteredOrders.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () =>
                  _showPayAllPaymentSheet(context, state.filteredOrders),
              label: const Text('Pay All Pending'),
              icon: const Icon(Icons.payment),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return AppLoadingView(message: state.msg);
          }

          if (state is OrderError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<OrderCubit>().fetchOrdersWithItems(),
            );
          }

          if (state is OrderLoaded) {
            return Column(
              children: [
                const SizedBox(height: 8),
                const OrderStatusTabs(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        context.read<OrderCubit>().fetchOrdersWithItems(),
                    child: state.filteredOrders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No ${state.selectedStatus?.name} orders',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                            itemCount: state.filteredOrders.length,
                            itemBuilder: (context, index) {
                              return OrderCard(
                                orderWithItems: state.filteredOrders[index],
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showPayAllPaymentSheet(
    BuildContext context,
    List<OrderWithItems> pendingOrders,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PayAllConfirmSheet(pendingOrders: pendingOrders),
    );
  }
}

class _PayAllConfirmSheet extends StatefulWidget {
  final List<OrderWithItems> pendingOrders;

  const _PayAllConfirmSheet({required this.pendingOrders});

  @override
  State<_PayAllConfirmSheet> createState() => _PayAllConfirmSheetState();
}

class _PayAllConfirmSheetState extends State<_PayAllConfirmSheet> {
  PaymentMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.pendingOrders.fold<double>(
      0,
      (sum, o) => sum + o.order.totalAmount,
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pay All Pending Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),
          Text(
            '${widget.pendingOrders.length} pending order(s)',
            style: const TextStyle(fontSize: 15),
          ),

          const SizedBox(height: 6),
          Text(
            'Total: ${totalAmount.toStringAsFixed(2)} \$',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 24),
          const Text(
            'Select payment method',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Column(
            children: PaymentMethod.values.map((method) {
              return PaymentMethodTile(
                method: method,
                isSelected: _selectedMethod == method,
                onTap: () => setState(() => _selectedMethod = method),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedMethod == null
                      ? null
                      : () async {
                          context.pop();
                          context.read<OrderCubit>().payAllPendingOrders(
                            _selectedMethod!.value,
                          );
                        },
                  child: const Text('Confirm & Pay'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

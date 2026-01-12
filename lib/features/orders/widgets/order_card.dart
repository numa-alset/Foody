import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/enums/order_status.dart';
import 'package:foody/core/models/order.dart';
import 'package:foody/core/models/order_item.dart';
import 'package:foody/core/ui/global_toast.dart';
import 'package:foody/features/orders/bloc/order_cubit.dart';
import 'package:foody/features/orders/bloc/order_state.dart';
import 'package:foody/features/orders/bloc/order_with_item.dart';
import 'package:foody/features/orders/widgets/confirm_payment_sheet.dart';

class OrderCard extends StatelessWidget {
  final OrderWithItems orderWithItems;

  const OrderCard({super.key, required this.orderWithItems});

  @override
  Widget build(BuildContext context) {
    final order = orderWithItems.order;
    final isPending = order.orderStatus == OrderStatus.pending.name;

    return BlocListener<OrderCubit, OrderState>(
      listenWhen: (prev, curr) =>
          prev is OrderLoaded &&
          curr is OrderLoaded &&
          curr.filteredOrders.any(
            (o) =>
                o.order.id == order.id &&
                o.order.orderStatus !=
                    prev.filteredOrders
                        .firstWhere((p) => p.order.id == order.id)
                        .order
                        .orderStatus,
          ),
      listener: (context, state) {
        if (state is OrderLoaded) {
          final updatedOrder = state.filteredOrders.firstWhere(
            (o) => o.order.id == order.id,
            orElse: () => orderWithItems,
          );

          if (updatedOrder.order.orderStatus == OrderStatus.confirmed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Order #${order.id.substring(0, 6)} paid successfully!',
                ),
                backgroundColor: Colors.green.shade700,
              ),
            );
          }
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1.5,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Order #${order.id.substring(0, 8)}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${order.totalAmount.toStringAsFixed(2)} \$  •  ${order.orderStatus.toUpperCase()}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          trailing: _StatusChip(status: order.orderStatus),
          children: [
            const Divider(height: 24),
            _OrderItemsList(items: orderWithItems.items),
            const Divider(height: 24),
            if (isPending)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _PayNowButton(order: order),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  final List<OrderItem> items;

  const _OrderItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final item = entry.value;
        final isLast = entry.key == items.length - 1;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '×${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Item #${item.id.substring(0, 8)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${item.price.toStringAsFixed(2)} \$',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast) Divider(color: Colors.grey.shade200, height: 1),
          ],
        );
      }).toList(),
    );
  }
}

class _PayNowButton extends StatefulWidget {
  final Order order;

  const _PayNowButton({required this.order});

  @override
  State<_PayNowButton> createState() => _PayNowButtonState();
}

class _PayNowButtonState extends State<_PayNowButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.payment, size: 20),
        label: Text(
          _isProcessing ? 'Processing...' : 'Pay Now',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.green.shade700,
          // foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _isProcessing
            ? null
            : () async {
                final confirmed = await showModalBottomSheet<bool?>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) =>
                      ConfirmPaymentSheet(order: widget.order),
                );

                if (confirmed != true || !mounted) return;

                setState(() => _isProcessing = true);

                try {
                  GlobalToast.show('Processing payment...');
                  // await context.read<OrderCubit>().paySingleOrder(
                  //   widget.order.id,
                  // );
                } catch (e) {
                  GlobalToast.show(
                    'Failed to process payment. Please try again.',
                  );
                } finally {
                  if (mounted) {
                    setState(() => _isProcessing = false);
                  }
                }
              },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  Color get color {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/enums/payment_method.dart';
import 'package:foody/core/models/order.dart';
import 'package:foody/features/orders/bloc/order_cubit.dart';
import 'package:foody/features/orders/widgets/payment_method_tile.dart';
import 'package:go_router/go_router.dart';

class ConfirmPaymentSheet extends StatefulWidget {
  final Order order;

  const ConfirmPaymentSheet({super.key, required this.order});

  @override
  State<ConfirmPaymentSheet> createState() => _ConfirmPaymentSheetState();
}

class _ConfirmPaymentSheetState extends State<ConfirmPaymentSheet> {
  PaymentMethod? _selectedMethod;
  @override
  Widget build(BuildContext context) {
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
            'Confirm Payment',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Order #${widget.order.id.substring(0, 8)}',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Total amount: ${widget.order.totalAmount.toStringAsFixed(2)} \$',
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
                onTap: () {
                  setState(() => _selectedMethod = method);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedMethod == null
                      ? null
                      : () {
                          context.pop();
                          context.read<OrderCubit>().paySingleOrder(
                            widget.order.id,
                            _selectedMethod!.value,
                            widget.order.totalAmount,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Confirm & Pay'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

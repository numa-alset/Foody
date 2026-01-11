import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/features/cart/bloc/cart_cubit.dart';
import 'package:foody/features/cart/bloc/cart_state.dart';

class CheckoutBar extends StatelessWidget {
  const CheckoutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.isEmpty) return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Total: \$${state.subtotal.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  // vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _openCheckoutSheet(context),
              child: const Text("Add to Orders"),
            ),
          ],
        );
      },
    );
  }

  void _openCheckoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _checkoutBottomSheet(context);
      },
    );
  }

  _checkoutBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _handle(),
            const SizedBox(height: 16),
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _orderItems(context),
            const SizedBox(height: 16),
            _totalRow(context),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.read<CartCubit>().addNewOrder(context),
                child: const Text("Add to Orders"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  _orderItems(BuildContext context) {
    final items = context.watch<CartCubit>().state.items;
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text("${item.quantity}x"),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.name)),
                  Text("\$${item.totalPrice.toStringAsFixed(2)}"),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  _totalRow(BuildContext context) {
    final total = context.watch<CartCubit>().state.subtotal;
    return Row(
      children: [
        const Text("Total", style: TextStyle(fontSize: 16)),
        const Spacer(),
        Text(
          "\$${total.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

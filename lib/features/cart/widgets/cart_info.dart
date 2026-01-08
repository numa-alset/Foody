import 'package:flutter/material.dart';
import 'package:foody/core/models/cart_item.dart';

class CartInfo extends StatelessWidget {
  final CartItem item;
  const CartInfo(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          "\$${item.price.toStringAsFixed(2)}",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

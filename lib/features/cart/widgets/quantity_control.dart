import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/cart_item.dart';
import 'package:foody/features/cart/bloc/cart_cubit.dart';

class QuantityControls extends StatelessWidget {
  final CartItem item;
  const QuantityControls(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).primaryColor,
          onPressed: () => cubit.increment(item.menuId),
        ),
        Text(
          item.quantity.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => cubit.decrement(item.menuId),
        ),
      ],
    );
  }
}

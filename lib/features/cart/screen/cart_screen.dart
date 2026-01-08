import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/cart_item.dart';
import 'package:foody/features/cart/bloc/cart_cubit.dart';
import 'package:foody/features/cart/bloc/cart_state.dart';
import 'package:foody/features/cart/widgets/cart_image.dart';
import 'package:foody/features/cart/widgets/cart_info.dart';
import 'package:foody/features/cart/widgets/checkout_bar.dart';
import 'package:foody/features/cart/widgets/quantity_control.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart"), centerTitle: true),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _EmptyCart();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return _CartItemTile(item: state.items[index]);
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: CheckoutBar(),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/cart_full.json'),
          const SizedBox(height: 16),
          const Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Add some delicious food 🍔",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: .05),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CartImage(item.imageUrl),
            const SizedBox(width: 12),
            Expanded(child: CartInfo(item)),
            QuantityControls(item),
          ],
        ),
      ),
    );
  }
}

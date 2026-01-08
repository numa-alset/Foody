import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foody/core/models/cart_item.dart';
import 'package:foody/core/models/menu.dart';
import 'package:foody/features/cart/bloc/cart_cubit.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        margin: const EdgeInsets.fromLTRB(6, 4, 2, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            menu.imageUrl == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/placeholder.png',
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      menu.imageUrl!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      menu.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${menu.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<CartCubit>().addToCart(
                  CartItem(
                    menuId: menu.id,
                    restaurantId: menu.restaurantId,
                    name: menu.name,
                    price: menu.price,
                  ),
                );
                Fluttertoast.showToast(
                  msg: "menu added to cart",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

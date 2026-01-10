import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foody/constatnt/app_colors.dart';
import 'package:foody/core/models/cart_item.dart';
import 'package:foody/core/models/menu.dart';
import 'package:foody/features/cart/bloc/cart_cubit.dart';

// --------------------------- MenuCard ---------------------------
class MenuCard extends StatelessWidget {
  final Menu menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Optional: open detailed menu screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image takes more space
            AspectRatio(
              aspectRatio: 16 / 10,
              child: menu.imageUrl != null
                  ? Image.network(
                      menu.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    menu.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${menu.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade700,
                        ),
                      ),
                      _buildAddButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.fastfood_rounded, size: 48, color: Colors.grey),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Material(
      color: menu.availabilityStatus ? AppColors.primary : Colors.grey,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: menu.availabilityStatus
            ? () {
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
              }
            : null,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

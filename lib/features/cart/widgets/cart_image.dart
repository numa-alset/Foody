import 'package:flutter/material.dart';

class CartImage extends StatelessWidget {
  final String? url;
  const CartImage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 70,
        color: Colors.grey.shade200,
        child: url == null
            ? Image.asset('assets/placeholder.png', fit: BoxFit.contain)
            : Image.network(url!, fit: BoxFit.cover),
      ),
    );
  }
}

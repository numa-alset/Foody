import 'package:equatable/equatable.dart';
import 'package:foody/core/models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
    );
  }

  @override
  List<Object> get props => [items];
}

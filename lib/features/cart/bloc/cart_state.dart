import 'package:equatable/equatable.dart';
import 'package:foody/core/models/cart_item.dart';

enum CartStatus { idle, loading, success, error }

class CartState extends Equatable {
  final List<CartItem> items;
  final CartStatus status;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.status = CartStatus.idle,
    this.errorMessage,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    CartStatus? status,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
  };

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [items, status, errorMessage];
}

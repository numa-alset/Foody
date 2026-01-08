class CartItem {
  final String menuId;
  final String restaurantId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const CartItem({
    required this.menuId,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      menuId: menuId,
      restaurantId: restaurantId,
      name: name,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'menuId': menuId,
    'restaurantId': restaurantId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuId: json['menuId'],
      restaurantId: json['restaurantId'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }
}

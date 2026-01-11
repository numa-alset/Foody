class OrderItem {
  final String id;
  final String orderId;
  final String menuId;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.menuId,
    required this.quantity,
    required this.price,
  });
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['order_item_id'] as String,
      menuId: json['menu_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      orderId: json['order_id'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
    'order_item_id': id,
    'menu_id': menuId,
    'quantity': quantity,
    'price': price,
    'order_id': orderId,
  };
}

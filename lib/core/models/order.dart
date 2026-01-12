class Order {
  final String id;
  final String restaurantId;
  final String userId;
  final String orderStatus;
  final int totalAmount;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.restaurantId,
    required this.createdAt,
    required this.orderStatus,
    required this.totalAmount,
    required this.userId,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'] as String,
      userId: json['user_id'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      orderStatus: json['order_status'] as String,
      createdAt: DateTime.parse(json['created_at']),
      restaurantId: json['restaurant_id'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
    'order_id': id,
    'user_id': userId,
    'total_amount': totalAmount,
    'order_status': orderStatus,
    'created_at': createdAt,
    'restaurant_id': restaurantId,
  };
  Order copyWith({
    String? orderStatus,
    // add other fields you want to support
  }) {
    return Order(
      id: id,
      userId: userId,
      totalAmount: totalAmount,
      createdAt: createdAt,
      orderStatus: orderStatus ?? this.orderStatus,
      restaurantId: restaurantId,
    );
  }
}

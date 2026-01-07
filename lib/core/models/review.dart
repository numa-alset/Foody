class Review {
  final String id;
  final String userid;
  final String restaurantId;
  final String orderId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userid,
    required this.restaurantId,
    required this.orderId,
    required this.rating,
    required this.createdAt,
    required this.comment,
  });
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['review_id'] as String,
      userid: json['user_id'] as String,
      restaurantId: json['restaurant_id'] as String,
      orderId: json['order_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

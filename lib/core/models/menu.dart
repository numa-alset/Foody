class Menu {
  final String id;
  final String restaurantId;
  final String name;
  final String? imageUrl;
  final String description;
  final double price;
  final bool availabilityStatus;

  Menu({
    required this.id,
    required this.name,
    required this.availabilityStatus,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.restaurantId,
  });
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['menu_id'] as String,
      name: json['item_name'] as String,
      price: json['price'] as double,
      description: json['description'] as String,
      availabilityStatus: json['availability_status'] as bool,
      imageUrl: json['image_url'] as String?,
      restaurantId: json['restaurant_id'] as String,
    );
  }
}

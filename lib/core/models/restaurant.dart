class Restaurant {
  final String id;
  final String name;
  final String? logo;
  final String address;
  final double rating;
  final String cuisineType;
  final String phone;

  Restaurant({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
    required this.rating,
    required this.cuisineType,
    required this.phone,
  });
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['restaurant_id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      cuisineType: json['cuisine_type'] as String,
      phone: json['phone'] as String,
    );
  }
}

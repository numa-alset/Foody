class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
    'user_id': id,
    'address': address,
    'phone': phone,
    'email': email,
    'created_at': createdAt,
    'name': name,
  };
  User copyWith({
    String? name,
    String? phone,
    String? address,
    // add other fields you want to support
  }) {
    return User(
      id: id,
      email: email,
      address: address ?? this.address,
      createdAt: createdAt,
      phone: phone ?? this.phone,
      name: name ?? this.name,
    );
  }
}

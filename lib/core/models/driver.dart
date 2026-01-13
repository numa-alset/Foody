class Driver {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final bool availabilityStatus;

  Driver({
    required this.id,
    required this.name,
    required this.availabilityStatus,
    required this.vehicleType,
    required this.phone,
  });
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['driver_id'] as String,
      phone: json['phone'] as String,
      availabilityStatus: json["availability_status"] as bool,
      vehicleType: json['vehicle_type'] as String,
      name: json['name'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
    'driver_id': id,
    'phone': phone,
    'availability_status': availabilityStatus,
    'vehicle_type': vehicleType,
    'name': name,
  };
}

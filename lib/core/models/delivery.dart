class Delivery {
  final String id;
  final String orderId;
  final String driverId;
  final String deliveryStatus;
  final DateTime estimatedTime;
  final DateTime actualTime;

  Delivery({
    required this.id,
    required this.orderId,
    required this.estimatedTime,
    required this.deliveryStatus,
    required this.actualTime,
    required this.driverId,
  });
  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['delivery_id'] as String,
      driverId: json['driver_id'] as String,
      actualTime: DateTime.parse(json['actual_time']),
      deliveryStatus: json['delivery_status'] as String,
      estimatedTime: DateTime.parse(json['estimated_time']),
      orderId: json['order_id'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
    'delivery_id': id,
    'driver_id': driverId,
    'actual_time': actualTime,
    'delivery_status': deliveryStatus,
    'estimated_time': estimatedTime,
    'order_id': orderId,
  };
  Delivery copyWith({
    String? deliveryStatus,
    // add other fields you want to support
  }) {
    return Delivery(
      id: id,
      driverId: driverId,
      actualTime: actualTime,
      estimatedTime: estimatedTime,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      orderId: orderId,
    );
  }
}

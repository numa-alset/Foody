import 'package:foody/features/deliveries/bloc/delivery_with_driver.dart';

abstract class DeliveryState {}

class DeliveryLoading extends DeliveryState {
  final String msg;
  DeliveryLoading({this.msg = 'Loading Deliveries...'});
}

class DeliveryLoaded extends DeliveryState {
  final List<DeliveryWithDriver> deliveries;

  DeliveryLoaded(this.deliveries);
}

class DeliveryError extends DeliveryState {
  final String message;

  DeliveryError(this.message);
}

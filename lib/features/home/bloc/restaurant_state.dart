import 'package:foody/core/models/restaurant.dart';

abstract class RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;

  RestaurantLoaded(this.restaurants);
}

class RestaurantError extends RestaurantState {
  final String message;

  RestaurantError(this.message);
}

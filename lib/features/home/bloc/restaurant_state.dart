import 'package:foody/core/models/restaurant.dart';
import 'package:foody/core/models/restaurant_filter.dart';

abstract class RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final RestaurantFilters restaurantFilters;

  RestaurantLoaded(this.restaurants, this.restaurantFilters);
}

class RestaurantError extends RestaurantState {
  final String message;

  RestaurantError(this.message);
}

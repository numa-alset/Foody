import 'package:foody/core/models/menu.dart';
import 'package:foody/core/models/review.dart';

abstract class MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<Menu> menus;
  final List<Review> reviews;

  MenuLoaded(this.menus, this.reviews);
}

class MenuError extends MenuState {
  final String message;

  MenuError(this.message);
}

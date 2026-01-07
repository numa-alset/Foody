import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/menu.dart';
import 'package:foody/core/models/review.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/menus/bloc/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuLoading());

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    emit(MenuLoading());

    try {
      final menusResponse = await supabase
          .from('menus')
          .select()
          .eq('restaurant_id', restaurantId);

      final reviewsResponse = await supabase
          .from('reviews')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('created_at', ascending: false);
      print(menusResponse);
      print(reviewsResponse);

      final menus = (menusResponse as List)
          .map<Menu>((e) => Menu.fromJson(e))
          .toList();

      final reviews = (reviewsResponse as List)
          .map<Review>((e) => Review.fromJson(e))
          .toList();

      emit(MenuLoaded(menus, reviews));
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }
}

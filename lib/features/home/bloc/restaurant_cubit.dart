import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/restaurant.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/home/bloc/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantLoading());

  Future<void> fetchRestaurants() async {
    emit(RestaurantLoading());
    try {
      final data = await supabase
          .from('restaurants')
          .select()
          .order('rating', ascending: false);
      print(data);
      emit(
        RestaurantLoaded(
          data.map<Restaurant>((e) => Restaurant.fromJson(e)).toList(),
        ),
      );
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }
}

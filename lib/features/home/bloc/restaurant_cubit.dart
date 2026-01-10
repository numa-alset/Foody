import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/restaurant.dart';
import 'package:foody/core/models/restaurant_filter.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/home/bloc/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantLoading());

  RestaurantFilters _currentFilters = const RestaurantFilters();

  Future<void> fetchRestaurants({bool refresh = false}) async {
    if (!refresh) {
      emit(RestaurantLoading());
    }

    try {
      // Use dynamic so we can reassign when some chain methods return different builder types
      dynamic query = supabase.from('restaurants').select();

      // Apply filters
      if (_currentFilters.cuisine != null) {
        query = query.eq('cuisine_type', _currentFilters.cuisine!);
      }

      if (_currentFilters.minRating != null) {
        query = query.gte('rating', _currentFilters.minRating!);
      }

      if (_currentFilters.searchQuery != null &&
          _currentFilters.searchQuery!.trim().isNotEmpty) {
        // use PostgREST `or` with ilike patterns
        final pattern = '%${_currentFilters.searchQuery!.trim()}%';
        query = query.or('name.ilike.$pattern,address.ilike.$pattern');
      }

      // Sorting
      switch (_currentFilters.sortBy) {
        case 'name_asc':
          query = query.order('name', ascending: true);
          break;
        case 'rating_asc':
          query = query.order('rating', ascending: true);
          break;
        case 'rating_desc':
        default:
          query = query.order('rating', ascending: false);
      }

      // Await the query result directly (supabase filter/transform builders are awaitable)
      final result = await query;

      final List<dynamic> data = (result ?? []) as List<dynamic>;

      emit(
        RestaurantLoaded(
          data
              .map<Restaurant>(
                (e) => Restaurant.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList(),
          _currentFilters,
        ),
      );
    } catch (e) {
      emit(RestaurantError(e.toString()));
    }
  }

  void updateFilters(RestaurantFilters newFilters) {
    _currentFilters = newFilters;
    fetchRestaurants();
  }

  void resetFilters() {
    _currentFilters = const RestaurantFilters();
    fetchRestaurants();
  }
}

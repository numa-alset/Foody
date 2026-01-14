import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/delivery.dart';
import 'package:foody/core/models/driver.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/deliveries/bloc/delivery_state.dart';
import 'package:foody/features/deliveries/bloc/delivery_with_driver.dart';
import 'package:go_router/go_router.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryLoading());

  Future<void> fetchDeliveriesWithDrivers() async {
    emit(DeliveryLoading());
    try {
      final userId = supabase.auth.currentUser!.id;

      final confirmedOrdersResponse = await supabase
          .from('orders')
          .select("order_id")
          .eq('order_status', 'confirmed')
          .eq('user_id', userId);

      final List<String> confirmedOrders = confirmedOrdersResponse
          .map((e) => e["order_id"] as String)
          .toList();
      List<Delivery> deliveries = [];
      for (var e in confirmedOrders) {
        final deliveryResponse = await supabase
            .from('delivery')
            .select()
            .eq('order_id', e);
        deliveryResponse.map((e) => Delivery.fromJson(e)).firstOrNull != null
            ? deliveries.add(
                deliveryResponse.map((e) => Delivery.fromJson(e)).first,
              )
            : null;
      }
      final List<DeliveryWithDriver> result = [];

      for (final del in deliveries) {
        final driverResponse = await supabase
            .from('drivers')
            .select()
            .eq('driver_id', del.driverId);

        final driver = Driver.fromJson(driverResponse.first);

        result.add(DeliveryWithDriver(delivery: del, driver: driver));
      }
      emit(DeliveryLoaded(result));
    } catch (e) {
      emit(DeliveryError('Failed to load Deliveries: ${e.toString()}'));
    }
  }

  Future<void> confirmDeliveryAndAddReview(
    BuildContext context,
    Delivery delivery,
    int rate,
    String comment,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final restaurantId = await supabase
          .from('orders')
          .select('restaurant_id')
          .eq('order_id', delivery.orderId)
          .single();

      await supabase.from('reviews').insert({
        'user_id': userId,
        'order_id': delivery.orderId,
        'rating': rate,
        'comment': comment,
        'restaurant_id': restaurantId['restaurant_id'] as String,
      });
      await supabase
          .from('delivery')
          .update({'delivery_status': 'delivered'})
          .eq('delivery_id', delivery.id);
      await supabase
          .from('orders')
          .update({'order_status': 'delivered'})
          .eq('order_id', delivery.orderId);
      await fetchDeliveriesWithDrivers();
      context.pop();
    } catch (e) {
      emit(DeliveryError('Failed to confirm Delivery: ${e.toString()}'));
    }
  }
}

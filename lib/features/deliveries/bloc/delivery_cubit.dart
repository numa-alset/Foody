import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/models/delivery.dart';
import 'package:foody/core/models/driver.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/deliveries/bloc/delivery_state.dart';
import 'package:foody/features/deliveries/bloc/delivery_with_driver.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(DeliveryLoading());

  Future<void> fetchDeliveriesWithDrivers() async {
    emit(DeliveryLoading());
    try {
      final userId = supabase.auth.currentUser!.id;

      final confirmedOrdersResponse = await supabase
          .from('orders')
          .select("order_id")
          .eq('status', 'confirmed')
          .eq('user_id', userId);
      final List<String> confirmedOrders = confirmedOrdersResponse
          .map((e) => e as String)
          .toList();

      List<Delivery> deliveries = [];
      for (var e in confirmedOrders) {
        final deliveryResponse = await supabase
            .from('delivery')
            .select()
            .eq('order_id', e);
        deliveries.addAll(
          deliveryResponse.map((e) => Delivery.fromJson(e)).toList(),
        );
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
}

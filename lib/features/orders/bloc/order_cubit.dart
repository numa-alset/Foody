import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foody/core/enums/order_status.dart';
import 'package:foody/core/models/order.dart';
import 'package:foody/core/models/order_item.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/orders/bloc/order_state.dart';
import 'package:foody/features/orders/bloc/order_with_item.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderLoading());

  List<OrderWithItems> _allOrdersCache = [];

  Future<void> fetchOrdersWithItems({bool showLoading = true}) async {
    if (showLoading) {
      emit(OrderLoading());
    }

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(OrderError('User not authenticated'));
        return;
      }

      final ordersResponse = await supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final orders = ordersResponse.map((e) => Order.fromJson(e)).toList();

      final List<OrderWithItems> result = [];

      for (final order in orders) {
        final itemsResponse = await supabase
            .from('order_items')
            .select()
            .eq('order_id', order.id);

        final items = itemsResponse.map((e) => OrderItem.fromJson(e)).toList();

        result.add(OrderWithItems(order: order, items: items));
      }

      _allOrdersCache = result;

      // Preserve current filter if possible
      OrderStatus? currentFilter;
      if (state is OrderLoaded) {
        currentFilter = (state as OrderLoaded).selectedStatus;
      }

      emit(
        OrderLoaded(
          allOrders: _allOrdersCache,
          selectedStatus: currentFilter ?? OrderStatus.pending,
        ),
      );
    } catch (e) {
      emit(OrderError('Failed to load orders: ${e.toString()}'));
      // You can also log the stack trace in production
      // debugPrint('Order fetch error: $e\n$stack');
    }
  }

  Future<void> refreshOrders() => fetchOrdersWithItems(showLoading: false);

  void changeFilter(OrderStatus? status) {
    if (state is! OrderLoaded) return;

    final current = state as OrderLoaded;
    emit(
      OrderLoaded(
        allOrders: current.allOrders,
        selectedStatus: status, // null = show all
      ),
    );
  }

  Future<void> paySingleOrder(
    String orderId,
    String payment,
    int totalAmount,
  ) async {
    emit(OrderLoading(msg: "process payment..."));
    try {
      var driverResponse = await supabase
          .from('drivers')
          .select()
          .eq('availability_status', true)
          .limit(1)
          .single();
      print(driverResponse);
      await supabase
          .from('orders')
          .update({'order_status': 'confirmed'})
          .eq('order_id', orderId);
      // .eq('order_status', OrderStatus.pending.value);
      await supabase.from('delivery').insert({
        'order_id': orderId,
        'driver_id': driverResponse["driver_id"],
        'delivery_status': "on_the_way",
        'estimated_time': DateTime.now()
            .add(Duration(minutes: 30))
            .toIso8601String(),
        'actual_time': DateTime.now()
            .add(Duration(minutes: 40))
            .toIso8601String(),
      });
      await supabase.from('payments').insert({
        'order_id': orderId,
        'payment_method': payment,
        'payment_status': "paid",
        'transaction_id': 'TXN${DateTime.now().millisecondsSinceEpoch}',
        'amount': totalAmount,
      });
      fetchOrdersWithItems(showLoading: false);
    } catch (e) {
      emit(OrderError('Batch payment failed: ${e.toString()}'));
    }
  }

  Future<void> payAllPendingOrders(String payment) async {
    final loadedState = state as OrderLoaded;
    final pendingOrders = loadedState.filteredOrders
        .where((owi) => owi.order.orderStatus == OrderStatus.pending.name)
        .toList();

    if (pendingOrders.isEmpty) return;
    emit(OrderLoading(msg: "process payment..."));
    try {
      final userId = supabase.auth.currentUser!.id;
      var driverResponse = await supabase
          .from('drivers')
          .select()
          .eq('availability_status', true)
          .limit(1)
          .single();
      print(driverResponse);
      await supabase
          .from('orders')
          .update({'order_status': OrderStatus.confirmed.name})
          .eq('user_id', userId)
          .eq('order_status', OrderStatus.pending.name);
      for (var ord in pendingOrders) {
        await supabase.from('delivery').insert({
          'order_id': ord.order.id,
          'driver_id': driverResponse["driver_id"],
          'delivery_status': "pending",
          'estimated_time': DateTime.now()
              .add(Duration(minutes: 30))
              .toIso8601String(),
          'actual_time': DateTime.now()
              .add(Duration(minutes: 40))
              .toIso8601String(),
        });
      }
      for (var ord in pendingOrders) {
        await supabase.from('payments').insert({
          'order_id': ord.order.id,
          'payment_method': payment,
          'payment_status': "paid",
          'transaction_id': 'TXN${DateTime.now().millisecondsSinceEpoch}',
          'amount': ord.order.totalAmount,
        });
      }
      fetchOrdersWithItems(showLoading: false);
    } catch (e) {
      // Rollback
      emit(loadedState);
      emit(OrderError('Batch payment failed: ${e.toString()}'));
    }
  }
}

import 'package:foody/core/enums/order_status.dart';
import 'package:foody/features/orders/bloc/order_with_item.dart';

abstract class OrderState {}

class OrderLoading extends OrderState {
  final String msg;
  OrderLoading({this.msg = 'Loading orders...'});
}

class OrderLoaded extends OrderState {
  final List<OrderWithItems> allOrders;
  final OrderStatus? selectedStatus;

  OrderLoaded({required this.allOrders, this.selectedStatus});

  List<OrderWithItems> get filteredOrders {
    if (selectedStatus == null) return allOrders;
    return allOrders
        .where((o) => o.order.orderStatus == selectedStatus!.name)
        .toList();
  }
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

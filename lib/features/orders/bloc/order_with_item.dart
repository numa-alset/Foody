import 'package:foody/core/models/order.dart';
import 'package:foody/core/models/order_item.dart';

class OrderWithItems {
  final Order order;
  final List<OrderItem> items;

  OrderWithItems({required this.order, required this.items});
}

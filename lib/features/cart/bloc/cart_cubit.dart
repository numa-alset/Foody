import 'package:flutter/cupertino.dart';
import 'package:foody/core/models/cart_item.dart';
import 'package:foody/core/models/order.dart';
import 'package:foody/core/supabase/supabase_client.dart';
import 'package:foody/features/cart/bloc/cart_state.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CartCubit extends HydratedCubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(CartItem item) {
    final items = [...state.items];
    final index = items.indexWhere((e) => e.menuId == item.menuId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(item);
    }

    emit(CartState(items: items));
  }

  void removeFromCart(String menuId) {
    emit(
      CartState(items: state.items.where((e) => e.menuId != menuId).toList()),
    );
  }

  void increment(String menuId) => _update(menuId, 1);
  void decrement(String menuId) => _update(menuId, -1);

  void _update(String menuId, int change) {
    final items = [...state.items];
    final index = items.indexWhere((e) => e.menuId == menuId);
    if (index == -1) return;

    final newQty = items[index].quantity + change;
    if (newQty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: newQty);
    }

    emit(CartState(items: items));
  }

  int totalItems() {
    return state.items.fold(0, (sum, item) => sum + item.quantity);
  }

  void clearCart() => emit(const CartState());

  // invoke supabase function to add new order
  Future<void> addNewOrder(BuildContext context) async {
    context.pop();
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      final userId = supabase.auth.currentUser!.id;
      final Map<String, List<CartItem>> groupedItemsByRestaurant = {};

      for (final item in state.items) {
        groupedItemsByRestaurant
            .putIfAbsent(item.restaurantId, () => [])
            .add(item);
      }

      final Map<String, String> restaurantIdToOrderId = {};

      // Create orders per restaurant
      for (final entry in groupedItemsByRestaurant.entries) {
        final restaurantId = entry.key;
        final items = entry.value;

        final totalAmount = items.fold<double>(
          0.0,
          (sum, item) => sum + item.totalPrice,
        );

        final orderId = await _sendSupaRequestToCreateOrder(
          userId,
          restaurantId,
          totalAmount,
        );

        restaurantIdToOrderId[restaurantId] = orderId;
      }

      // 2️⃣ Create order items
      for (final item in state.items) {
        final orderId = restaurantIdToOrderId[item.restaurantId];

        if (orderId == null) {
          throw Exception(
            "Order not found for restaurant ${item.restaurantId}",
          );
        }

        await _sendSupaRequestToCreateItemOrder(
          orderId,
          item.menuId,
          item.quantity,
          item.price,
        );
      }
      clearCart();
      emit(state.copyWith(status: CartStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<String> _sendSupaRequestToCreateOrder(
    String userId,
    String restaurantId,
    double amount,
  ) async {
    try {
      final order = await supabase
          .from('orders')
          .insert({
            'user_id': userId,
            'restaurant_id': restaurantId,
            'total_amount': amount,
          })
          .select()
          .single();

      return Order.fromJson(order).id;
    } catch (e) {
      throw Exception("Error creating order: $e");
    }
  }

  Future<void> _sendSupaRequestToCreateItemOrder(
    orderId,
    menuId,
    quantity,
    price,
  ) async {
    await supabase.from("order_items").insert({
      "order_id": orderId,
      "menu_id": menuId,
      "quantity": quantity,
      "price": price,
    });
  }

  /// 🔐 Hydrated overrides
  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      return CartState.fromJson(json);
    } catch (_) {
      return const CartState();
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    return state.toJson();
  }
}

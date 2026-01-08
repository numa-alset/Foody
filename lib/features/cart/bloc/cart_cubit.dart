import 'package:foody/core/models/cart_item.dart';
import 'package:foody/features/cart/bloc/cart_state.dart';
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

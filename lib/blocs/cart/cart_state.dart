import '../../models/cart_model.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;

  CartLoaded(List<CartItem> items)
      : cartItems = List.unmodifiable(items),
        totalPrice = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  List<CartItem> get items => cartItems; // Getter for cart items
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

import '../../models/cart_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {
  final List<CartItem>? preloadedItems;
  LoadCart({this.preloadedItems});
}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final CartItem item;
  RemoveFromCart(this.item);
}

class IncreaseQuantity extends CartEvent {
  final CartItem item;
  IncreaseQuantity(this.item);
}

class DecreaseQuantity extends CartEvent {
  final CartItem item;
  DecreaseQuantity(this.item);
}

class ClearCart extends CartEvent {} // New event to clear the cart

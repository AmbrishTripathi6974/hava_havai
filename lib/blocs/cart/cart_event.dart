
import '../../models/cart_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

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

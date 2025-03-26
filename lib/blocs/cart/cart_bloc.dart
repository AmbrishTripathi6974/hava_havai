import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoaded([])) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoaded(_getCartItems()));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingCart = _getCartItems();
    final index = existingCart.indexWhere((item) => item.id == event.item.id);

    final updatedCart = List<CartItem>.from(existingCart);
    if (index != -1) {
      updatedCart[index] = updatedCart[index].copyWith(quantity: updatedCart[index].quantity + 1);
    } else {
      updatedCart.add(event.item);
    }
    emit(CartLoaded(updatedCart));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedCart = _getCartItems().where((item) => item.id != event.item.id).toList();
    emit(CartLoaded(updatedCart));
  }

  void _onIncreaseQuantity(IncreaseQuantity event, Emitter<CartState> emit) {
    final updatedCart = _getCartItems().map((item) {
      return item.id == event.item.id ? item.copyWith(quantity: item.quantity + 1) : item;
    }).toList();
    emit(CartLoaded(updatedCart));
  }

  void _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) {
    final updatedCart = _getCartItems()
        .map((item) => item.id == event.item.id ? item.copyWith(quantity: item.quantity - 1) : item)
        .where((item) => item.quantity > 0)
        .toList();
    emit(CartLoaded(updatedCart));
  }

  List<CartItem> _getCartItems() {
    return state is CartLoaded ? (state as CartLoaded).cartItems : [];
  }
}
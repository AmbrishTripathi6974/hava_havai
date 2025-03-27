import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartItems = await _getCartFromStorage();
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError("Failed to load cart"));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final List<CartItem> updatedCart = List.from((state as CartLoaded).cartItems);
      final existingIndex = updatedCart.indexWhere((item) => item.id == event.item.id);

      if (existingIndex != -1) {
        updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
          quantity: updatedCart[existingIndex].quantity + 1,
        );
      } else {
        updatedCart.add(event.item);
      }

      await _saveCartToStorage(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final updatedCart = (state as CartLoaded)
          .cartItems
          .where((item) => item.id != event.item.id)
          .toList();

      await _saveCartToStorage(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onIncreaseQuantity(IncreaseQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final updatedCart = (state as CartLoaded).cartItems.map((item) {
        return item.id == event.item.id
            ? item.copyWith(quantity: item.quantity + 1)
            : item;
      }).toList();

      await _saveCartToStorage(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<void> _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final updatedCart = (state as CartLoaded).cartItems
          .map((item) => item.id == event.item.id && item.quantity > 1
              ? item.copyWith(quantity: item.quantity - 1)
              : item)
          .toList();

      await _saveCartToStorage(updatedCart);
      emit(CartLoaded(updatedCart));
    }
  }

  Future<List<CartItem>> _getCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List<dynamic> jsonList = json.decode(cartData);
      return jsonList.map((e) => CartItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> _saveCartToStorage(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = json.encode(cartItems.map((e) => e.toJson()).toList());
    await prefs.setString('cart', cartJson);
  }
}

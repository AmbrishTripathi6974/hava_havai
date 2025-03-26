import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductShimmer extends ProductState {} // ✅ Used only for first load

class ProductLoading extends ProductState {
  final List<Product> existingProducts;
  final bool isFirstFetch;

  const ProductLoading(this.existingProducts, {required this.isFirstFetch});

  @override
  List<Object> get props => [existingProducts, isFirstFetch];
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final bool isPaginating; // ✅ New flag to indicate pagination loading

  const ProductLoaded({
    required this.products,
    required this.hasReachedMax,
    this.isPaginating = false, // ✅ Default is false
  });

  @override
  List<Object> get props => [products, hasReachedMax, isPaginating];
}

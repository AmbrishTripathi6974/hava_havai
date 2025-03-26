import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// ✅ Load Products from API
class LoadProducts extends ProductEvent {
  final List<Product> products;

  LoadProducts({required this.products});

  @override
  List<Object> get props => [products];
}

// ✅ Fetch a Single Product
class LoadProductDetails extends ProductEvent {
  final int productId;

  LoadProductDetails({required this.productId});

  @override
  List<Object> get props => [productId];
}

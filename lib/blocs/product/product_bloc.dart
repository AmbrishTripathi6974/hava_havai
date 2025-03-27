import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';
import '../../models/product_model.dart';
import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  int page = 0;
  final int pageSize = 20;
  bool hasReachedMax = false;
  late Box<Product> productBox;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    productBox = Hive.box<Product>('product_cache');
    on<LoadProducts>(_onLoadProducts, transformer: debounce(Duration(milliseconds: 300)));
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    if (state is ProductLoading || hasReachedMax) return;

    final List<Product> existingProducts = state is ProductLoaded
        ? (state as ProductLoaded).products
        : productBox.values.toList(); // Load from cache

    if (page == 0 && existingProducts.isEmpty) {
      emit(ProductShimmer()); // ✅ Show shimmer only on first load
    }

    try {
      final List<Product> newProducts = await productRepository.fetchProducts(page, pageSize);

      if (newProducts.isEmpty) {
        hasReachedMax = true;
      }

      final updatedProducts = {...existingProducts, ...newProducts}.toList(); // Remove duplicates
      emit(ProductLoaded(products: updatedProducts, hasReachedMax: hasReachedMax));

      if (newProducts.isNotEmpty) {
        page++;
        final existingIds = productBox.values.map((p) => p.id).toSet();
        final uniqueNewProducts = newProducts.where((p) => !existingIds.contains(p.id)).toList();
        productBox.addAll(uniqueNewProducts); // Cache only unique products
      }
    } catch (error) {
      emit(ProductLoaded(products: existingProducts, hasReachedMax: hasReachedMax));
    }
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

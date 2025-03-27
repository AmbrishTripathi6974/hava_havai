import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/product_model.dart';
import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  int page = 0;
  final int pageSize = 10;
  bool hasReachedMax = false;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts, transformer: debounce(Duration(milliseconds: 300)));
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    if (state is ProductLoading || hasReachedMax) return;

    final List<Product> existingProducts =
        state is ProductLoaded ? (state as ProductLoaded).products : [];

    if (page == 0 && existingProducts.isEmpty) {
      emit(ProductShimmer()); // ✅ Show shimmer only on first load
    }

    try {
      final List<Product> newProducts =
          await productRepository.fetchProducts(page, pageSize);

      if (newProducts.isEmpty) {
        hasReachedMax = true;
      }

      emit(ProductLoaded(
        products: [...existingProducts, ...newProducts],
        hasReachedMax: hasReachedMax,
      ));

      if (newProducts.isNotEmpty) page++;
    } catch (error) {
      emit(ProductLoaded(
        products: existingProducts,
        hasReachedMax: hasReachedMax,
      ));
    }
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

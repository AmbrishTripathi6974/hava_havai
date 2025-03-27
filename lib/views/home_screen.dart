import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cart_model.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../widgets/product_tile.dart';
import '../widgets/shimmer_widget.dart';
import 'cart_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late ProductBloc productBloc;
  Timer? _debounce;
  late final Widget _cachedShimmerGrid;

  @override
  void initState() {
    super.initState();
    productBloc = context.read<ProductBloc>();
    productBloc.add(LoadProducts(products: []));
    _scrollController.addListener(_onScroll);

    /// ✅ Cache the shimmer grid UI
    _cachedShimmerGrid = const ShimmerLoadingGrid();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (productBloc.state is ProductLoaded &&
            !(productBloc.state as ProductLoaded).hasReachedMax) {
          productBloc.add(LoadProducts(products: (productBloc.state as ProductLoaded).products));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Catalogue",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent.shade100,
        elevation: 0,
        actions: [
          IconButton(
            icon: BlocSelector<CartBloc, CartState, int>(
              selector: (state) => (state is CartLoaded) ? state.cartItems.length : 0,
              builder: (context, itemCount) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart, size: 28),
                    if (itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                          child: Text(
                            itemCount.toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProductInitial || state is ProductShimmer) {
            return _cachedShimmerGrid; // ✅ Cached shimmer UI
          } else if (state is ProductLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                ),
                itemCount: state.hasReachedMax ? state.products.length : state.products.length + 2,
                itemBuilder: (context, index) {
                  if (index < state.products.length) {
                    final product = state.products[index];
                    return ProductTile(
                      imageUrl: product.thumbnail,
                      title: product.title,
                      brand: product.brand,
                      oldPrice: product.price,
                      newPrice: product.price * (1 - (product.discountPercentage / 100)),
                      discount: product.discountPercentage,
                      onAddToCart: () {
                        context.read<CartBloc>().add(
                              AddToCart(
                                CartItem(
                                  id: product.id.toString(),
                                  imageUrl: product.thumbnail,
                                  title: product.title,
                                  description: product.brand,
                                  price: product.price * (1 - (product.discountPercentage / 100)),
                                  quantity: 1,
                                ),
                              ),
                            );
                      },
                    );
                  } else {
                    return const ShimmerLoadingGrid(itemCount: 2, isPaginating: true);
                  }
                },
              ),
            );
          } else {
            return const Center(child: Text("No products available", style: TextStyle(fontSize: 16)));
          }
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../widgets/product_tile.dart';
import '../widgets/shimmer_widget.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late ProductBloc productBloc;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    productBloc = context.read<ProductBloc>();
    _loadCachedProducts(); // ✅ Load products from cache first
    productBloc.add(LoadProducts(products: []));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (productBloc.state is ProductLoaded &&
            !(productBloc.state as ProductLoaded).hasReachedMax) {
          productBloc.add(LoadProducts(
              products: (productBloc.state as ProductLoaded).products));
        }
      }
    });
  }

  Future<void> _loadCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsData = prefs.getString('cached_products');

    if (productsData != null) {
      final List<dynamic> jsonList = json.decode(productsData);
      final cachedProducts = jsonList.map((e) => Product.fromJson(e)).toList();

      if (cachedProducts.isNotEmpty) {
        productBloc.add(LoadProducts(products: cachedProducts));
      }
    }
  }

  Future<void> _saveProductsToCache(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = json.encode(products.map((e) => e.toJson()).toList());
    await prefs.setString('cached_products', productsJson);
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
              selector: (state) =>
                  (state is CartLoaded) ? state.cartItems.length : 0,
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
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: Text(
                            itemCount.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductShimmer) {
            /// ✅ Show Lottie animation for first-time loading
            return Center(
                child: Lottie.asset(
              'assets/shimmer.json',
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.contain,
            ));
          } else if (state is ProductLoaded) {
            _saveProductsToCache(
                state.products); // ✅ Save fetched products to cache

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: MasonryGridView.builder(
                controller: _scrollController,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Staggered layout with 2 columns
                ),
                itemCount: state.hasReachedMax
                    ? state.products.length
                    : state.products.length + 2,
                itemBuilder: (context, index) {
                  if (index < state.products.length) {
                    final product = state.products[index];
                    return ProductTile(
                      imageUrl: product.thumbnail,
                      title: product.title,
                      brand: product.brand,
                      oldPrice: product.price,
                      newPrice: product.price *
                          (1 - (product.discountPercentage / 100)),
                      discount: product.discountPercentage,
                      onAddToCart: () {
                        context.read<CartBloc>().add(
                              AddToCart(
                                CartItem(
                                  id: product.id.toString(),
                                  imageUrl: product.thumbnail,
                                  title: product.title,
                                  description: product.brand,
                                  price: product.price *
                                      (1 - (product.discountPercentage / 100)),
                                  quantity: 1,
                                ),
                              ),
                            );
                      },
                    );
                  } else {
                    /// ✅ Show shimmer only during pagination
                    return const ShimmerLoadingGrid(isPaginating: true);
                  }
                },
              ),
            );
          } else {
            return const Center(
                child: Text("No products available",
                    style: TextStyle(fontSize: 16)));
          }
        },
      ),
    );
  }
}

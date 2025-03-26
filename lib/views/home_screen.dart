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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts(products: []));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final productBloc = context.read<ProductBloc>();
      if (productBloc.state is ProductLoaded) {
        final currentState = productBloc.state as ProductLoaded;
        if (!currentState.hasReachedMax) {
          productBloc.add(LoadProducts(products: currentState.products));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Catalogue",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent.shade100,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartLoaded && state.cartItems.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            state.cartItems.length.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductShimmer) {
            return const ShimmerLoadingGrid();
          } else if (state is ProductLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
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
                    return const ShimmerLoadingGrid(
                        itemCount: 2, isPaginating: true);
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

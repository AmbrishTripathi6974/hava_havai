import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            return state.cartItems.isEmpty
                ? const Center(
                    child: Text(
                      "Your cart is empty!",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = state.cartItems[index];
                            return CartTile(
                              imageUrl: item.imageUrl,
                              title: item.title,
                              description: item.description,
                              price: item.price,
                              quantity: item.quantity,
                              onRemove: () {
                                context.read<CartBloc>().add(RemoveFromCart(item));
                              },
                              onIncrease: () {
                                context.read<CartBloc>().add(IncreaseQuantity(item));
                              },
                              onDecrease: () {
                                context.read<CartBloc>().add(DecreaseQuantity(item));
                              },
                            );
                          },
                        ),
                      ),
                      _buildBottomSection(context, state.totalPrice, state.cartItems.length),
                    ],
                  );
          } else {
            return const Center(child: Text("Failed to load cart"));
          }
        },
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, double totalPrice, int itemCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.pink.shade50, // Light pink background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Amount Price",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                "₹${totalPrice.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink, // Pink button color
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Check Out",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Text(
                    itemCount.toString(),
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

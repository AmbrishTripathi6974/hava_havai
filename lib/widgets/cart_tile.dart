import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 14),

          /// Product Details (Title, Description, Price & Quantity Row)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title & Remove Button Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    /// Remove Button (X)
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                /// Product Description
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 6),

                /// Price & Quantity Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Price
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),

                    /// Quantity Selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Decrease Button (-)
                          IconButton(
                            onPressed: onDecrease,
                            icon: const Icon(Icons.remove, size: 14),
                            color: Colors.black,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 14, minHeight: 14),
                          ),

                          /// Quantity Count
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              quantity.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          /// Increase Button (+)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: IconButton(
                              onPressed: onIncrease,
                              icon: const Icon(Icons.add,
                                  size: 14, color: Colors.white),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 14, minHeight: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

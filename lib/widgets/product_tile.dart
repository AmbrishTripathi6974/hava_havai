import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String brand;
  final double oldPrice;
  final double newPrice;
  final double discount;
  final VoidCallback onAddToCart;

  const ProductTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.brand,
    required this.oldPrice,
    required this.newPrice,
    required this.discount,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * 0.45,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Product Image with "Add" Button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 160,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder.png',
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 90,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            "Add",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// Product Details
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product Name
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// Brand Name
                    Text(
                      brand,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    /// Price & Discount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Old Price (Strikethrough)
                        Text(
                          "₹${oldPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),

                        /// New Price (Bold)
                        Text(
                          "₹${newPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 6),
                      ],
                    ),

                    /// Discount Percentage
                    Text(
                      "${discount.toStringAsFixed(2)}% OFF",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

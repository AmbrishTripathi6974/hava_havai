import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer effect for a single product tile
class ShimmerProductTile extends StatelessWidget {
  const ShimmerProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image shimmer
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Title shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 16,
                width: double.infinity,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 6),

            /// Brand shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 14,
                width: 80,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            /// Price shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    height: 14,
                    width: 40,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 14,
                    width: 50,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            /// Discount shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 14,
                width: 50,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
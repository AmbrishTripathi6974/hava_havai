import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingGrid extends StatelessWidget {
  final int itemCount;
  final bool isPaginating;

  const ShimmerLoadingGrid({
    super.key,
    this.itemCount = 6,
    this.isPaginating = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shrinkWrap: true,
      physics: isPaginating ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // 2 items per row
        childAspectRatio: 0.65, // Aspect ratio matching real cards
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: itemCount, // Show 6 shimmer items
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 180,  // Set a height
          width: double.infinity,  // Make it fill the grid cell
        ),
      ),
    );
  }
}

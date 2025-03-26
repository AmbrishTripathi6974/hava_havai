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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: isPaginating ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Ensures 2 items per row
          childAspectRatio: 0.65, 
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildShimmerItem(),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

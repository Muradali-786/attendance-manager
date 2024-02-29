import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingEffect extends StatelessWidget {
  final double height;
  const ShimmerLoadingEffect({Key? key, this.height = 84}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        itemCount: 6, // Number of shimmer items you want to show
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),

            height: height,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
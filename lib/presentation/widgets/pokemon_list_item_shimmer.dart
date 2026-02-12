import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PokemonListShimmer extends StatelessWidget {
  const PokemonListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 1.3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 8, // Show a few placeholder items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 50,
                      height: 14, // Type chip placeholder
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

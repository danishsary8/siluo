import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'editorial_shimmer_box.dart';

/// Shimmering placeholder in the shape of a two-column product grid, shown
/// while the catalogue loads so the layout doesn't jump when cards arrive.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key, this.itemCount = 4});

  /// Number of placeholder cards to show.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 14,
        runSpacing: 16,
        children: [
          for (var i = 0; i < itemCount; i++)
            LayoutBuilder(
              builder: (context, _) {
                final width = (MediaQuery.sizeOf(context).width - 40 - 14) / 2;
                return Container(
                  width: width,
                  padding: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditorialShimmerBox(height: i.isEven ? 220 : 180, borderRadius: BorderRadius.zero),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EditorialShimmerBox(width: 50, height: 10),
                            SizedBox(height: 8),
                            EditorialShimmerBox(height: 12),
                            SizedBox(height: 8),
                            EditorialShimmerBox(width: 60, height: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

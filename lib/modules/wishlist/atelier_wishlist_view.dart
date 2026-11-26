import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/atelier_product_card.dart';

class AtelierWishlistView extends StatelessWidget {
  const AtelierWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final wishlisted = controller.wishlistProducts;

          if (wishlisted.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.heart,
                    size: 52,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved pieces yet',
                    style: AppTypography.sectionTitle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart on any piece to save it to your wishlist.',
                    style: AppTypography.body(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    ),
                    onPressed: () => controller.switchTab(0),
                    child: Text(
                      'EXPLORE COLLECTION',
                      style: AppTypography.buttonLabel(
                        color: isDark ? AppColors.canvasDark : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your wishlist',
                        style: AppTypography.sectionTitle(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        '${wishlisted.length} ${wishlisted.length == 1 ? 'piece' : 'pieces'}',
                        style: AppTypography.headingMeta(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Fixed height that fits AtelierProductCard (220px image + details);
                    // an aspect ratio clipped the price and add-to-bag row.
                    mainAxisExtent: 356,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AtelierProductCard(product: wishlisted[index]);
                    },
                    childCount: wishlisted.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

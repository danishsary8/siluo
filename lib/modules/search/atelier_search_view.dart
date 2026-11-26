import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/load_status.dart';
import '../../shared/widgets/load_error_view.dart';
import '../../shared/widgets/product_grid_skeleton.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/atelier_product_card.dart';
import '../visual_search/atelier_visual_search_view.dart';
import '../try_on/atelier_virtual_mirror_view.dart';

class AtelierSearchView extends StatefulWidget {
  const AtelierSearchView({super.key});

  @override
  State<AtelierSearchView> createState() => _AtelierSearchViewState();
}

class _AtelierSearchViewState extends State<AtelierSearchView> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _recentSearches = [
    'Nike Sneakers',
    "Levi's 501",
    'Zara Blazer',
    'Mango Dress',
    'Denim Jacket',
    'Streetwear Hoodie',
    'Wide Leg Pants',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet(BuildContext context, AtelierController controller, bool isDark) {
    HapticService.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.72,
              decoration: BoxDecoration(
                color: isDark ? AppColors.canvasDark : AppColors.surfaceLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Handle pill
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter & sort',
                          style: AppTypography.sectionTitle(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            HapticService.light();
                            controller.priceRange.value = const RangeValues(10, 200);
                            controller.selectedFilterSizes.clear();
                            controller.sortBy.value = 'Featured';
                            setSheetState(() {});
                          },
                          child: Text(
                            'Reset All',
                            style: TextStyle(
                              color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Filter Content
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Price Range
                        Text(
                          'Price range',
                          style: AppTypography.editorialHeading(
                            fontSize: 20,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${controller.priceRange.value.start.round()}',
                              style: AppTypography.priceTag(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              '\$${controller.priceRange.value.end.round()}',
                              style: AppTypography.priceTag(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: controller.priceRange.value,
                          min: 100,
                          max: 600,
                          divisions: 10,
                          activeColor: isDark ? Colors.white : AppColors.ctaDark,
                          inactiveColor: isDark ? Colors.white24 : Colors.black12,
                          onChanged: (vals) {
                            setSheetState(() {
                              controller.priceRange.value = vals;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // Size multi-select chips
                        Text(
                          'Sizes',
                          style: AppTypography.editorialHeading(
                            fontSize: 20,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          children: ['XS', 'S', 'M', 'L', 'XL'].map((size) {
                            final isSelected = controller.selectedFilterSizes.contains(size);
                            return GestureDetector(
                              onTap: () {
                                HapticService.selection();
                                setSheetState(() {
                                  if (isSelected) {
                                    controller.selectedFilterSizes.remove(size);
                                  } else {
                                    controller.selectedFilterSizes.add(size);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? Colors.white : AppColors.ctaDark)
                                      : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? (isDark ? AppColors.canvasDark : Colors.white)
                                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Sort By
                        Text(
                          'Sort by',
                          style: AppTypography.editorialHeading(
                            fontSize: 20,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            'Featured',
                            'Price: Low to High',
                            'Price: High to Low',
                            'Rating'
                          ].map((sortOption) {
                            final isSelected = controller.sortBy.value == sortOption;
                            return GestureDetector(
                              onTap: () {
                                HapticService.selection();
                                setSheetState(() {
                                  controller.sortBy.value = sortOption;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? Colors.white : AppColors.ctaDark)
                                      : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                                  ),
                                ),
                                child: Text(
                                  sortOption,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? (isDark ? AppColors.canvasDark : Colors.white)
                                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Apply CTA
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                          foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          HapticService.success();
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          'APPLY FILTERS (${controller.filteredProducts.length} ITEMS)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: isDark ? AppColors.canvasDark : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Search Input Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            size: 18,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search collection, fabric, style...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textLightMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (val) {
                                controller.searchQuery.value = val;
                              },
                            ),
                          ),
                          if (_searchCtrl.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchCtrl.clear();
                                controller.searchQuery.value = '';
                              },
                              child: Icon(
                                CupertinoIcons.clear_circled_solid,
                                size: 18,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () {
                                HapticService.light();
                                Get.to(() => const AtelierVisualSearchView());
                              },
                              child: const Icon(
                                CupertinoIcons.camera_viewfinder,
                                size: 20,
                                color: AppColors.champagneGold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter Button
                  GestureDetector(
                    onTap: () => _openFilterBottomSheet(context, controller, isDark),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.slider_horizontal_3,
                          size: 20,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recent Searches Chips
            if (_searchCtrl.text.isEmpty)
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _recentSearches.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final query = _recentSearches[index];
                    return GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        _searchCtrl.text = query;
                        controller.searchQuery.value = query;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                          ),
                        ),
                        child: Text(
                          query,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (_searchCtrl.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticService.light();
                          Get.to(() => const AtelierVisualSearchView());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A1631) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.camera_viewfinder,
                                  size: 14,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Visual search',
                                      style: AppTypography.microTag(color: AppColors.champagneGold),
                                    ),
                                    Text(
                                      'Search with a photo',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticService.light();
                          Get.to(() => const AtelierVirtualMirrorView());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A1631) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.champagneGold.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.viewfinder,
                                  size: 14,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Try it on',
                                      style: AppTypography.microTag(color: AppColors.champagneGold),
                                    ),
                                    Text(
                                      'Virtual mirror',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Results Grid
            Expanded(
              child: Obx(() {
                final results = controller.filteredProducts;
                final status = controller.catalogStatus.value;

                if (controller.allProducts.isEmpty && status == LoadStatus.loading) {
                  return const SingleChildScrollView(
                    padding: EdgeInsets.only(top: 16),
                    child: ProductGridSkeleton(),
                  );
                }
                if (controller.allProducts.isEmpty && status == LoadStatus.error) {
                  return Center(
                    child: SingleChildScrollView(
                      child: LoadErrorView(
                        title: 'Couldn\'t load the shop',
                        message: controller.catalogError.value ?? '',
                        onRetry: controller.loadCatalog,
                      ),
                    ),
                  );
                }

                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.search,
                          size: 48,
                          color: isDark ? Colors.white30 : Colors.black26,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No pieces match your search',
                          style: AppTypography.body(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Fixed height that fits AtelierProductCard (220px image + details);
                    // an aspect ratio clipped the price and add-to-bag row.
                    mainAxisExtent: 356,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return AtelierProductCard(product: results[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

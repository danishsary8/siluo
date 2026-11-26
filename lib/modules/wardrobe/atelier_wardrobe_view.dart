import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../product_detail/atelier_pdp_view.dart';

class WardrobeGarment {
  final Product product;
  final String dateAcquired;
  final int wearCount;
  final String careStatus;
  final String hangerType;

  const WardrobeGarment({
    required this.product,
    required this.dateAcquired,
    required this.wearCount,
    required this.careStatus,
    this.hangerType = 'Brushed Brass & Cedar',
  });
}

class AtelierWardrobeView extends StatefulWidget {
  const AtelierWardrobeView({super.key});

  @override
  State<AtelierWardrobeView> createState() => _AtelierWardrobeViewState();
}

class _AtelierWardrobeViewState extends State<AtelierWardrobeView> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = const ['All Pieces', 'Outerwear', 'Tailoring & Silk', 'Knitwear'];

  late List<WardrobeGarment> _wardrobeItems;
  final Set<String> _selectedForStyling = {};
  bool _isSuggestingPairing = false;

  @override
  void initState() {
    super.initState();
    final allProducts = AtelierController.to.allProducts;
    _wardrobeItems = [
      WardrobeGarment(
        product: allProducts[0], // Double-breasted coat
        dateAcquired: 'October 2026',
        wearCount: 7,
        careStatus: 'Next cedar steam in 12 days',
      ),
      WardrobeGarment(
        product: allProducts[1], // Silk slip dress
        dateAcquired: 'September 2026',
        wearCount: 4,
        careStatus: 'Pristine • Stored in breathable linen',
      ),
      WardrobeGarment(
        product: allProducts[2], // Cashmere knit
        dateAcquired: 'August 2026',
        wearCount: 11,
        careStatus: 'Freshly pressed with cedar blocks',
      ),
      if (allProducts.length > 4)
        WardrobeGarment(
          product: allProducts[4],
          dateAcquired: 'July 2026',
          wearCount: 5,
          careStatus: 'Pristine condition',
        ),
    ];
  }

  void _toggleSelectForStyling(String productId) {
    HapticService.selection();
    setState(() {
      if (_selectedForStyling.contains(productId)) {
        _selectedForStyling.remove(productId);
      } else {
        if (_selectedForStyling.length < 3) {
          _selectedForStyling.add(productId);
        } else {
          Get.snackbar(
            'Ensemble Limit',
            'Select up to 3 wardrobe pieces to harmonize with new runway arrivals.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
      }
    });
  }

  void _handleSuggestPairing() {
    HapticService.heavy();
    setState(() => _isSuggestingPairing = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _isSuggestingPairing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredItems = _wardrobeItems.where((item) {
      if (_selectedFilterIndex == 0) return true;
      if (_selectedFilterIndex == 1) return item.product.category.toLowerCase().contains('outerwear');
      if (_selectedFilterIndex == 2) return item.product.category.toLowerCase().contains('dress') || item.product.category.toLowerCase().contains('silk');
      return item.product.category.toLowerCase().contains('knit');
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'LE DRESSING PRIVÉ',
          style: AppTypography.brandLogo(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.sparkles,
              color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
            ),
            onPressed: () {
              HapticService.light();
              Get.snackbar(
                'Care Butler',
                'All 4 pieces in your wardrobe are currently in optimal storage conditions.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: isDark ? Colors.black87 : Colors.white,
                colorText: isDark ? Colors.white : Colors.black,
                margin: const EdgeInsets.all(16),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 160),
            children: [
              // Wardrobe Header & Brass Rail Graphic
              Text(
                'YOUR DIGITAL ATELIER CAPSULE',
                style: AppTypography.microTag(color: AppColors.champagneGold),
              ),
              const SizedBox(height: 4),
              Text(
                'Curated wardrobe vault with active care metrics and AI ensemble matchmaking.',
                style: AppTypography.body(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),

              // Brass Hanging Rail Representation
              Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8C7350),
                      AppColors.champagneGold,
                      Color(0xFFEAD9BF),
                      AppColors.champagneGold,
                      Color(0xFF8C7350),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.champagneGold.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category Filter Chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        setState(() => _selectedFilterIndex = index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.white : AppColors.ctaDark)
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppColors.canvasDark : Colors.white)
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Hanging Garments Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isStylingSelected = _selectedForStyling.contains(item.product.id);

                  return GestureDetector(
                    onTap: () => _toggleSelectForStyling(item.product.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isStylingSelected
                              ? AppColors.champagneGold
                              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          width: isStylingSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: [
                          if (isStylingSelected)
                            BoxShadow(
                              color: AppColors.champagneGold.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hanger & Thumbnail Top
                          Stack(
                            children: [
                              // Hanger Graphic Top Notch
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 44,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC5A880),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 20, 10, 8),
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  item.product.primaryImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Selection Checkmark
                              Positioned(
                                top: 26,
                                right: 16,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isStylingSelected
                                        ? AppColors.champagneGold
                                        : Colors.black.withValues(alpha: 0.5),
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                  child: isStylingSelected
                                      ? const Icon(CupertinoIcons.checkmark, size: 14, color: Colors.black)
                                      : null,
                                ),
                              ),
                            ],
                          ),

                          // Metadata
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.productTitle(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Worn ${item.wearCount} times',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.champagneGold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.careStatus,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Complementary Runway Suggestion (AI Matcher result)
              if (_selectedForStyling.isNotEmpty) ...[
                Text(
                  'COMPLEMENTARY RUNWAY PAIRING',
                  style: AppTypography.microTag(color: AppColors.champagneGold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1631) : const Color(0xFFF5F2FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          controller.allProducts.last.primaryImage,
                          width: 60,
                          height: 76,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '98% HARMONY MATCH',
                              style: AppTypography.microTag(color: AppColors.inStockGreen),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller.allProducts.last.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complements your selected pieces with rich tonal contrast.',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.arrow_right_circle_fill, color: AppColors.champagneGold, size: 28),
                        onPressed: () {
                          HapticService.light();
                          Get.to(() => AtelierPdpView(product: controller.allProducts.last));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Sticky Bottom Styling Action Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: LiquidGlassContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: 24,
              borderColor: AppColors.champagneGold.withValues(alpha: 0.4),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'ACTIVE SELECTION',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.champagneGold),
                      ),
                      Text(
                        '${_selectedForStyling.length} of 3 Pieces',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedForStyling.isEmpty
                            ? (isDark ? Colors.white12 : Colors.black12)
                            : (_isSuggestingPairing ? AppColors.inStockGreen : AppColors.champagneGold),
                        foregroundColor: Colors.black,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: _selectedForStyling.isEmpty ? null : _handleSuggestPairing,
                      icon: Icon(
                        _isSuggestingPairing ? CupertinoIcons.checkmark_alt : CupertinoIcons.wand_stars,
                        size: 16,
                      ),
                      label: Text(
                        _isSuggestingPairing
                            ? 'AI HARMONY COMPUTED'
                            : 'AI CAPSULE STYLIST',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

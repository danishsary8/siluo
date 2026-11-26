import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';
import '../product_detail/atelier_pdp_view.dart';
import '../../shared/widgets/image_fallback.dart';

class AtelierGiftingView extends StatefulWidget {
  const AtelierGiftingView({super.key});

  @override
  State<AtelierGiftingView> createState() => _AtelierGiftingViewState();
}

class _AtelierGiftingViewState extends State<AtelierGiftingView> {
  int _selectedPersonaIndex = 0;
  double _maxBudget = 800.0;
  bool _isCuratedAdding = false;

  final List<String> _personas = const [
    'All Recipients',
    'The Minimalist',
    'The Connoisseur',
    'Midnight Soirée',
  ];

  void _handleOneTapGift(Product product) {
    HapticService.heavy();
    setState(() => _isCuratedAdding = true);
    final controller = AtelierController.to;

    // Add product to cart with S size and primary color
    final primaryVariant = product.colorVariants.isNotEmpty
        ? product.colorVariants.first
        : const ProductColorVariant(name: 'Default', color: Colors.black, images: []);
    final size = product.sizes.isNotEmpty ? product.sizes.first : 'One Size';

    controller.addToCart(
      product: product,
      size: size,
      color: primaryVariant,
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isCuratedAdding = false);
        Get.snackbar(
          'Gift Box Curated',
          '${product.title} has been added to your bag with Signature Obsidian Keepsake Packaging.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredProducts = controller.allProducts.where((p) {
      if (p.price > _maxBudget) return false;
      if (_selectedPersonaIndex == 1) return p.category == 'Outerwear' || p.category == 'Knitwear';
      if (_selectedPersonaIndex == 2) return p.category == 'Accessories' || p.category == 'Tailoring';
      if (_selectedPersonaIndex == 3) return p.category == 'Dresses' || p.price > 450;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'L’ART DU CADEAU',
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
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'THE BESPOKE GIFTING CONCIERGE',
            style: AppTypography.microTag(color: AppColors.champagneGold),
          ),
          const SizedBox(height: 4),
          Text(
            'Every gift curated through L’Art du Cadeau arrives in our rigid obsidian presentation box with scented cedar tissue and handwritten calligraphy parchment.',
            style: AppTypography.body(
              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Persona Filter Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _personas.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final isSelected = _selectedPersonaIndex == idx;
                return GestureDetector(
                  onTap: () {
                    HapticService.selection();
                    setState(() => _selectedPersonaIndex = idx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.ctaDark)
                          : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _personas[idx],
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

          // Budget Range Slider
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('BUDGET MAXIMUM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: AppColors.champagneGold)),
                    Obx(() => Text(
                          controller.formatPrice(_maxBudget),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        )),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.champagneGold,
                    inactiveTrackColor: isDark ? Colors.white12 : Colors.black12,
                    thumbColor: AppColors.champagneGold,
                    overlayColor: AppColors.champagneGold.withValues(alpha: 0.2),
                    trackHeight: 3.5,
                  ),
                  child: Slider(
                    value: _maxBudget,
                    min: 200.0,
                    max: 1000.0,
                    divisions: 8,
                    onChanged: (val) {
                      HapticService.selection();
                      setState(() => _maxBudget = val);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Curated Gift Pieces List
          Text(
            '${filteredProducts.length} CURATED GIFT RECOMMENDATIONS',
            style: AppTypography.microTag(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),

          ...filteredProducts.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => AtelierPdpView(product: p)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        p.primaryImage,
                        width: 76,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const ImageFallback(width: 76, height: 96),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.category.toUpperCase(),
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                              controller.formatPrice(p.price),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.champagneGold,
                              ),
                            )),
                        const SizedBox(height: 8),

                        // 1-Tap Curate & Gift Box Button
                        SizedBox(
                          height: 34,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                              foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: _isCuratedAdding ? null : () => _handleOneTapGift(p),
                            icon: const Icon(CupertinoIcons.gift_fill, size: 13),
                            label: const Text(
                              'BOX & BAG',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

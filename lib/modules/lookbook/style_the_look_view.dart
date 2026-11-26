import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../../shared/widgets/editorial_shimmer_box.dart';

class StyleTheLookView extends StatefulWidget {
  const StyleTheLookView({super.key});

  @override
  State<StyleTheLookView> createState() => _StyleTheLookViewState();
}

class _StyleTheLookViewState extends State<StyleTheLookView> {
  final PageController _topPageCtrl = PageController(viewportFraction: 0.75);
  final PageController _midPageCtrl = PageController(viewportFraction: 0.75);
  final PageController _botPageCtrl = PageController(viewportFraction: 0.75);

  late List<Product> _topPieces;
  late List<Product> _midPieces;
  late List<Product> _botPieces;

  int _selectedTopIndex = 0;
  int _selectedMidIndex = 0;
  int _selectedBotIndex = 0;

  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    final all = AtelierController.to.allProducts;

    _topPieces = all.where((p) => p.category == 'Outerwear' || p.category == 'Knitwear').toList();
    if (_topPieces.isEmpty) _topPieces = all.take(3).toList();

    _midPieces = all.where((p) => p.category == 'Dresses' || p.title.contains('Trouser')).toList();
    if (_midPieces.isEmpty) _midPieces = all.skip(2).take(3).toList();

    _botPieces = all.where((p) => p.category == 'Footwear' || p.category == 'Accessories').toList();
    if (_botPieces.isEmpty) _botPieces = all.skip(4).take(3).toList();
  }

  @override
  void dispose() {
    _topPageCtrl.dispose();
    _midPageCtrl.dispose();
    _botPageCtrl.dispose();
    super.dispose();
  }

  double get _totalEnsemblePrice {
    final top = _topPieces[_selectedTopIndex].price;
    final mid = _midPieces[_selectedMidIndex].price;
    final bot = _botPieces[_selectedBotIndex].price;
    return top + mid + bot;
  }

  void _handleAddEnsemble() {
    HapticService.success();
    final topProd = _topPieces[_selectedTopIndex];
    final midProd = _midPieces[_selectedMidIndex];
    final botProd = _botPieces[_selectedBotIndex];

    final ensembleItems = [
      CartItem(
        id: 'ensemble_top_${DateTime.now().millisecondsSinceEpoch}',
        product: topProd,
        selectedSize: topProd.sizes.isNotEmpty ? topProd.sizes.first : 'One Size',
        selectedColor: topProd.colorVariants.first,
        quantity: 1,
      ),
      CartItem(
        id: 'ensemble_mid_${DateTime.now().millisecondsSinceEpoch + 1}',
        product: midProd,
        selectedSize: midProd.sizes.isNotEmpty ? midProd.sizes.first : 'One Size',
        selectedColor: midProd.colorVariants.first,
        quantity: 1,
      ),
      CartItem(
        id: 'ensemble_bot_${DateTime.now().millisecondsSinceEpoch + 2}',
        product: botProd,
        selectedSize: botProd.sizes.isNotEmpty ? botProd.sizes.first : 'One Size',
        selectedColor: botProd.colorVariants.first,
        quantity: 1,
      ),
    ];

    AtelierController.to.addMultipleToCart(ensembleItems);

    setState(() => _isAdded = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _isAdded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'CURATE ENSEMBLE',
          style: AppTypography.productTitle(
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
              CupertinoIcons.bag,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              controller.switchTab(2); // Jump to Bag
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 140),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE ATELIER LOOKBOOK BUILDER',
                      style: AppTypography.microTag(color: AppColors.champagneGold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Swipe each layer to harmonize your bespoke runway ensemble.',
                      style: AppTypography.body(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 1. Top Tier: Outerwear & Knitwear
              _buildTierHeader('TIER 01: COAT & KNITWEAR', _topPieces[_selectedTopIndex], isDark),
              SizedBox(
                height: 190,
                child: PageView.builder(
                  controller: _topPageCtrl,
                  itemCount: _topPieces.length,
                  onPageChanged: (i) {
                    HapticService.selection();
                    setState(() => _selectedTopIndex = i);
                  },
                  itemBuilder: (context, index) {
                    return _buildPieceCard(_topPieces[index], _selectedTopIndex == index, isDark);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 2. Middle Tier: Dresses & Tailored Trousers
              _buildTierHeader('TIER 02: SILHOUETTES & BOTTOMS', _midPieces[_selectedMidIndex], isDark),
              SizedBox(
                height: 190,
                child: PageView.builder(
                  controller: _midPageCtrl,
                  itemCount: _midPieces.length,
                  onPageChanged: (i) {
                    HapticService.selection();
                    setState(() => _selectedMidIndex = i);
                  },
                  itemBuilder: (context, index) {
                    return _buildPieceCard(_midPieces[index], _selectedMidIndex == index, isDark);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 3. Lower Tier: Footwear & Leathercraft
              _buildTierHeader('TIER 03: FOOTWEAR & LEATHERCRAFT', _botPieces[_selectedBotIndex], isDark),
              SizedBox(
                height: 190,
                child: PageView.builder(
                  controller: _botPageCtrl,
                  itemCount: _botPieces.length,
                  onPageChanged: (i) {
                    HapticService.selection();
                    setState(() => _selectedBotIndex = i);
                  },
                  itemBuilder: (context, index) {
                    return _buildPieceCard(_botPieces[index], _selectedBotIndex == index, isDark);
                  },
                ),
              ),
            ],
          ),

          // Floating Glass Bottom Bar with Ensemble Price & Action
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: LiquidGlassContainer(
              blur: 24,
              borderRadius: 30,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: isDark
                  ? Colors.black.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.9),
              borderColor: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.white.withValues(alpha: 0.9),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMPLETE ENSEMBLE',
                        style: AppTypography.microTag(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                      Obx(() => Text(
                            controller.formatPrice(_totalEnsemblePrice),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAdded
                              ? AppColors.inStockGreen
                              : (isDark ? Colors.white : AppColors.ctaDark),
                          foregroundColor: _isAdded
                              ? Colors.white
                              : (isDark ? AppColors.canvasDark : Colors.white),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: _handleAddEnsemble,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isAdded
                              ? const Row(
                                  key: ValueKey('added'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.checkmark_alt, size: 18),
                                    SizedBox(width: 6),
                                    Flexible(child: Text('Added to bag', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                                  ],
                                )
                              : const Row(
                                  key: ValueKey('buy'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.sparkles, size: 16),
                                    SizedBox(width: 6),
                                    Flexible(child: Text('Shop the look', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                                  ],
                                ),
                        ),
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

  Widget _buildTierHeader(String tierLabel, Product activeProduct, bool isDark) {
    final controller = AtelierController.to;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tierLabel,
            style: AppTypography.microTag(
              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Obx(() => Text(
                '${activeProduct.title} (${controller.formatPrice(activeProduct.price)})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                ),
              )),
          ),
        ],
      ),
    );
  }

  Widget _buildPieceCard(Product product, bool isSelected, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.champagneGold
              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.champagneGold.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.network(
            product.primaryImage,
            width: 120,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const EditorialShimmerBox(
                width: 120,
                height: double.infinity,
                borderRadius: BorderRadius.zero,
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: AppTypography.microTag(color: isDark ? AppColors.textMutedDark : AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(() => Text(
                        AtelierController.to.formatPrice(product.price),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

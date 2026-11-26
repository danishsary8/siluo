import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../../shared/widgets/animated_heart_button.dart';
import '../../shared/widgets/editorial_shimmer_box.dart';
import 'widgets/bespoke_tailor_modal.dart';
import 'widgets/customer_reviews_modal.dart';
import 'widgets/fabric_weave_loupe_modal.dart';
import 'widgets/kinetic_drape_modal.dart';
import 'widgets/turntable_360_viewer.dart';
import '../compare/atelier_compare_view.dart';
import '../customization/atelier_monogram_view.dart';
import '../try_on/atelier_virtual_mirror_view.dart';
import '../../shared/widgets/atelier_product_card.dart';

class AtelierPdpView extends StatefulWidget {
  final Product product;

  const AtelierPdpView({super.key, required this.product});

  @override
  State<AtelierPdpView> createState() => _AtelierPdpViewState();
}

class _AtelierPdpViewState extends State<AtelierPdpView>
    with SingleTickerProviderStateMixin {
  late PageController _galleryPageController;
  late ProductColorVariant _selectedColor;
  late String _selectedSize;

  int _currentGalleryIndex = 0;
  bool _isAddedToBag = false;
  MonogramConfig? _monogramConfig;

  // Double-tap zoom controller & animation
  late final TransformationController _transformationController;
  Animation<Matrix4>? _zoomAnimation;
  late final AnimationController _zoomAnimationController;
  TapDownDetails? _doubleTapDetails;

  // Accordion expansion states
  bool _isFabricExpanded = false;
  bool _isFitExpanded = false;
  bool _isShippingExpanded = false;

  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _galleryPageController = PageController();
    _transformationController = TransformationController();
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformationController.value = _zoomAnimation!.value;
        }
      });

    _selectedColor = widget.product.colorVariants.isNotEmpty
        ? widget.product.colorVariants.first
        : const ProductColorVariant(name: 'Default', color: Colors.black, images: []);
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'One Size';

    AtelierController.to.recordProductView(widget.product);

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final opacity = (offset / 200).clamp(0.0, 1.0);
      if (opacity != _appBarOpacity) {
        setState(() => _appBarOpacity = opacity);
      }
    });
  }

  @override
  void dispose() {
    _galleryPageController.dispose();
    _transformationController.dispose();
    _zoomAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    HapticService.light();
    final isZoomed = !_transformationController.value.isIdentity();
    final Matrix4 end;

    if (isZoomed) {
      end = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? const Offset(200, 240);
      end = Matrix4.identity()
        ..translateByDouble(-position.dx * 1.2, -position.dy * 1.2, 0.0, 1.0)
        ..scaleByDouble(2.2, 2.2, 1.0, 1.0);
    }

    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: end,
    ).animate(CurvedAnimation(parent: _zoomAnimationController, curve: Curves.easeOutCubic));

    _zoomAnimationController.forward(from: 0);
  }

  void _onColorSelected(ProductColorVariant variant) {
    HapticService.selection();
    setState(() {
      _selectedColor = variant;
      _currentGalleryIndex = 0;
    });
    if (_galleryPageController.hasClients) {
      _galleryPageController.jumpToPage(0);
    }
  }

  void _onSizeSelected(String size) {
    HapticService.selection();
    setState(() {
      _selectedSize = size;
    });
  }

  void _handleAddToBag() {
    HapticService.success();
    AtelierController.to.addToCart(
      product: widget.product,
      size: _selectedSize,
      color: _selectedColor,
      monogramSummary: _monogramConfig != null
          ? '${_monogramConfig!.initials} (${_monogramConfig!.threadName}, ${_monogramConfig!.placement})'
          : null,
    );

    setState(() => _isAddedToBag = true);

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() => _isAddedToBag = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final images = _selectedColor.images.isNotEmpty
        ? _selectedColor.images
        : [widget.product.primaryImage];

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Gallery with Zoom support
                _buildGallery(images, isDark),

                // 2. Product Specs & Price Block
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Stock Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.category,
                            style: AppTypography.headingMeta(
                              color: isDark ? AppColors.champagneGold : AppColors.textMuted,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.product.stockLeft <= 3
                                  ? AppColors.saleRed.withValues(alpha: 0.12)
                                  : AppColors.inStockGreen.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.product.stockLeft <= 3
                                  ? 'Only ${widget.product.stockLeft} left!'
                                  : 'In Stock (${widget.product.stockLeft})',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: widget.product.stockLeft <= 3
                                    ? AppColors.saleRed
                                    : AppColors.inStockGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Brand & Discount Badge Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                              ),
                            ),
                            child: Text(
                              widget.product.brand.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                color: AppColors.silouPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (widget.product.computedDiscountPercent > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.saleRed,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${widget.product.computedDiscountPercent}% OFF',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Product Title
                      Text(
                        widget.product.title,
                        style: AppTypography.displayHero(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price & Rating Row
                      Row(
                        children: [
                          Obx(() => Text(
                                controller.formatPrice(widget.product.price),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              )),
                          if (widget.product.originalPrice != null) ...[
                            const SizedBox(width: 8),
                            Obx(() => Text(
                                  controller.formatPrice(widget.product.originalPrice!),
                                  style: AppTypography.originalPrice(),
                                )),
                          ],
                          const Spacer(),
                          GestureDetector(
                            onTap: () => CustomerReviewsModal.show(context, widget.product),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 18, color: AppColors.champagneGold),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewsCount})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Installment badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark
                              : AppColors.champagneLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE7E2F8),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.checkmark_shield_fill,
                              size: 16,
                              color: AppColors.champagneGold,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Or 4 interest-free payments of \$${(widget.product.price / 4).toStringAsFixed(2)} with Klarna.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        widget.product.description,
                        style: AppTypography.body(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 3. Interactive Color Swatches
                      Text(
                        'Color: ${_selectedColor.name}',
                        style: AppTypography.headingMeta(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ).copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: widget.product.colorVariants.map((variant) {
                          final isSelected = variant.name == _selectedColor.name;
                          return GestureDetector(
                            onTap: () => _onColorSelected(variant),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 14),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? (isDark ? Colors.white : AppColors.ctaDark)
                                      : Colors.transparent,
                                  width: 1.8,
                                ),
                              ),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: variant.color,
                                  border: Border.all(
                                    color: isDark ? Colors.white24 : Colors.black12,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // 4. Interactive Size Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Size',
                            style: AppTypography.headingMeta(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ).copyWith(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              BespokeTailorModal.show(
                                context,
                                widget.product,
                                (newSize) => setState(() => _selectedSize = newSize),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.scissors,
                                  size: 14,
                                  color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Bespoke Fit Guide',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.product.sizes.map((size) {
                          final isSelected = size == _selectedSize;
                          return GestureDetector(
                            onTap: () => _onSizeSelected(size),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 62,
                              height: 44,
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
                              child: Center(
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected
                                        ? (isDark ? AppColors.canvasDark : Colors.white)
                                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Fabric Weave Inspection Quick Bar
                      GestureDetector(
                        onTap: () => FabricWeaveLoupeModal.show(context, widget.product),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.champagneGold.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.zoom_in,
                                  size: 16,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inspect weave & texture',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Zoom in 3.5× on the fabric',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Kinetic Drape Simulator Quick Bar
                      GestureDetector(
                        onTap: () => KineticDrapeModal.show(context, widget.product),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.wind,
                                  size: 16,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'See how it moves',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Watch the hem move as you walk',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 360 Turntable Inspection Button
                      GestureDetector(
                        onTap: () => Turntable360Viewer.show(context, widget.product),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.rotate_right,
                                  size: 16,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '360° view',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Turn the piece all the way around',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Bespoke Monogramming & Embroidery Studio Button
                      GestureDetector(
                        onTap: () async {
                          HapticService.light();
                          final result = await Get.to<MonogramConfig>(
                            () => AtelierMonogramView(
                              product: widget.product,
                              initialConfig: _monogramConfig,
                            ),
                          );
                          if (result != null) {
                            setState(() => _monogramConfig = result);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _monogramConfig != null
                                ? AppColors.champagneGold.withValues(alpha: isDark ? 0.15 : 0.08)
                                : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _monogramConfig != null
                                  ? AppColors.champagneGold
                                  : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                              width: _monogramConfig != null ? 1.2 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.sparkles,
                                  size: 16,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Add a monogram',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: _monogramConfig != null
                                                ? AppColors.champagneGold
                                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                          ),
                                        ),
                                        if (_monogramConfig != null) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.champagneGold,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Added',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _monogramConfig != null
                                          ? 'Initials "${_monogramConfig!.initials}" • ${_monogramConfig!.threadName} • ${_monogramConfig!.placement}'
                                          : 'Free initials, stitched by hand',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: _monogramConfig != null ? FontWeight.w600 : FontWeight.w500,
                                        color: _monogramConfig != null
                                            ? (isDark ? Colors.white : Colors.black87)
                                            : (isDark ? AppColors.textMutedDark : AppColors.textMuted),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                _monogramConfig != null ? CupertinoIcons.pencil : CupertinoIcons.chevron_right,
                                size: 14,
                                color: _monogramConfig != null
                                    ? AppColors.champagneGold
                                    : (isDark ? AppColors.textMutedDark : AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // AR Virtual Mirror & Silhouette Fit Studio Button
                      GestureDetector(
                        onTap: () {
                          HapticService.light();
                          Get.to(
                            () => AtelierVirtualMirrorView(initialProduct: widget.product),
                            transition: Transition.fadeIn,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF1D1836), const Color(0xFF110E22)]
                                  : [const Color(0xFFFAF8FF), const Color(0xFFEFEAFF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.champagneGold.withValues(alpha: 0.5),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.champagneGold.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.viewfinder,
                                  size: 16,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Virtual try-on',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'See it on you with your camera',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_right,
                                size: 14,
                                color: AppColors.champagneGold,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 5. Expandable Accordions
                      _buildAccordion(
                        title: 'Fabric & Care',
                        content: widget.product.fabricCare,
                        isExpanded: _isFabricExpanded,
                        onToggle: () => setState(() => _isFabricExpanded = !_isFabricExpanded),
                        isDark: isDark,
                      ),
                      _buildAccordion(
                        title: 'Size & Fit Guide',
                        content: widget.product.sizeFitNotes,
                        isExpanded: _isFitExpanded,
                        onToggle: () => setState(() => _isFitExpanded = !_isFitExpanded),
                        isDark: isDark,
                      ),
                      _buildAccordion(
                        title: 'Shipping & Returns',
                        content:
                            'Complimentary express carbon-neutral delivery on all orders over \$300. Free 30-day returns with our pre-printed prepaid label.',
                        isExpanded: _isShippingExpanded,
                        onToggle: () => setState(() => _isShippingExpanded = !_isShippingExpanded),
                        isDark: isDark,
                      ),

                      // Curated Recommendations Carousel
                      Obx(() {
                        final others = controller.allProducts
                            .where((p) => p.id != widget.product.id)
                            .take(4)
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),
                            Text(
                              'You may also like',
                              style: AppTypography.editorialHeading(
                                fontSize: 22,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              // Fits AtelierProductCard's natural height (220px image + details).
                              height: 356,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: others.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 14),
                                itemBuilder: (context, idx) {
                                  return SizedBox(
                                    width: 180,
                                    child: AtelierProductCard(product: others[idx]),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),

                      // Bottom spacing for sticky CTA
                      const SizedBox(height: 130),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Top Navigation Bar
          _buildTopBar(context, controller, isDark),

          // Sticky Glassmorphic Bottom Bar with Add to Bag
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyBottomBar(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(List<String> images, bool isDark) {
    return SizedBox(
      height: 480,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _galleryPageController,
            itemCount: images.length,
            onPageChanged: (i) {
              setState(() => _currentGalleryIndex = i);
              _transformationController.value = Matrix4.identity();
            },
            itemBuilder: (context, index) {
              return Hero(
                tag: index == 0 ? 'product_img_${widget.product.id}' : 'gallery_$index',
                child: GestureDetector(
                  onDoubleTapDown: (details) => _doubleTapDetails = details,
                  onDoubleTap: _handleDoubleTap,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 1.0,
                    maxScale: 3.5,
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: isDark ? const Color(0xFF1E1A33) : const Color(0xFFE9E5F7),
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const EditorialShimmerBox(
                          height: 480,
                          width: double.infinity,
                          borderRadius: BorderRadius.zero,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          // Gradient overlay for smooth contrast
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    (isDark ? AppColors.canvasDark : AppColors.canvasLight).withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Dot Indicator
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentGalleryIndex == i ? 18 : 6,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _currentGalleryIndex == i
                          ? (isDark ? Colors.white : AppColors.ctaDark)
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AtelierController controller, bool isDark) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 6,
          bottom: 10,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.canvasDark : AppColors.canvasLight)
              .withValues(alpha: _appBarOpacity * 0.95),
          border: Border(
            bottom: BorderSide(
              color: (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight)
                  .withValues(alpha: _appBarOpacity),
            ),
          ),
        ),
        child: Row(
          children: [
            // Back Button
            _buildRoundIcon(
              icon: CupertinoIcons.back,
              onTap: () => Navigator.of(context).pop(),
              isDark: isDark,
            ),
            const SizedBox(width: 12),
            // Dynamic Title fading on scroll
            Expanded(
              child: Opacity(
                opacity: _appBarOpacity,
                child: Text(
                  widget.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.productTitle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
            // Wishlist Toggle Button
            Obx(() {
              final isLiked = controller.isWishlisted(widget.product.id);
              return AnimatedHeartButton(
                isLiked: isLiked,
                onToggle: (_) => controller.toggleWishlist(widget.product.id),
              );
            }),
            const SizedBox(width: 8),
            // Mirror Comparator Button
            _buildRoundIcon(
              icon: CupertinoIcons.arrow_right_arrow_left,
              onTap: () {
                HapticService.light();
                Get.to(() => AtelierCompareView(initialProductA: widget.product));
              },
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            // Share Button
            _buildRoundIcon(
              icon: CupertinoIcons.share,
              onTap: () {
                HapticService.selection();
                Get.snackbar(
                  'Editorial Share',
                  'Link copied to clipboard for ${widget.product.title}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: isDark ? Colors.black87 : Colors.white,
                  colorText: isDark ? Colors.white : Colors.black,
                  margin: const EdgeInsets.all(16),
                );
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundIcon({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.black.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required String content,
    required bool isExpanded,
    required VoidCallback onToggle,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticService.selection();
          onToggle();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    content,
                    style: AppTypography.body(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                ),
                crossFadeState:
                    isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 240),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar(bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: LiquidGlassContainer(
          borderRadius: 30,
          blur: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: isDark
              ? Colors.black.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.88),
          borderColor: isDark
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.9),
          child: Row(
            children: [
              // Price block
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.headingMeta(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                  Obx(() => Text(
                        AtelierController.to.formatPrice(widget.product.price),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      )),
                ],
              ),
              const SizedBox(width: 20),

              // Interactive Add to Bag Button with Transformation
              Expanded(
                child: GestureDetector(
                  onTap: _handleAddToBag,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 52,
                    decoration: BoxDecoration(
                      color: _isAddedToBag
                          ? AppColors.inStockGreen
                          : (isDark ? Colors.white : AppColors.ctaDark),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: (_isAddedToBag ? AppColors.inStockGreen : Colors.black)
                              .withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _isAddedToBag
                            ? const Row(
                                key: ValueKey('added'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.checkmark_alt, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'ADDED TO BAG',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                key: const ValueKey('add'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.bag,
                                    size: 18,
                                    color: isDark ? AppColors.canvasDark : Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ADD TO BAG',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: isDark ? AppColors.canvasDark : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

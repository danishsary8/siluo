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
import '../../shared/widgets/image_fallback.dart';

class AtelierCompareView extends StatefulWidget {
  final Product? initialProductA;
  final Product? initialProductB;

  const AtelierCompareView({
    super.key,
    this.initialProductA,
    this.initialProductB,
  });

  @override
  State<AtelierCompareView> createState() => _AtelierCompareViewState();
}

class _AtelierCompareViewState extends State<AtelierCompareView> {
  late Product _productA;
  late Product _productB;
  double _splitFraction = 0.50; // Center split slider 0.1 to 0.9

  @override
  void initState() {
    super.initState();
    final all = AtelierController.to.allProducts;
    _productA = widget.initialProductA ?? all[0];
    _productB = widget.initialProductB ?? (all.length > 1 ? all[1] : all[0]);
  }

  void _switchProductA(Product p) {
    HapticService.selection();
    setState(() => _productA = p);
  }

  void _switchProductB(Product p) {
    HapticService.selection();
    setState(() => _productB = p);
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'THE MIRROR COMPARATOR',
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
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'SIDE-BY-SIDE COUTURE COMPARISON',
            style: AppTypography.microTag(color: AppColors.champagneGold),
          ),
          const SizedBox(height: 4),
          Text(
            'Drag the center divider to inspect proportion, drape silhouette, and tactile fabric specifications.',
            style: AppTypography.body(
              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Split-Screen Interactive Visualizer
          Container(
            height: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final splitX = width * _splitFraction;

                return GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _splitFraction = (details.localPosition.dx / width).clamp(0.15, 0.85);
                    });
                  },
                  child: Stack(
                    children: [
                      // Layer A (Full Background)
                      Positioned.fill(
                        child: Image.network(
                          _productA.primaryImage,
                          fit: BoxFit.cover,
                          errorBuilder: ImageFallback.builder,
                        ),
                      ),

                      // Layer B (Clipped by splitFraction)
                      Positioned(
                        left: splitX,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.centerRight,
                            widthFactor: 1.0,
                            child: SizedBox(
                              width: width,
                              height: height,
                              child: Image.network(
                                _productB.primaryImage,
                                fit: BoxFit.cover,
                                errorBuilder: ImageFallback.builder,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Vertical Split Divider Line
                      Positioned(
                        left: splitX - 1.5,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 3,
                          decoration: const BoxDecoration(
                            color: AppColors.champagneGold,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Circular Drag Handle on the divider
                      Positioned(
                        left: splitX - 18,
                        top: (height / 2) - 18,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.85),
                            border: Border.all(color: AppColors.champagneGold, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.champagneGold.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            CupertinoIcons.arrow_left_right,
                            color: AppColors.champagneGold,
                            size: 16,
                          ),
                        ),
                      ),

                      // Floating Top Labels
                      Positioned(
                        top: 14,
                        left: 14,
                        child: LiquidGlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          borderRadius: 12,
                          child: Text(
                            'A: ${_productA.title.toUpperCase()}',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: LiquidGlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          borderRadius: 12,
                          child: Text(
                            'B: ${_productB.title.toUpperCase()}',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Technical Specs Comparison Table
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Column(
              children: [
                _buildComparisonRow(
                  'Price',
                  controller.formatPrice(_productA.price),
                  controller.formatPrice(_productB.price),
                  isDark,
                  isHighlight: true,
                ),
                const Divider(height: 20),
                _buildComparisonRow(
                  'Category',
                  _productA.category,
                  _productB.category,
                  isDark,
                ),
                const Divider(height: 20),
                _buildComparisonRow(
                  'Fabric Notes',
                  _productA.fabricCare.split('.').first,
                  _productB.fabricCare.split('.').first,
                  isDark,
                ),
                const Divider(height: 20),
                _buildComparisonRow(
                  'Silhouette Fit',
                  _productA.sizeFitNotes.split('.').first,
                  _productB.sizeFitNotes.split('.').first,
                  isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Two Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: AppColors.champagneGold),
                    ),
                    onPressed: () {
                      HapticService.light();
                      Get.to(() => AtelierPdpView(product: _productA));
                    },
                    child: Text(
                      'EXPLORE PIECE A',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.ctaDark,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      HapticService.light();
                      Get.to(() => AtelierPdpView(product: _productB));
                    },
                    child: Text(
                      'EXPLORE PIECE B',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.canvasDark : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Switch Pieces Quick Picker
          Text(
            'CHANGE COMPARISON PIECES',
            style: AppTypography.microTag(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.allProducts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final prod = controller.allProducts[idx];
                final isA = prod.id == _productA.id;
                final isB = prod.id == _productB.id;

                return GestureDetector(
                  onTap: () {
                    if (!isA) {
                      _switchProductB(prod);
                    }
                  },
                  onLongPress: () {
                    if (!isB) {
                      _switchProductA(prod);
                    }
                  },
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isA
                            ? AppColors.champagneGold
                            : (isB ? Colors.white : Colors.transparent),
                        width: (isA || isB) ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(prod.primaryImage, fit: BoxFit.cover,
 errorBuilder: ImageFallback.builder,),
                        if (isA || isB)
                          Container(
                            color: Colors.black.withValues(alpha: 0.5),
                            child: Center(
                              child: Text(
                                isA ? 'A' : 'B',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String metric, String valA, String valB, bool isDark, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.toUpperCase(),
          style: AppTypography.microTag(color: AppColors.champagneGold),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                valA,
                style: TextStyle(
                  fontSize: isHighlight ? 15 : 12,
                  fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                valB,
                style: TextStyle(
                  fontSize: isHighlight ? 15 : 12,
                  fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

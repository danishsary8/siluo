import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/liquid_glass_container.dart';
import '../../samples/atelier_swatch_order_view.dart';

/// FabricWeaveLoupeModal provides a high-luxury interactive macro weave inspection tool.
/// Allows discerning couture clients to inspect yarn composition, warp & weft weave,
/// and fabric weight with a real-time draggable magnifying loupe.
class FabricWeaveLoupeModal extends StatefulWidget {
  final Product product;

  const FabricWeaveLoupeModal({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FabricWeaveLoupeModal(product: product),
    );
  }

  @override
  State<FabricWeaveLoupeModal> createState() => _FabricWeaveLoupeModalState();
}

class _FabricWeaveLoupeModalState extends State<FabricWeaveLoupeModal> {
  Offset _loupePosition = const Offset(160, 140);
  bool _isDraggingLoupe = false;

  // Weave texture mapping per category
  String get _weaveTextureUrl {
    switch (widget.product.category.toLowerCase()) {
      case 'outerwear':
        return 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=1000&auto=format&fit=crop&q=80';
      case 'knitwear':
        return 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=1000&auto=format&fit=crop&q=80';
      case 'dresses':
        return 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=1000&auto=format&fit=crop&q=80';
      default:
        return 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=1000&auto=format&fit=crop&q=80';
    }
  }

  String get _weaveTitle {
    switch (widget.product.category.toLowerCase()) {
      case 'outerwear':
        return 'Double-Faced Melton Wool (520 gsm)';
      case 'knitwear':
        return '7-Gauge Grade-A Mongolian Cashmere';
      case 'dresses':
        return 'Sand-Washed Mulberry Silk Charmeuse';
      default:
        return 'Combed Long-Staple Cotton Twill';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C0A19) : AppColors.canvasLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Drag Handle & Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MATERIAL ARCHIVE',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Macro Weave Inspection',
                          style: AppTypography.productTitle(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: isDark ? Colors.white38 : Colors.black26,
                        size: 26,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Scrollable Content
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                // Interactive Weave Canvas with Loupe
                Text(
                  'DRAG THE LOUPE TO INSPECT FIBERS (3.5X)',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),

                // Interactive Loupe Canvas Container
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final canvasWidth = constraints.maxWidth;
                      const canvasHeight = 280.0;

                      return GestureDetector(
                        onPanStart: (details) {
                          HapticService.selection();
                          setState(() {
                            _isDraggingLoupe = true;
                            _loupePosition = details.localPosition;
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _loupePosition = Offset(
                              details.localPosition.dx.clamp(45.0, canvasWidth - 45.0),
                              details.localPosition.dy.clamp(45.0, canvasHeight - 45.0),
                            );
                          });
                        },
                        onPanEnd: (_) {
                          setState(() => _isDraggingLoupe = false);
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Base Texture Image
                            Image.network(
                              _weaveTextureUrl,
                              fit: BoxFit.cover,
                            ),

                            // Ambient Vignette
                            Container(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  radius: 0.85,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.4),
                                  ],
                                ),
                              ),
                            ),

                            // Draggable Magnifying Loupe
                            Positioned(
                              left: _loupePosition.dx - 45,
                              top: _loupePosition.dy - 45,
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.champagneGold,
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: AppColors.champagneGold.withValues(alpha: 0.35),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Magnified portion
                                    Transform.scale(
                                      scale: 3.5,
                                      alignment: Alignment(
                                        (_loupePosition.dx / (canvasWidth / 2)) - 1.0,
                                        (_loupePosition.dy / (canvasHeight / 2)) - 1.0,
                                      ),
                                      child: Image.network(
                                        _weaveTextureUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Reticle Crosshairs
                                    Center(
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.champagneGold.withValues(alpha: 0.7),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Touch instruction pill
                            Positioned(
                              bottom: 12,
                              left: 14,
                              child: LiquidGlassContainer(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                borderRadius: 14,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isDraggingLoupe ? CupertinoIcons.hand_draw_fill : CupertinoIcons.hand_draw,
                                      size: 13,
                                      color: AppColors.champagneGold,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'Touch & drag lens',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
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

                // Fabric Specifications Card
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weaveTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.product.fabricCare,
                        style: AppTypography.body(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1),
                      ),

                      // Quality Attribute Bars
                      _buildQualityRow('Thermal Regulation', 0.94, 'Optimal Breathability', isDark),
                      const SizedBox(height: 12),
                      _buildQualityRow('Tensile Longevity', 0.98, 'Heirloom Grade', isDark),
                      const SizedBox(height: 12),
                      _buildQualityRow('Drape Resilience', 0.91, 'Natural Wrinkle Resistance', isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Atelier Guarantee Badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.shield_lefthalf_fill, color: AppColors.champagneGold, size: 24),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'VERIFIED FIBER PROVENANCE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.champagneGold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Certified ethically sourced, spun with zero harsh chemical coatings to preserve raw tactile hand-feel.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Request Archival Swatches Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: AppColors.champagneGold, width: 1.2),
                    ),
                    onPressed: () {
                      HapticService.light();
                      Navigator.of(context).pop();
                      AtelierSwatchOrderView.show(context, product: widget.product);
                    },
                    icon: const Icon(CupertinoIcons.gift, size: 16, color: AppColors.champagneGold),
                    label: const Text(
                      'REQUEST ARCHIVAL 10×10 CM SWATCHES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.champagneGold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityRow(String label, double value, String ratingText, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              ratingText,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.champagneGold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 5,
            backgroundColor: isDark ? Colors.white12 : Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.champagneGold),
          ),
        ),
      ],
    );
  }
}

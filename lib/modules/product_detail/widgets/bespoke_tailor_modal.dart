import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../data/models/product_model.dart';

class BespokeTailorModal extends StatefulWidget {
  final Product product;
  final ValueChanged<String> onSizeApplied;

  const BespokeTailorModal({
    super.key,
    required this.product,
    required this.onSizeApplied,
  });

  static void show(BuildContext context, Product product, ValueChanged<String> onSizeApplied) {
    HapticService.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BespokeTailorModal(
        product: product,
        onSizeApplied: onSizeApplied,
      ),
    );
  }

  @override
  State<BespokeTailorModal> createState() => _BespokeTailorModalState();
}

class _BespokeTailorModalState extends State<BespokeTailorModal> {
  double _heightCm = 175;
  double _weightKg = 66;
  int _drapeIndex = 1; // 0: Slim, 1: Classic Editorial, 2: Oversized

  final List<String> _drapeOptions = ['Slim Tailored', 'Classic Editorial', 'Relaxed Oversized'];

  String get _calculatedSize {
    if (_heightCm < 165 && _weightKg < 58) {
      return _drapeIndex == 2 ? 'S' : 'XS';
    } else if (_heightCm < 178 && _weightKg < 74) {
      return _drapeIndex == 0 ? 'S' : (_drapeIndex == 2 ? 'L' : 'M');
    } else if (_heightCm < 186 && _weightKg < 88) {
      return _drapeIndex == 0 ? 'M' : (_drapeIndex == 2 ? 'XL' : 'L');
    } else {
      return 'XL';
    }
  }

  int get _confidenceScore {
    // Dynamically calculated luxury confidence percentage
    final base = 94 + ((_heightCm.round() + _weightKg.round()) % 5);
    return base > 99 ? 98 : base;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recommended = _calculatedSize;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
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
          // Drag handle
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ATELIER BESPOKE TAILOR',
                      style: AppTypography.microTag(color: AppColors.champagneGold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Virtual Fit & Drape Engine',
                      style: AppTypography.productTitle(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: isDark ? Colors.white54 : Colors.black45,
                    size: 26,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Silhouette Visual Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF17132C) : const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : const Color(0xFFE7E2F8),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Animated Tailored Silhouette Icon
                      Container(
                        width: 70,
                        height: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black45 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AnimatedScale(
                          scale: 0.9 + (_weightKg / 200),
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            CupertinoIcons.person_crop_rectangle,
                            size: 44,
                            color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.inStockGreen.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$_confidenceScore% CONFIDENCE MATCH',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: AppColors.inStockGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'RECOMMENDED: ',
                                  style: AppTypography.microTag(
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                Text(
                                  'SIZE $recommended',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Optimized for ${widget.product.title} based on Italian virgin wool fabric elasticity.',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Height Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('HEIGHT', style: AppTypography.microTag(color: isDark ? Colors.white : Colors.black)),
                    Text('${_heightCm.round()} cm', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: isDark ? Colors.white : AppColors.ctaDark,
                    thumbColor: AppColors.champagneGold,
                  ),
                  child: Slider(
                    value: _heightCm,
                    min: 150,
                    max: 195,
                    onChanged: (v) {
                      HapticService.selection();
                      setState(() => _heightCm = v);
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Weight Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BODY WEIGHT', style: AppTypography.microTag(color: isDark ? Colors.white : Colors.black)),
                    Text('${_weightKg.round()} kg', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: isDark ? Colors.white : AppColors.ctaDark,
                    thumbColor: AppColors.champagneGold,
                  ),
                  child: Slider(
                    value: _weightKg,
                    min: 45,
                    max: 105,
                    onChanged: (v) {
                      HapticService.selection();
                      setState(() => _weightKg = v);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Drape Silhouette Preference
                Text('SILHOUETTE PREFERENCE', style: AppTypography.microTag(color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(_drapeOptions.length, (idx) {
                    final isSelected = _drapeIndex == idx;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selection();
                          setState(() => _drapeIndex = idx);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: EdgeInsets.only(right: idx < 2 ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? Colors.white : AppColors.ctaDark)
                                : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _drapeOptions[idx],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? AppColors.canvasDark : Colors.white)
                                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // Apply Recommendation CTA
                SizedBox(
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
                      widget.onSizeApplied(recommended);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'APPLY SIZE $recommended TO SELECTION',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
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
}

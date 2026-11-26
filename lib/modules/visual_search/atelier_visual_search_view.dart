import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../product_detail/atelier_pdp_view.dart';

class AtelierVisualSearchView extends StatefulWidget {
  const AtelierVisualSearchView({super.key});

  @override
  State<AtelierVisualSearchView> createState() => _AtelierVisualSearchViewState();
}

class _AtelierVisualSearchViewState extends State<AtelierVisualSearchView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanLaserController;
  bool _isAnalyzing = true;
  int _activeSamplePhotoIndex = 0;

  final List<Map<String, dynamic>> _sampleEditorialMoodboards = const [
    {
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1000&auto=format&fit=crop&q=80',
      'label': 'Minimalist Silk Bias & Warm Taupe',
      'colors': [
        {'name': 'Champagne Gold', 'color': Color(0xFFC5A880)},
        {'name': 'Raw Sand', 'color': Color(0xFFDCD2C5)},
        {'name': 'Deep Espresso', 'color': Color(0xFF26201B)},
      ],
      'detectedTexture': 'Sand-Washed Mulberry Silk Charmeuse',
    },
    {
      'image': 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=1000&auto=format&fit=crop&q=80',
      'label': 'Sculptural Tailoring & Melton Wool',
      'colors': [
        {'name': 'Obsidian Noir', 'color': Color(0xFF141416)},
        {'name': 'Charcoal Slate', 'color': Color(0xFF38373D)},
        {'name': 'Warm Alabaster', 'color': Color(0xFFE9E5F7)},
      ],
      'detectedTexture': 'Double-Faced 520gsm Melton Wool',
    },
    {
      'image': 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1000&auto=format&fit=crop&q=80',
      'label': 'Eveningwear Drape & Structural Satin',
      'colors': [
        {'name': 'Midnight Navy', 'color': Color(0xFF0F1420)},
        {'name': 'Burnished Gold', 'color': Color(0xFFD4AF37)},
        {'name': 'Pure Slate', 'color': Color(0xFF4A4950)},
      ],
      'detectedTexture': 'Combed Worsted Wool & Duchesse Satin',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scanLaserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _simulateAnalysis();
  }

  void _simulateAnalysis() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        HapticService.heavy();
        setState(() => _isAnalyzing = false);
      }
    });
  }

  @override
  void dispose() {
    _scanLaserController.dispose();
    super.dispose();
  }

  void _onSwitchSample(int idx) {
    if (_activeSamplePhotoIndex != idx) {
      HapticService.selection();
      setState(() => _activeSamplePhotoIndex = idx);
      _simulateAnalysis();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sample = _sampleEditorialMoodboards[_activeSamplePhotoIndex];
    final colors = sample['colors'] as List<Map<String, dynamic>>;

    final matchedProducts = controller.allProducts.take(3).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'EDITORIAL PALETTE SCANNER',
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
          // Subtitle
          Text(
            'COMPUTER VISION MOODBOARD RECOGNITION',
            style: AppTypography.microTag(color: AppColors.champagneGold),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan or select editorial inspiration to extract chromatic palettes, drape geometry, and material weaves.',
            style: AppTypography.body(
              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Camera Viewport / Image Scanner Stage
          Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _isAnalyzing
                    ? AppColors.champagneGold
                    : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                width: _isAnalyzing ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Editorial Image
                Image.network(
                  sample['image'] as String,
                  fit: BoxFit.cover,
                ),

                // Vignette Scrim
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),

                // Animated Laser Line (during scan)
                if (_isAnalyzing)
                  AnimatedBuilder(
                    animation: _scanLaserController,
                    builder: (context, child) {
                      return Positioned(
                        top: 20 + (_scanLaserController.value * 270),
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: AppColors.champagneGold,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.champagneGold,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                // Scanning HUD Reticles (corners)
                Positioned(
                  top: 16,
                  left: 16,
                  child: _buildHudCorner(true, true),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildHudCorner(true, false),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: _buildHudCorner(false, true),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildHudCorner(false, false),
                ),

                // Status Pill
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: LiquidGlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    borderRadius: 18,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isAnalyzing ? CupertinoIcons.sparkles : CupertinoIcons.checkmark_seal_fill,
                          size: 14,
                          color: _isAnalyzing ? AppColors.champagneGold : AppColors.inStockGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isAnalyzing
                              ? 'EXTRACTING WEAVE & DYES...'
                              : 'SPECTRAL MATCH CONFIRMED (98.4%)',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Select Sample Moodboards Row
          Text(
            'SELECT EDITORIAL MOODBOARD SOURCE',
            style: AppTypography.microTag(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sampleEditorialMoodboards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final item = _sampleEditorialMoodboards[idx];
                final isSelected = _activeSamplePhotoIndex == idx;
                return GestureDetector(
                  onTap: () => _onSwitchSample(idx),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.champagneGold : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(item['image'] as String, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // Extracted Color Palette Swatches
          Text(
            'EXTRACTED CHROMATIC PALETTE',
            style: AppTypography.microTag(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: colors.map((c) {
                    final color = c['color'] as Color;
                    final name = c['name'] as String;
                    return Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1),
                ),
                Row(
                  children: [
                    const Icon(CupertinoIcons.circle_grid_hex_fill, size: 16, color: AppColors.champagneGold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dominant Fiber: ${sample['detectedTexture']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Catalog Matches
          Text(
            'MATCHED RUNWAY PIECES (ATELIER CATALOG)',
            style: AppTypography.microTag(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: matchedProducts.map((p) {
              return GestureDetector(
                onTap: () {
                  HapticService.light();
                  Get.to(() => AtelierPdpView(product: p));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          p.primaryImage,
                          width: 58,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.champagneGold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '96% CHROMATIC MATCH',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const SizedBox(height: 3),
                            Obx(() => Text(
                                  controller.formatPrice(p.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: AppColors.champagneGold,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHudCorner(bool isTop, bool isLeft) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: AppColors.champagneGold, width: 2) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: AppColors.champagneGold, width: 2) : BorderSide.none,
          left: isLeft ? const BorderSide(color: AppColors.champagneGold, width: 2) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: AppColors.champagneGold, width: 2) : BorderSide.none,
        ),
      ),
    );
  }
}

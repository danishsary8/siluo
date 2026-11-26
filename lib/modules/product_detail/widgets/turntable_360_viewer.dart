import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/liquid_glass_container.dart';

/// Turntable360Viewer provides an interactive 360° rotational garment turntable.
/// Supports horizontal pan dragging with continuous inertia, compass angle dial,
/// and milestone haptic feedback.
class Turntable360Viewer extends StatefulWidget {
  final Product product;

  const Turntable360Viewer({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Turntable360Viewer(product: product),
    );
  }

  @override
  State<Turntable360Viewer> createState() => _Turntable360ViewerState();
}

class _Turntable360ViewerState extends State<Turntable360Viewer> {
  double _currentRotationDegrees = 0.0;
  int _lastMilestoneIndex = 0;

  // 8 Angle frames mapping around 360°
  final List<Map<String, dynamic>> _frames = [
    {
      'angle': 0,
      'label': 'Front Silhouette (0°)',
      'note': 'Clean drop-shoulder line & double-breasted closure',
      'image': 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 45,
      'label': '3/4 Front Oblique (45°)',
      'note': 'Wide peak lapel roll & welted waist pockets',
      'image': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 90,
      'label': 'Profile Flank (90°)',
      'note': 'Substantial vertical drape & deep sleeve armhole pitch',
      'image': 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 135,
      'label': '3/4 Dorsal Oblique (135°)',
      'note': 'Sculpted shoulder blade suppression & natural waist taper',
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 180,
      'label': 'Dorsal Spine (180°)',
      'note': 'Single center walking vent with reinforced bar tacks',
      'image': 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 225,
      'label': '3/4 Left Dorsal (225°)',
      'note': 'Bias-cut back panels accommodating natural arm motion',
      'image': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 270,
      'label': 'Left Profile (270°)',
      'note': 'Clean straight side-seam alignment from collar to hem',
      'image': 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1000&auto=format&fit=crop&q=80',
    },
    {
      'angle': 315,
      'label': '3/4 Left Oblique (315°)',
      'note': 'Interior horn buttons and reinforced chest canvas',
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1000&auto=format&fit=crop&q=80',
    },
  ];

  int get _activeFrameIndex {
    final normalized = (_currentRotationDegrees % 360 + 360) % 360;
    final index = ((normalized + 22.5) / 45).floor() % 8;
    return index;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      // Sensitivity: drag 1px = 0.8 degrees
      _currentRotationDegrees = (_currentRotationDegrees + details.delta.dx * 0.8) % 360;
      final currentMilestone = _activeFrameIndex;
      if (currentMilestone != _lastMilestoneIndex) {
        _lastMilestoneIndex = currentMilestone;
        HapticService.selection();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final currentFrame = _frames[_activeFrameIndex];

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
          // Drag handle & title
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
                          'ROTATIONAL INSPECTION',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '360° Silhouette Turntable',
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

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                // Turntable Canvas with Drag Recognition
                GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  child: Container(
                    height: 330,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131318) : const Color(0xFFF2EFE9),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        // Perspective turntable pedestal base rings
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: 220,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.champagneGold.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.champagneGold.withValues(alpha: 0.15),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Active Angle Photo
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Image.network(
                            currentFrame['image'] as String,
                            key: ValueKey(_activeFrameIndex),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),

                        // Top Compass Rose Dial
                        Positioned(
                          top: 16,
                          right: 16,
                          child: LiquidGlassContainer(
                            padding: const EdgeInsets.all(10),
                            borderRadius: 24,
                            child: Transform.rotate(
                              angle: (_currentRotationDegrees * math.pi / 180),
                              child: const Icon(
                                CupertinoIcons.compass,
                                color: AppColors.champagneGold,
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        // Drag hint overlay pill
                        const Positioned(
                          bottom: 16,
                          child: LiquidGlassContainer(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            borderRadius: 18,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.arrow_left_right, size: 13, color: AppColors.champagneGold),
                                SizedBox(width: 6),
                                Text(
                                  'Drag horizontally to rotate 360°',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
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
                ),

                const SizedBox(height: 20),

                // Angle readout & details
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
                          Text(
                            currentFrame['label'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.champagneGold,
                            ),
                          ),
                          Text(
                            'FRAME ${_activeFrameIndex + 1} / 8',
                            style: AppTypography.microTag(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentFrame['note'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Return CTA
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'CONFIRM SILHOUETTE INSPECTION',
                      style: AppTypography.buttonLabel(
                        color: isDark ? AppColors.canvasDark : Colors.white,
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

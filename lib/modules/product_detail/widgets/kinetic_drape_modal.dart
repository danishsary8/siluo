import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/liquid_glass_container.dart';
import '../../../shared/widgets/image_fallback.dart';

/// KineticDrapeModal provides an interactive 360° fabric motion and drape simulator.
/// Allows clients to scrub walking speeds from stationary to brisk runway pace
/// to visualize hem flutter, fabric fluid dynamics, and drape coefficient.
class KineticDrapeModal extends StatefulWidget {
  final Product product;

  const KineticDrapeModal({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => KineticDrapeModal(product: product),
    );
  }

  @override
  State<KineticDrapeModal> createState() => _KineticDrapeModalState();
}

class _KineticDrapeModalState extends State<KineticDrapeModal>
    with SingleTickerProviderStateMixin {
  double _strideSpeed = 4.2; // km/h (gentle runway walk)
  late final AnimationController _drapeAnimController;

  @override
  void initState() {
    super.initState();
    _drapeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _drapeAnimController.dispose();
    super.dispose();
  }

  String get _movementPaceLabel {
    if (_strideSpeed < 1.0) return 'Stationary Plinth (Resting Drape)';
    if (_strideSpeed < 3.5) return 'Gentle Stride (Urban Promenade)';
    if (_strideSpeed < 5.5) return 'Runway Stride (4.5 km/h)';
    return 'Catwalk Gust & High Velocity (6.0 km/h)';
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
                          'KINETIC TEXTILE DYNAMICS',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stride & Drape Simulator',
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
                // Kinetic Simulation Stage
                Container(
                  height: 310,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161229) : const Color(0xFFF0EDFA),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial lighting glow
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 0.7,
                            colors: [
                              AppColors.champagneGold.withValues(alpha: isDark ? 0.15 : 0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Animated Fabric Flutter Waves
                      AnimatedBuilder(
                        animation: _drapeAnimController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(260, 260),
                            painter: _FabricDrapePainter(
                              progress: _drapeAnimController.value,
                              speed: _strideSpeed,
                              isDark: isDark,
                            ),
                          );
                        },
                      ),

                      // Product Image Overlay
                      Positioned(
                        top: 20,
                        child: Container(
                          width: 140,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            widget.product.primaryImage,
                            fit: BoxFit.cover,
                            errorBuilder: ImageFallback.builder,
                          ),
                        ),
                      ),

                      // Velocity Badge Pill
                      Positioned(
                        bottom: 16,
                        child: LiquidGlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          borderRadius: 20,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.wind, size: 14, color: AppColors.champagneGold),
                              const SizedBox(width: 8),
                              Text(
                                '${_strideSpeed.toStringAsFixed(1)} KM/H • ${_strideSpeed < 1.0 ? "REST" : "MOTION"}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
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

                const SizedBox(height: 24),

                // Interactive Pace Slider
                Text(
                  'STRIDE VELOCITY: $_movementPaceLabel'.toUpperCase(),
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.champagneGold,
                    inactiveTrackColor: isDark ? Colors.white12 : Colors.black12,
                    thumbColor: AppColors.champagneGold,
                    overlayColor: AppColors.champagneGold.withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _strideSpeed,
                    min: 0.0,
                    max: 6.0,
                    divisions: 12,
                    onChanged: (val) {
                      HapticService.selection();
                      setState(() => _strideSpeed = val);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0 km/h (Rest)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                    Text('3.0 km/h (Walk)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                    Text('6.0 km/h (Catwalk)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                  ],
                ),

                const SizedBox(height: 28),

                // Physical Drape Coefficient Specs
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
                      const Text(
                        'LABORATORY TEXTILE METRICS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: AppColors.champagneGold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMetricRow('Drape Coefficient (DC%)', '38.4% (Ultra-Fluid Silhouette)', isDark),
                      const Divider(height: 20),
                      _buildMetricRow('Bending Rigidity', '0.42 mN·m (Supple Hand)', isDark),
                      const Divider(height: 20),
                      _buildMetricRow('Aerodynamic Flutter Harmonic', '${(2.2 + (_strideSpeed * 0.8)).toStringAsFixed(1)} Hz', isDark),
                      const Divider(height: 20),
                      _buildMetricRow('Crease Memory Recovery', '97.2% within 8 minutes', isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Return to PDP CTA
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
                      'RETURN TO GARMENT SPECIFICATIONS',
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

  Widget _buildMetricRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}

class _FabricDrapePainter extends CustomPainter {
  final double progress;
  final double speed;
  final bool isDark;

  const _FabricDrapePainter({
    required this.progress,
    required this.speed,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final amplitude = (speed * 12.0).clamp(2.0, 50.0);
    final paint1 = Paint()
      ..color = AppColors.champagneGold.withValues(alpha: isDark ? 0.35 : 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paint2 = Paint()
      ..color = AppColors.champagneGold.withValues(alpha: isDark ? 0.15 : 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw flowing sinusoidal wave curves underneath the garment
    final path1 = Path();
    final path2 = Path();

    const startY = 210.0;
    path1.moveTo(20, startY);
    path2.moveTo(20, startY + 14);

    for (double x = 20; x <= size.width - 20; x += 4) {
      final waveOffset1 = math.sin((x / 25.0) + (progress * 2 * math.pi)) * amplitude;
      final waveOffset2 = math.cos((x / 30.0) + (progress * 2 * math.pi) + 0.8) * (amplitude * 0.85);

      path1.lineTo(x, startY + waveOffset1);
      path2.lineTo(x, startY + 14 + waveOffset2);
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _FabricDrapePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.speed != speed;
  }
}

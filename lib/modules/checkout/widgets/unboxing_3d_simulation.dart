import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/liquid_glass_container.dart';
import '../../../shared/widgets/image_fallback.dart';

class Unboxing3dSimulation extends StatefulWidget {
  final Product product;

  const Unboxing3dSimulation({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Unboxing3dSimulation(product: product),
    );
  }

  @override
  State<Unboxing3dSimulation> createState() => _Unboxing3dSimulationState();
}

class _Unboxing3dSimulationState extends State<Unboxing3dSimulation>
    with SingleTickerProviderStateMixin {
  // Unboxing Steps: 0 = Ribbon Tied, 1 = Ribbon Untied, 2 = Lid Lifted, 3 = Seal Broken & Revealed
  int _step = 0;

  void _onUntieRibbon() {
    HapticService.selection();
    setState(() => _step = 1);
  }

  void _onLidLifted() {
    HapticService.light();
    setState(() => _step = 2);
  }

  void _onBreakSeal() {
    HapticService.heavy();
    setState(() => _step = 3);
  }

  void _resetRitual() {
    HapticService.selection();
    setState(() {
      _step = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFF0B0917),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
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
                          'SIGNATURE UNBOXING RITUAL',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Obsidian Keepsake Presentation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.white38, size: 26),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.white12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step Indicator Pills
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStepBadge(1, 'RIBBON', _step >= 1),
                      const SizedBox(width: 8),
                      const Icon(CupertinoIcons.chevron_right, size: 12, color: Colors.white24),
                      const SizedBox(width: 8),
                      _buildStepBadge(2, 'LID', _step >= 2),
                      const SizedBox(width: 8),
                      const Icon(CupertinoIcons.chevron_right, size: 12, color: Colors.white24),
                      const SizedBox(width: 8),
                      _buildStepBadge(3, 'SEAL', _step >= 3),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Box Presentation Canvas
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 290,
                        height: 340,
                        decoration: BoxDecoration(
                          color: const Color(0xFF17132C),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 30,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: _buildStageContent(isDark),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Button or Reset
                  if (_step == 3)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: _resetRitual,
                        child: const Text('REPLAY UNBOXING RITUAL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8)),
                      ),
                    )
                  else
                    Text(
                      _getInstructionText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0.4,
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

  Widget _buildStageContent(bool isDark) {
    if (_step == 0) {
      // Step 0: Ribbon Tied
      return GestureDetector(
        onHorizontalDragEnd: (_) => _onUntieRibbon(),
        child: Container(
          key: const ValueKey(0),
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF17132C),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Grosgrain Ribbon Cross
              Container(width: 44, height: double.infinity, color: const Color(0xFF0B0917)),
              Container(height: 44, width: double.infinity, color: const Color(0xFF0B0917)),

              // Gold Bowknot Emblem
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1C1917),
                  border: Border.all(color: AppColors.champagneGold, width: 2),
                  boxShadow: [
                    BoxShadow(color: AppColors.champagneGold.withValues(alpha: 0.4), blurRadius: 16),
                  ],
                ),
                child: const Icon(CupertinoIcons.gift_fill, color: AppColors.champagneGold, size: 36),
              ),

              const Positioned(
                bottom: 24,
                child: LiquidGlassContainer(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  borderRadius: 16,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.arrow_right_arrow_left, size: 14, color: AppColors.champagneGold),
                      SizedBox(width: 8),
                      Text('Swipe ribbon to untie bow', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_step == 1) {
      // Step 1: Ribbon Untied, Drag Lid Upward
      return GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < -6) {
            _onLidLifted();
          }
        },
        child: Container(
          key: const ValueKey(1),
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF1C1917),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'A T E L I E R',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 6.0,
                  color: AppColors.champagneGold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'PARIS • PLACE VENDÔME',
                style: TextStyle(fontSize: 9, letterSpacing: 2.0, color: Colors.white38),
              ),
              const SizedBox(height: 60),
              const Icon(CupertinoIcons.chevron_up, size: 28, color: AppColors.champagneGold),
              const SizedBox(height: 6),
              const Text('Slide up to lift keepsake lid', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ),
      );
    } else if (_step == 2) {
      // Step 2: Tissue Paper & Wax Seal
      return GestureDetector(
        onTap: _onBreakSeal,
        child: Container(
          key: const ValueKey(2),
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFEFECE5), // Cream tissue paper
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Tissue folding seams
              Positioned(
                left: 0,
                right: 0,
                top: 165,
                child: Container(height: 1.5, color: Colors.black12),
              ),
              // Crimson Wax Seal
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8B1E1E),
                  border: Border.all(color: const Color(0xFF631515), width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 6)),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Color(0xFFEAD9BF),
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                child: LiquidGlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  borderRadius: 16,
                  color: Colors.black.withValues(alpha: 0.6),
                  child: const Text('Tap seal to unwrap tissue', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Step 3: Revealed Bespoke Garment Inside
      return Container(
        key: const ValueKey(3),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF17132C),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.champagneGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('AUTHENTICATED HAUTE COUTURE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.champagneGold)),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                widget.product.primaryImage,
                height: 160,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ImageFallback(width: 140, height: 160),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hand-crafted in Paris • Scented with Cedar Extract',
              style: TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStepBadge(int number, String label, bool isDone) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.champagneGold : Colors.white12,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDone ? Colors.black : Colors.white54),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: isDone ? Colors.white : Colors.white38,
          ),
        ),
      ],
    );
  }

  String _getInstructionText() {
    switch (_step) {
      case 0:
        return 'Swipe across the grosgrain ribbon to release the satin bow.';
      case 1:
        return 'Slide upward to lift the rigid obsidian box lid.';
      case 2:
        return 'Tap the Atelier crimson wax seal to break the tamper seal.';
      default:
        return 'Your bespoke piece is presented.';
    }
  }
}

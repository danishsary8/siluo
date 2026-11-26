import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/soundscape_model.dart';
import '../../modules/soundscape/atelier_acoustic_view.dart';
import 'liquid_glass_container.dart';

class PersistentSoundscapeBar extends StatefulWidget {
  const PersistentSoundscapeBar({super.key});

  @override
  State<PersistentSoundscapeBar> createState() => _PersistentSoundscapeBarState();
}

class _PersistentSoundscapeBarState extends State<PersistentSoundscapeBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final SoundscapeTrack? track = controller.activeSoundscapeTrack.value;
      if (track == null) return const SizedBox.shrink();

      final bool isPlaying = controller.isSoundscapePlaying.value;

      return SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
          child: GestureDetector(
            onTap: () {
              HapticService.light();
              Get.to(() => const AtelierAcousticView());
            },
            child: LiquidGlassContainer(
              borderRadius: 24,
              blur: 20,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: isDark
                  ? const Color(0xFF1A1631).withValues(alpha: 0.88)
                  : Colors.white.withValues(alpha: 0.92),
              borderColor: AppColors.champagneGold.withValues(alpha: 0.35),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Row(
                children: [
                  // Animated Equalizer or Paused Indicator
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isPlaying
                          ? AnimatedBuilder(
                              animation: _animController,
                              builder: (context, _) {
                                final v = _animController.value;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _buildEqualizerBar(6 + 8 * v),
                                    const SizedBox(width: 2.5),
                                    _buildEqualizerBar(14 - 8 * v),
                                    const SizedBox(width: 2.5),
                                    _buildEqualizerBar(8 + 6 * ((v + 0.4) % 1.0)),
                                  ],
                                );
                              },
                            )
                          : const Icon(
                              CupertinoIcons.waveform,
                              size: 16,
                              color: AppColors.champagneGold,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Track Info
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'STUDIO ACOUSTIQUE',
                              style: AppTypography.microTag(
                                color: AppColors.champagneGold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isPlaying
                                    ? AppColors.champagneGold
                                    : (isDark ? Colors.white38 : Colors.black26),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isPlaying ? 'SPATIAL LOOP' : 'PAUSED',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play/Pause Action Button
                  GestureDetector(
                    onTap: () {
                      controller.toggleSoundscapePlay();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                        size: 13,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Stop / Dismiss Action Button
                  GestureDetector(
                    onTap: () {
                      controller.stopSoundscape();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 12,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEqualizerBar(double height) {
    return Container(
      width: 2.5,
      height: height.clamp(3.0, 16.0),
      decoration: BoxDecoration(
        color: AppColors.champagneGold,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}

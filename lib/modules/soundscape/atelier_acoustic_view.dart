import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/soundscape_model.dart';

class AtelierAcousticView extends StatefulWidget {
  const AtelierAcousticView({super.key});

  @override
  State<AtelierAcousticView> createState() => _AtelierAcousticViewState();
}

class _AtelierAcousticViewState extends State<AtelierAcousticView>
    with SingleTickerProviderStateMixin {
  int _selectedTrackIndex = 0;
  bool _isPlaying = true;
  double _reverbDepth = 0.65;
  bool _hapticPulseSync = true;

  late final AnimationController _waveAnimController;

  List<SoundscapeTrack> get _tracks => SoundscapeTrack.defaultTracks;

  @override
  void initState() {
    super.initState();
    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    final controller = AtelierController.to;
    if (controller.activeSoundscapeTrack.value != null) {
      final idx = _tracks.indexWhere((t) => t.id == controller.activeSoundscapeTrack.value!.id);
      if (idx != -1) _selectedTrackIndex = idx;
      _isPlaying = controller.isSoundscapePlaying.value;
    } else {
      controller.playSoundscapeTrack(_tracks[_selectedTrackIndex]);
      _isPlaying = true;
    }
  }

  @override
  void dispose() {
    _waveAnimController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_hapticPulseSync) {
      HapticService.heavy();
    } else {
      HapticService.selection();
    }
    setState(() => _isPlaying = !_isPlaying);
    AtelierController.to.toggleSoundscapePlay();
  }

  @override
  Widget build(BuildContext context) {
    final activeTrack = _tracks[_selectedTrackIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF08070F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'LE STUDIO ACOUSTIQUE',
          style: AppTypography.brandLogo(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        children: [
          Text(
            'SPATIAL SENSORY RUNWAY AMBIENCE',
            textAlign: TextAlign.center,
            style: AppTypography.microTag(color: AppColors.champagneGold),
          ),
          const SizedBox(height: 20),

          // Central Pulsing Sound Wave Orb
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: AnimatedBuilder(
                animation: _waveAnimController,
                builder: (context, child) {
                  final wave = _isPlaying ? _waveAnimController.value : 0.0;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer ripple ring 3
                      Container(
                        width: 150 + (wave * 60),
                        height: 150 + (wave * 60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.champagneGold.withValues(
                              alpha: 0.15 * (1.0 - wave),
                            ),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Outer ripple ring 2
                      Container(
                        width: 130 + (wave * 40),
                        height: 130 + (wave * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.champagneGold.withValues(
                              alpha: 0.3 * (1.0 - wave),
                            ),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // Core Orb Button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A1631),
                            border: Border.all(
                              color: AppColors.champagneGold,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.champagneGold.withValues(alpha: 0.35),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                              color: AppColors.champagneGold,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Active Track Metadata
          Center(
            child: Column(
              children: [
                Text(
                  activeTrack.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activeTrack.location} • ${activeTrack.duration}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.champagneGold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Track Selector List
          const Text(
            'CURATED ATMOSPHERIC SOUNDSCAPES',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 12),
          ..._tracks.asMap().entries.map((entry) {
            final idx = entry.key;
            final track = entry.value;
            final isSelected = _selectedTrackIndex == idx;

            return GestureDetector(
              onTap: () {
                HapticService.selection();
                setState(() {
                  _selectedTrackIndex = idx;
                  _isPlaying = true;
                });
                AtelierController.to.playSoundscapeTrack(track);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A1630) : const Color(0xFF111115),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.champagneGold
                        : Colors.white.withValues(alpha: 0.08),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.champagneGold.withValues(alpha: 0.2)
                            : Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        track.icon,
                        color: isSelected ? AppColors.champagneGold : Colors.white60,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.champagneGold : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            track.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          // Spatial Acoustics & Reverb Controls
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF161229),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SPATIAL ACOUSTIC REVERB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.champagneGold, letterSpacing: 1.0)),
                    Text('${(_reverbDepth * 100).toInt()}% DEPTH', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.champagneGold,
                    inactiveTrackColor: Colors.white12,
                    thumbColor: AppColors.champagneGold,
                    overlayColor: AppColors.champagneGold.withValues(alpha: 0.2),
                    trackHeight: 3.5,
                  ),
                  child: Slider(
                    value: _reverbDepth,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (val) {
                      HapticService.selection();
                      setState(() => _reverbDepth = val);
                    },
                  ),
                ),
                const Divider(height: 20, color: Colors.white12),

                // Haptic Rhythm Sync Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Haptic Sub-Bass Transients', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        Text('Tactile motor vibrations synchronized to ambient rhythm', style: TextStyle(fontSize: 10, color: Colors.white54)),
                      ],
                    ),
                    CupertinoSwitch(
                      value: _hapticPulseSync,
                      activeTrackColor: AppColors.champagneGold,
                      onChanged: (val) {
                        HapticService.selection();
                        setState(() => _hapticPulseSync = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

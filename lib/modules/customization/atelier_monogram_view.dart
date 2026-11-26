import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';

class MonogramConfig {
  final String initials;
  final String styleName;
  final TextStyle fontStyle;
  final Color threadColor;
  final String threadName;
  final String placement;

  const MonogramConfig({
    required this.initials,
    required this.styleName,
    required this.fontStyle,
    required this.threadColor,
    required this.threadName,
    required this.placement,
  });
}

class AtelierMonogramView extends StatefulWidget {
  final Product product;
  final MonogramConfig? initialConfig;
  final void Function(MonogramConfig config)? onSave;

  const AtelierMonogramView({
    super.key,
    required this.product,
    this.initialConfig,
    this.onSave,
  });

  static Future<MonogramConfig?> show(
    BuildContext context,
    Product product, {
    MonogramConfig? initialConfig,
    void Function(MonogramConfig)? onSave,
  }) {
    HapticService.light();
    return showModalBottomSheet<MonogramConfig>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AtelierMonogramView(
          product: product,
          initialConfig: initialConfig,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<AtelierMonogramView> createState() => _AtelierMonogramViewState();
}

class _AtelierMonogramViewState extends State<AtelierMonogramView> {
  late final TextEditingController _initialsCtrl;
  int _selectedStyleIndex = 0;
  int _selectedThreadIndex = 0;
  int _selectedPlacementIndex = 0;

  final List<Map<String, dynamic>> _styles = [
    {
      'name': 'Imperial Roman',
      'font': GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w700, letterSpacing: 3.0),
    },
    {
      'name': 'French Italic',
      'font': GoogleFonts.cormorantGaramond(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, letterSpacing: 2.0),
    },
    {
      'name': 'Modern Linear',
      'font': GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, letterSpacing: 3.5),
    },
  ];

  final List<Map<String, dynamic>> _threads = [
    {
      'name': 'Champagne Gold',
      'color': const Color(0xFFD4AF37),
    },
    {
      'name': 'Obsidian Tone-on-Tone',
      'color': const Color(0xFF26262B),
    },
    {
      'name': 'Silver Thread',
      'color': const Color(0xFFE0E0E6),
    },
    {
      'name': 'Crimson Seal',
      'color': const Color(0xFF8B1E1E),
    },
  ];

  final List<String> _placements = const [
    'Inner Chest Facing',
    'Left Sleeve Cuff',
    'Silk Lining Hem',
  ];

  @override
  void initState() {
    super.initState();
    _initialsCtrl = TextEditingController(
      text: widget.initialConfig?.initials ?? 'C.D.',
    );
    if (widget.initialConfig != null) {
      final styleIdx = _styles.indexWhere((s) => s['name'] == widget.initialConfig!.styleName);
      if (styleIdx != -1) _selectedStyleIndex = styleIdx;
      final threadIdx = _threads.indexWhere((t) => t['name'] == widget.initialConfig!.threadName);
      if (threadIdx != -1) _selectedThreadIndex = threadIdx;
      final placeIdx = _placements.indexOf(widget.initialConfig!.placement);
      if (placeIdx != -1) _selectedPlacementIndex = placeIdx;
    }
  }

  @override
  void dispose() {
    _initialsCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    HapticService.heavy();
    final config = MonogramConfig(
      initials: _initialsCtrl.text.toUpperCase(),
      styleName: _styles[_selectedStyleIndex]['name'] as String,
      fontStyle: _styles[_selectedStyleIndex]['font'] as TextStyle,
      threadColor: _threads[_selectedThreadIndex]['color'] as Color,
      threadName: _threads[_selectedThreadIndex]['name'] as String,
      placement: _placements[_selectedPlacementIndex],
    );

    widget.onSave?.call(config);
    Navigator.of(context).pop(config);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final activeStyle = _styles[_selectedStyleIndex];
    final activeThread = _threads[_selectedThreadIndex];
    final activeColor = activeThread['color'] as Color;

    return Container(
      constraints: BoxConstraints(maxHeight: size.height * 0.90),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C0A19) : AppColors.canvasLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                          'BESPOKE EMBROIDERY STUDIO',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Personalized Monogram',
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

          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                // Live Fabric Embroidery Preview Canvas
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF17132C) : const Color(0xFFEBE8E1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.35)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Fabric Twill Weave Texture Lines
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _FabricTexturePainter(isDark: isDark),
                        ),
                      ),

                      // Embroidered Initials Rendering
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _initialsCtrl.text.trim().isEmpty ? 'A • T' : _initialsCtrl.text.toUpperCase(),
                            style: (activeStyle['font'] as TextStyle).copyWith(
                              fontSize: 38,
                              color: activeColor,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'HAND-STITCHED EMBROIDERY • ${_placements[_selectedPlacementIndex].toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: AppColors.champagneGold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 1. Initials Text Input
                Text(
                  '1. ENTER INITIALS (MAX 3 CHARACTERS)',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _initialsCtrl,
                  maxLength: 5,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. C.D. or J.M.',
                    counterText: '',
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Embroidery Font Style
                Text(
                  '2. TYPOGRAPHIC EMBROIDERY STYLE',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _styles.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final style = entry.value;
                    final isSelected = _selectedStyleIndex == idx;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selection();
                          setState(() => _selectedStyleIndex = idx);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: EdgeInsets.only(right: idx < _styles.length - 1 ? 8 : 0),
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
                              style['name'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? AppColors.canvasDark : Colors.white)
                                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 3. Thread Color Selection
                Text(
                  '3. SILK & METALLIC THREAD COLOR: ${activeThread['name'].toUpperCase()}',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _threads.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final thread = entry.value;
                    final isSelected = _selectedThreadIndex == idx;
                    final color = thread['color'] as Color;

                    return GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        setState(() => _selectedThreadIndex = idx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 14),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.champagneGold : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 4. Placement Option Chips
                Text(
                  '4. EMBROIDERY LOCATION',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _placements.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final placement = entry.value;
                    final isSelected = _selectedPlacementIndex == idx;

                    return GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        setState(() => _selectedPlacementIndex = idx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.champagneGold
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          ),
                        ),
                        child: Text(
                          placement,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Confirm Monogram Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: _handleSave,
                    child: Text(
                      'APPLY COMPLIMENTARY EMBROIDERY',
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

class _FabricTexturePainter extends CustomPainter {
  final bool isDark;

  const _FabricTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    for (double i = -size.height; i < size.width; i += 6) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

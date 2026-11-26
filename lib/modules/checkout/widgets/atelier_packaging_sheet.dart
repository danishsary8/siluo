import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';

class PackagingOption {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;

  const PackagingOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
  });
}

class AtelierPackagingSheet extends StatefulWidget {
  final String selectedPackagingId;
  final String giftNote;
  final bool isGift;
  final void Function(String packagingId, bool isGift, String giftNote) onSave;

  const AtelierPackagingSheet({
    super.key,
    required this.selectedPackagingId,
    required this.giftNote,
    required this.isGift,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required String selectedPackagingId,
    required String giftNote,
    required bool isGift,
    required void Function(String packagingId, bool isGift, String giftNote) onSave,
  }) {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AtelierPackagingSheet(
          selectedPackagingId: selectedPackagingId,
          giftNote: giftNote,
          isGift: isGift,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<AtelierPackagingSheet> createState() => _AtelierPackagingSheetState();
}

class _AtelierPackagingSheetState extends State<AtelierPackagingSheet> {
  late String _selectedId;
  late bool _isGift;
  late TextEditingController _noteCtrl;

  final List<PackagingOption> _options = const [
    PackagingOption(
      id: 'obsidian_box',
      title: 'Signature Obsidian Box',
      subtitle:
          'Rigid noir keepsake box with champagne foil insignia, double-faced grosgrain ribbon, & scented cedar tissue.',
      badge: 'COMPLIMENTARY',
      icon: CupertinoIcons.gift_fill,
    ),
    PackagingOption(
      id: 'organic_linen',
      title: 'Organic Linen Garment Pouch',
      subtitle:
          '100% unbleached raw organic linen travel garment bag with horn buttons and certified recycled paper mailer.',
      badge: 'ZERO WASTE',
      icon: CupertinoIcons.leaf_arrow_circlepath,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedPackagingId;
    _isGift = widget.isGift;
    _noteCtrl = TextEditingController(text: widget.giftNote);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(maxHeight: size.height * 0.88),
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
                          'THE ATELIER UNBOXING RITUAL',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Signature Presentation',
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

          // Content
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                // Packaging selection cards
                ..._options.map((opt) {
                  final isSelected = opt.id == _selectedId;
                  return GestureDetector(
                    onTap: () {
                      HapticService.selection();
                      setState(() => _selectedId = opt.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.champagneGold
                              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          width: isSelected ? 1.8 : 1.0,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.champagneGold.withValues(alpha: 0.2),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.champagneGold.withValues(alpha: 0.15)
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              opt.icon,
                              size: 24,
                              color: isSelected ? AppColors.champagneGold : (isDark ? Colors.white60 : Colors.black54),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      opt.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.champagneGold.withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        opt.badge,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                          color: AppColors.champagneGold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  opt.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
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
                  );
                }),

                const SizedBox(height: 12),

                // Gift switch
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.sparkles, color: AppColors.champagneGold, size: 20),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This order is a gift',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                'Hide price tags & include calligraphy card',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: _isGift,
                        activeTrackColor: AppColors.champagneGold,
                        onChanged: (val) {
                          HapticService.selection();
                          setState(() => _isGift = val);
                        },
                      ),
                    ],
                  ),
                ),

                // Calligraphy card input & preview
                if (_isGift) ...[
                  const SizedBox(height: 18),
                  Text(
                    'HANDWRITTEN CALLIGRAPHY NOTE',
                    style: AppTypography.microTag(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    maxLength: 120,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'e.g. To my dearest, celebrating your radiant beauty...',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white30 : Colors.black26,
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Live Calligraphy Parchment Card Preview
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1B1733) : const Color(0xFFF5F2FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.champagneGold.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'A T E L I E R',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 3.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.champagneGold.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _noteCtrl.text.trim().isEmpty
                              ? '“May this piece accompany you on your most memorable journeys.”'
                              : '“${_noteCtrl.text.trim()}”',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF2C2723),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8B1E1E), // Atelier Crimson wax seal
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'serif',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      HapticService.success();
                      widget.onSave(_selectedId, _isGift, _noteCtrl.text.trim());
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'CONFIRM PRESENTATION',
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

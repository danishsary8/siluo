import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';

class ArchivalTextile {
  final String id;
  final String name;
  final String provenance;
  final String weight;
  final String handFeel;
  final Color baseColor;

  const ArchivalTextile({
    required this.id,
    required this.name,
    required this.provenance,
    required this.weight,
    required this.handFeel,
    required this.baseColor,
  });
}

class AtelierSwatchOrderView extends StatefulWidget {
  final Product? product;

  const AtelierSwatchOrderView({super.key, this.product});

  static void show(BuildContext context, {Product? product}) {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AtelierSwatchOrderView(product: product),
    );
  }

  @override
  State<AtelierSwatchOrderView> createState() => _AtelierSwatchOrderViewState();
}

class _AtelierSwatchOrderViewState extends State<AtelierSwatchOrderView> {
  final Set<String> _selectedTextileIds = {};
  bool _isDispatched = false;

  final List<ArchivalTextile> _textiles = const [
    ArchivalTextile(
      id: 'sw_melton',
      name: '520gsm Melton Virgin Wool',
      provenance: 'Lanificio di Tollegno, Biella (Italy)',
      weight: '520 g/m²',
      handFeel: 'Structured, dense, dry-felted warmth',
      baseColor: Color(0xFF1E1A33),
    ),
    ArchivalTextile(
      id: 'sw_silk_charmeuse',
      name: 'Mulberry Silk Satin Charmeuse',
      provenance: 'Ateliers de Tissage, Lyon (France)',
      weight: '19 momme (82 g/m²)',
      handFeel: 'Liquid, ultra-fluid, cool pearlescent sheen',
      baseColor: Color(0xFFE8DCC8),
    ),
    ArchivalTextile(
      id: 'sw_cashmere_double',
      name: 'Double-Faced Alashan Cashmere',
      provenance: 'Inner Mongolian Plateau & Biella finishing',
      weight: '480 g/m²',
      handFeel: 'Supreme softness, cloud-like loft',
      baseColor: Color(0xFFC4A880),
    ),
    ArchivalTextile(
      id: 'sw_barathea_tux',
      name: 'Midnight Barathea Suiting Wool',
      provenance: 'Huddersfield Mill, Yorkshire (England)',
      weight: '340 g/m²',
      handFeel: 'Granular crepe weave, razor-sharp crease retention',
      baseColor: Color(0xFF141724),
    ),
    ArchivalTextile(
      id: 'sw_corded_lace',
      name: 'French Corded Chantilly Lace',
      provenance: 'Manufacture Dentellière, Caudry (France)',
      weight: '120 g/m²',
      handFeel: 'Delicate openwork, raised silk cord relief',
      baseColor: Color(0xFF27223F),
    ),
    ArchivalTextile(
      id: 'sw_alpaca_shearling',
      name: 'High-Alpine Suri Alpaca Wool',
      provenance: 'Peruvian Andes & Biella spun',
      weight: '610 g/m²',
      handFeel: 'Plush shearling nap, natural thermal insulation',
      baseColor: Color(0xFF7E7365),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select first item or category match
    _selectedTextileIds.add(_textiles.first.id);
    if (_textiles.length > 1) _selectedTextileIds.add(_textiles[1].id);
  }

  void _toggleTextile(String id) {
    HapticService.selection();
    setState(() {
      if (_selectedTextileIds.contains(id)) {
        if (_selectedTextileIds.length > 1) {
          _selectedTextileIds.remove(id);
        } else {
          Get.snackbar(
            'Minimum Selection',
            'Select at least 1 fabric swatch for your presentation envelope.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        }
      } else {
        if (_selectedTextileIds.length < 3) {
          _selectedTextileIds.add(id);
        } else {
          Get.snackbar(
            'Maximum Vault Limit',
            'You may curate up to 3 complimentary cuttings per shipment.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: AppColors.champagneGold,
            margin: const EdgeInsets.all(16),
          );
        }
      }
    });
  }

  void _dispatchSampleBox() {
    HapticService.heavy();
    setState(() => _isDispatched = true);

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pop();
        Get.snackbar(
          'Archival Swatches Dispatched',
          'Complimentary wax-sealed envelope scheduled via Paris Priority Courier.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: AppColors.champagneGold,
          icon: const Icon(CupertinoIcons.checkmark_seal_fill, color: AppColors.champagneGold),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

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
                      'L’ÉCHANTILLONNAGE TEXTILE',
                      style: AppTypography.brandLogo(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Complimentary 10×10 cm Archival Cuttings in Wax-Sealed Linen Envelope',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    size: 24,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main Swatches List
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              children: [
                // Packaging Preview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF17132C) : const Color(0xFFF3F0FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.champagneGold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B1E1E),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B1E1E).withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.rosette,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORIGAMI LINEN PRESENTATION ENVELOPE',
                              style: AppTypography.microTag(color: AppColors.champagneGold),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${_selectedTextileIds.length} of 3 Cuttings Selected (Hand-waxed seal)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'SELECT ARCHIVAL TEXTILES',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),

                // Textiles List
                ..._textiles.map((textile) {
                  final isSelected = _selectedTextileIds.contains(textile.id);

                  return GestureDetector(
                    onTap: () => _toggleTextile(textile.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.champagneGold.withValues(alpha: isDark ? 0.15 : 0.08)
                            : (isDark ? const Color(0xFF161229) : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.champagneGold
                              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Color / Material Fabric Swatch Circle
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: textile.baseColor,
                              border: Border.all(
                                color: AppColors.champagneGold.withValues(alpha: 0.5),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(
                                      CupertinoIcons.checkmark,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textile.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  textile.provenance,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        textile.weight,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'Courier',
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white70 : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        textile.handFeel,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.champagneGold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom Action
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                    foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 4,
                  ),
                  onPressed: _isDispatched ? null : _dispatchSampleBox,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _isDispatched
                        ? const Row(
                            key: ValueKey('dispatching'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.champagneGold),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'SEALING WITH CRIMSON WAX...',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            key: ValueKey('request'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.gift_fill, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'ORDER COMPLIMENTARY SWATCH VAULT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

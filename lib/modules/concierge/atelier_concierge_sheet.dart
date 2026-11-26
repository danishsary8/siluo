import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../salon/atelier_salon_booking_view.dart';
import 'atelier_consultation_suite_view.dart';

class AtelierConciergeSheet extends StatefulWidget {
  const AtelierConciergeSheet({super.key});

  static void show(BuildContext context) {
    HapticService.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AtelierConciergeSheet(),
    );
  }

  @override
  State<AtelierConciergeSheet> createState() => _AtelierConciergeSheetState();
}

class _AtelierConciergeSheetState extends State<AtelierConciergeSheet> {
  final TextEditingController _messageCtrl = TextEditingController();
  bool _isSent = false;

  final List<String> _quickConsultations = [
    'Bespoke Sizing Advice',
    'Runway Styling Ensemble',
    'Fabric Swatch Delivery',
    'Private Paris Appointment',
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_messageCtrl.text.trim().isNotEmpty) {
      HapticService.success();
      setState(() => _isSent = true);
      _messageCtrl.clear();
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) setState(() => _isSent = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.84,
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

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ATELIER CONCIERGE & REGION', style: AppTypography.microTag(color: AppColors.champagneGold)),
                    const SizedBox(height: 2),
                    Text(
                      'Personal Luxury Services',
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
                // 1. Currency Switcher Section
                Text(
                  'GLOBAL CURRENCY CONVERSION',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final active = controller.selectedCurrencyCode.value;
                  return Row(
                    children: [
                      _buildCurrencyButton('USD', '\$ USD', active == 'USD', controller, isDark),
                      const SizedBox(width: 8),
                      _buildCurrencyButton('EUR', '€ EUR', active == 'EUR', controller, isDark),
                      const SizedBox(width: 8),
                      _buildCurrencyButton('GBP', '£ GBP', active == 'GBP', controller, isDark),
                      const SizedBox(width: 8),
                      _buildCurrencyButton('JPY', '¥ JPY', active == 'JPY', controller, isDark),
                    ],
                  );
                }),
                const SizedBox(height: 28),

                // 2. Personal Stylist Profile Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : const Color(0xFFE7E2F8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.champagneGold, width: 1.5),
                        ),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Camille Laurent',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.inStockGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Head Stylist • Paris Flagship Workshop',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Active now for bespoke curation',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.champagneGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Live Video Consultation Button
                GestureDetector(
                  onTap: () {
                    HapticService.light();
                    Navigator.of(context).pop();
                    Get.to(
                      () => const AtelierConsultationSuiteView(),
                      transition: Transition.fadeIn,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.champagneGold.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.champagneGold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.videocam_fill,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LIVE VIDEO SALON SUITE',
                                style: AppTypography.microTag(color: AppColors.champagneGold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Connect with Éléonore Vance via Remote Catwalk Video',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_right,
                          size: 14,
                          color: AppColors.champagneGold,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Quick Consultation Topics
                Text(
                  'SELECT CONSULTATION PURPOSE',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickConsultations.map((topic) {
                    return GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        _messageCtrl.text = 'I would like to inquire regarding $topic.';
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                          ),
                        ),
                        child: Text(
                          topic,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 4. Message Direct Input
                Text(
                  'MESSAGE CAMILLE',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: TextField(
                    controller: _messageCtrl,
                    maxLines: 3,
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Describe your styling or sizing inquiry...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // In-Store Fitting Button
                GestureDetector(
                  onTap: () {
                    HapticService.selection();
                    Navigator.of(context).pop();
                    Get.to(() => const AtelierSalonBookingView());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.35)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(CupertinoIcons.sparkles, size: 16, color: AppColors.champagneGold),
                            SizedBox(width: 10),
                            Text(
                              'Prefer an in-person private salon fitting?',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.champagneGold),
                            ),
                          ],
                        ),
                        Icon(CupertinoIcons.chevron_right, size: 14, color: AppColors.champagneGold),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSent
                          ? AppColors.inStockGreen
                          : (isDark ? Colors.white : AppColors.ctaDark),
                      foregroundColor: _isSent
                          ? Colors.white
                          : (isDark ? AppColors.canvasDark : Colors.white),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: _handleSendMessage,
                    child: _isSent
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.checkmark_alt, size: 18),
                              SizedBox(width: 8),
                              Text('REQUEST RECEIVED BY CONCIERGE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            ],
                          )
                        : const Text(
                            'DISPATCH INQUIRY TO STYLIST',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
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

  Widget _buildCurrencyButton(
    String code,
    String label,
    bool isSelected,
    AtelierController controller,
    bool isDark,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.switchCurrency(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
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
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isDark ? AppColors.canvasDark : Colors.white)
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

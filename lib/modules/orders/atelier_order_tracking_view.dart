import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../authenticity/atelier_passport_view.dart';
import '../checkout/widgets/unboxing_3d_simulation.dart';
import 'atelier_courier_map_view.dart';

class AtelierOrderTrackingView extends StatelessWidget {
  final String orderId;

  const AtelierOrderTrackingView({
    super.key,
    this.orderId = '#ATL-894201',
  });

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = controller.allProducts.first;

    final steps = [
      {
        'title': 'Order Authenticated',
        'subtitle': 'Verified at Paris Rue de la Paix atelier',
        'time': 'Yesterday, 14:20',
        'isDone': true,
      },
      {
        'title': 'Bespoke Finishing & Quality Audit',
        'subtitle': 'Hand-inspected by master tailor Marc',
        'time': 'Yesterday, 18:45',
        'isDone': true,
      },
      {
        'title': 'Air Transit (DHL Express White Glove)',
        'subtitle': 'Flight AF-104 Departure CDG Airport',
        'time': 'Today, 06:12',
        'isDone': true,
      },
      {
        'title': 'White Glove Courier Delivery',
        'subtitle': 'Estimated arrival at your residence',
        'time': 'Tomorrow by 12:00 PM',
        'isDone': false,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'ORDER DISPATCH',
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
        padding: const EdgeInsets.all(24),
        children: [
          // Order ID & Status Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRACKING REFERENCE', style: AppTypography.microTag(color: AppColors.champagneGold)),
                    const SizedBox(height: 4),
                    Text(
                      orderId,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.inStockGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'IN TRANSIT',
                    style: TextStyle(
                      color: AppColors.inStockGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Milestone Timeline
          Text(
            'DELIVERY MILESTONES',
            style: AppTypography.microTag(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
              ),
            ),
            child: Column(
              children: List.generate(steps.length, (index) {
                final step = steps[index];
                final isDone = step['isDone'] as bool;
                final isLast = index == steps.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? (isDark ? Colors.white : AppColors.ctaDark)
                                  : (isDark ? const Color(0xFF2E2E34) : const Color(0xFFE4E4E7)),
                            ),
                            child: Center(
                              child: Icon(
                                isDone ? CupertinoIcons.checkmark_alt : CupertinoIcons.clock,
                                size: 13,
                                color: isDone
                                    ? (isDark ? Colors.black : Colors.white)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: isDone
                                    ? (isDark ? Colors.white38 : AppColors.ctaDark.withValues(alpha: 0.3))
                                    : (isDark ? Colors.white12 : Colors.black12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step['title'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  Text(
                                    step['time'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.champagneGold : AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                step['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 28),

          // Items in Package
          Text(
            'PACKAGE CONTENTS',
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
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    product.primaryImage,
                    width: 60,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size S • Oatmeal Taupe • Qty 1',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(() => Text(
                            controller.formatPrice(product.price),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.champagneGold,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Live White-Glove Courier & Chauffeur Map Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.champagneGold,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 4,
              ),
              onPressed: () {
                HapticService.light();
                Get.to(
                  () => AtelierCourierMapView(orderId: orderId),
                  transition: Transition.fadeIn,
                );
              },
              icon: const Icon(CupertinoIcons.map_pin_ellipse, size: 18, color: Colors.black),
              label: const Text(
                'TRACK LIVE WHITE-GLOVE CHAUFFEUR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Holographic NFC Passport Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1A1631) : AppColors.ctaDark,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                side: const BorderSide(color: AppColors.champagneGold, width: 1.2),
              ),
              onPressed: () {
                HapticService.light();
                Get.to(
                  () => const AtelierPassportView(
                    serialNumber: 'ATL-8942-PARIS-2026',
                    garmentTitle: 'Double-Breasted Wool & Cashmere Overcoat',
                    artisan: 'M. Marc Duchamp, Maître Tailleur Paris',
                  ),
                  transition: Transition.fadeIn,
                );
              },
              icon: const Icon(CupertinoIcons.radiowaves_right, size: 18, color: AppColors.champagneGold),
              label: const Text(
                'VIEW HOLOGRAPHIC NFC PASSPORT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.champagneGold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Unboxing 3D Ritual Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: const BorderSide(color: AppColors.champagneGold, width: 1.2),
              ),
              onPressed: () {
                HapticService.light();
                Unboxing3dSimulation.show(context, product);
              },
              icon: const Icon(CupertinoIcons.gift_fill, size: 18, color: AppColors.champagneGold),
              label: const Text(
                'EXPERIENCE 3D UNBOXING RITUAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.champagneGold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Download Digital Receipt Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(
                  color: isDark ? Colors.white30 : AppColors.cardBorderLight,
                ),
              ),
              onPressed: () {
                HapticService.selection();
                Get.snackbar(
                  'Digital Receipt',
                  'Atelier Tax Invoice #INV-894201 saved to downloads.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: isDark ? Colors.black87 : Colors.white,
                  colorText: isDark ? Colors.white : Colors.black,
                  margin: const EdgeInsets.all(16),
                );
              },
              icon: Icon(
                CupertinoIcons.doc_text_fill,
                size: 16,
                color: isDark ? Colors.white : AppColors.ctaDark,
              ),
              label: Text(
                'DOWNLOAD OFFICIAL INVOICE (PDF)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white : AppColors.ctaDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

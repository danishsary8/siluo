import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import 'widgets/unboxing_3d_simulation.dart';

class AtelierOrderSuccessView extends StatefulWidget {
  const AtelierOrderSuccessView({super.key});

  @override
  State<AtelierOrderSuccessView> createState() => _AtelierOrderSuccessViewState();
}

class _AtelierOrderSuccessViewState extends State<AtelierOrderSuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Celebratory Animated Checkmark Circle
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.inStockGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.inStockGreen.withValues(alpha: 0.3),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.checkmark_alt,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Order confirmed',
                style: AppTypography.displayHero(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for shopping with SILOU. Your order has been placed and is being prepared in our Paris workshop.',
                textAlign: TextAlign.center,
                style: AppTypography.body(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 28),

              // Tracking Badge & Delivery estimate
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order number',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          '#ATL-894201',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated delivery',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                        ),
                        Text(
                          _deliveryWindow(DateTime.now()),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Unboxing Ritual Interactive Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: AppColors.champagneGold, width: 1.5),
                  ),
                  onPressed: () {
                    HapticService.light();
                    Unboxing3dSimulation.show(
                      context,
                      AtelierController.to.allProducts.first,
                    );
                  },
                  icon: const Icon(CupertinoIcons.gift_fill, size: 18, color: AppColors.champagneGold),
                  label: const Text(
                    'EXPERIENCE UNBOXING RITUAL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.champagneGold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Continue Shopping CTA
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                    foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    HapticService.selection();
                    AtelierController.to.switchTab(0);
                    Get.back(); // Dismiss checkout/success
                  },
                  child: Text(
                    'CONTINUE EXPLORING',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.canvasDark : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Express delivery window shown after checkout: 2 to 5 days from [orderedAt],
/// e.g. `Nov 28 – Dec 1`.
String _deliveryWindow(DateTime orderedAt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  String fmt(DateTime d) => '${months[d.month - 1]} ${d.day}';
  return '${fmt(orderedAt.add(const Duration(days: 2)))} – ${fmt(orderedAt.add(const Duration(days: 5)))}';
}

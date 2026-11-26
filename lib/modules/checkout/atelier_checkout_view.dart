import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import 'widgets/atelier_packaging_sheet.dart';
import 'atelier_order_success_view.dart';
import '../../controllers/account_controller.dart';
import '../account/atelier_address_book_view.dart';

class AtelierCheckoutView extends StatefulWidget {
  const AtelierCheckoutView({super.key});

  @override
  State<AtelierCheckoutView> createState() => _AtelierCheckoutViewState();
}

class _AtelierCheckoutViewState extends State<AtelierCheckoutView> {
  final int _currentStep = 1; // 0: Address, 1: Payment, 2: Review
  String _selectedPaymentMethod = 'Apple Pay';
  String _selectedPackaging = 'obsidian_box';
  bool _isGift = false;
  String _giftNote = '';

  final List<Map<String, dynamic>> _paymentOptions = [
    {
      'title': 'Apple Pay',
      'subtitle': 'Fast and secure contactless payment',
      'icon': CupertinoIcons.device_phone_portrait,
    },
    {
      'title': 'Credit Card',
      'subtitle': 'Visa, Mastercard, Amex (•••• 4921)',
      'icon': CupertinoIcons.creditcard_fill,
    },
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay in cash upon package arrival',
      'icon': CupertinoIcons.money_dollar_circle_fill,
    },
  ];

  void _handlePlaceOrder(AtelierController controller) {
    HapticService.success();
    // Clear cart and show order confirmation
    controller.clearCart();
    Get.off(() => const AtelierOrderSuccessView());
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'CHECKOUT',
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
      body: Column(
        children: [
          // 3-Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                _buildStepCircle(0, 'Address', _currentStep >= 0, isDark),
                _buildStepLine(_currentStep >= 1, isDark),
                _buildStepCircle(1, 'Payment', _currentStep >= 1, isDark),
                _buildStepLine(_currentStep >= 2, isDark),
                _buildStepCircle(2, 'Review', _currentStep >= 2, isDark),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Delivery Address Card
                Text(
                  'DELIVERY ADDRESS',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                final addr = AccountController.to.defaultAddress;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.location_solid, color: AppColors.champagneGold, size: 24),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addr?.fullName ?? 'Add a delivery address',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addr?.twoLines ?? 'Tap Edit to choose where we deliver',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticService.light();
                          Get.to<void>(() => const AtelierAddressBookView(selectMode: true));
                        },
                        child: const Text('Edit', style: TextStyle(color: AppColors.champagneGold)),
                      ),
                    ],
                  ),
                );
                }),
                const SizedBox(height: 24),

                // Signature Packaging & Unboxing Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PACKAGING & PRESENTATION',
                      style: AppTypography.microTag(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AtelierPackagingSheet.show(
                          context,
                          selectedPackagingId: _selectedPackaging,
                          giftNote: _giftNote,
                          isGift: _isGift,
                          onSave: (pkgId, isGift, note) {
                            setState(() {
                              _selectedPackaging = pkgId;
                              _isGift = isGift;
                              _giftNote = note;
                            });
                          },
                        );
                      },
                      child: const Text(
                        'Customize',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.champagneGold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    AtelierPackagingSheet.show(
                      context,
                      selectedPackagingId: _selectedPackaging,
                      giftNote: _giftNote,
                      isGift: _isGift,
                      onSave: (pkgId, isGift, note) {
                        setState(() {
                          _selectedPackaging = pkgId;
                          _isGift = isGift;
                          _giftNote = note;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.champagneGold.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.champagneGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _selectedPackaging == 'obsidian_box'
                                ? CupertinoIcons.gift_fill
                                : CupertinoIcons.leaf_arrow_circlepath,
                            color: AppColors.champagneGold,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedPackaging == 'obsidian_box'
                                    ? 'Signature Obsidian Keepsake Box'
                                    : 'Organic Linen Garment Pouch',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isGift
                                    ? 'Gift Order • Includes Calligraphy Card'
                                    : 'Complimentary luxury editorial presentation',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.champagneGold : AppColors.textMuted,
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
                const SizedBox(height: 28),

                // Payment Method Selector
                Text(
                  'PAYMENT METHOD',
                  style: AppTypography.microTag(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: _paymentOptions.map((opt) {
                    final isSelected = _selectedPaymentMethod == opt['title'];
                    return GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        setState(() => _selectedPaymentMethod = opt['title'] as String);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? Colors.white : AppColors.ctaDark)
                                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              opt['icon'] as IconData,
                              size: 22,
                              color: isSelected
                                  ? (isDark ? Colors.white : AppColors.ctaDark)
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    opt['title'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  Text(
                                    opt['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? (isDark ? Colors.white : AppColors.ctaDark)
                                      : (isDark ? Colors.white38 : Colors.black26),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark ? Colors.white : AppColors.ctaDark,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Order Total Confirmation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1D1836) : const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payable',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Obx(() => Text(
                            controller.formatPrice(controller.grandTotal),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Place Order CTA
          SafeArea(
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
                  onPressed: () => _handlePlaceOrder(controller),
                  child: Text(
                    'COMPLETE PURCHASE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.canvasDark : Colors.white,
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

  Widget _buildStepCircle(int step, String label, bool isReached, bool isDark) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReached
                ? (isDark ? Colors.white : AppColors.ctaDark)
                : (isDark ? AppColors.surfaceDark : const Color(0xFFE5E5E5)),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isReached
                    ? (isDark ? AppColors.canvasDark : Colors.white)
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isReached
                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                : AppColors.textLightMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isReached, bool isDark) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14),
        color: isReached
            ? (isDark ? Colors.white : AppColors.ctaDark)
            : (isDark ? Colors.white24 : Colors.black12),
      ),
    );
  }
}

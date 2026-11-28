import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/cart_item_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../../shared/widgets/editorial_shimmer_box.dart';
import '../checkout/atelier_checkout_view.dart';
import '../../shared/widgets/auth_gate.dart';

class AtelierCartView extends StatefulWidget {
  const AtelierCartView({super.key});

  @override
  State<AtelierCartView> createState() => _AtelierCartViewState();
}

class _AtelierCartViewState extends State<AtelierCartView> {
  final TextEditingController _promoCtrl = TextEditingController();
  String _promoFeedback = '';

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo(AtelierController controller) {
    final success = controller.applyPromoCode(_promoCtrl.text);
    setState(() {
      if (success) {
        _promoFeedback = '20% SILOU VIP discount applied!';
      } else {
        _promoFeedback = 'Invalid promo code. Try "SILOU20"';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final items = controller.cartItems;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bag,
                    size: 56,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your bag is empty',
                    style: AppTypography.sectionTitle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pieces you add will appear here.',
                    style: AppTypography.body(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    ),
                    onPressed: () => controller.switchTab(0),
                    child: Text(
                      'START SHOPPING',
                      style: AppTypography.buttonLabel(
                        color: isDark ? AppColors.canvasDark : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Editorial Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your bag',
                            style: AppTypography.sectionTitle(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          Text(
                            '${controller.totalCartItemsCount} ${controller.totalCartItemsCount == 1 ? 'item' : 'items'}',
                            style: AppTypography.headingMeta(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Cart Items List with Swipe-to-delete
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return _buildCartItemCard(item, controller, isDark);
                        },
                        childCount: items.length,
                      ),
                    ),
                  ),

                  // Promo Code Box
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Promo code',
                              style: AppTypography.headingMeta(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 44,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF17132C) : const Color(0xFFF5F3FD),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _promoCtrl,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter a code, e.g. SILOU20',
                                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                                      foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => _applyPromo(controller),
                                    child: const Text('APPLY'),
                                  ),
                                ),
                              ],
                            ),
                            if (_promoFeedback.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                _promoFeedback,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: controller.discountPercent.value > 0
                                      ? AppColors.inStockGreen
                                      : AppColors.saleRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Order Summary Breakdown
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Container(
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
                            _buildSummaryRow(
                              'Subtotal',
                              controller.formatPrice(controller.subtotal),
                              isDark,
                            ),
                            if (controller.discountPercent.value > 0) ...[
                              const SizedBox(height: 10),
                              _buildSummaryRow(
                                'VIP Discount (15%)',
                                '-${controller.formatPrice(controller.discountAmount)}',
                                isDark,
                                isDiscount: true,
                              ),
                            ],
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              'Shipping',
                              controller.shippingFee == 0
                                  ? 'Free'
                                  : controller.formatPrice(controller.shippingFee),
                              isDark,
                              isFreeShipping: controller.shippingFee == 0,
                            ),
                            const SizedBox(height: 10),
                            _buildSummaryRow(
                              'Estimated tax (8%)',
                              controller.formatPrice(controller.taxAmount),
                              isDark,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1),
                            ),
                            _buildSummaryRow(
                              'Total',
                              controller.formatPrice(controller.grandTotal),
                              isDark,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 160)),
                ],
              ),

              // Sticky Floating Checkout Bar
              Positioned(
                bottom: 90,
                left: 20,
                right: 20,
                child: LiquidGlassContainer(
                  borderRadius: 30,
                  blur: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.88),
                  borderColor: isDark
                      ? Colors.white.withValues(alpha: 0.14)
                      : Colors.white.withValues(alpha: 0.9),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order total',
                            style: AppTypography.headingMeta(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                            ),
                          ),
                          Obx(() => Text(
                                controller.formatPrice(controller.grandTotal),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                              foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              HapticService.light();
                              AuthGate.open(() => const AtelierCheckoutView(), reason: 'Sign in to check out securely');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'PROCEED TO CHECKOUT',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: isDark ? AppColors.canvasDark : Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(CupertinoIcons.arrow_right, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, AtelierController controller, bool isDark) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.removeFromCart(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.saleRed,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isDark ? const Color(0xFF241F3A) : const Color(0xFFEFECF8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                item.selectedColor.images.isNotEmpty
                    ? item.selectedColor.images.first
                    : item.product.primaryImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, size: 24, color: Colors.grey),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const EditorialShimmerBox(
                    width: 80,
                    height: 100,
                    borderRadius: BorderRadius.zero,
                  );
                },
              ),
            ),
            const SizedBox(width: 14),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.productTitle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.selectedColor.color,
                          border: Border.all(color: Colors.black12, width: 0.8),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${item.selectedColor.name} • Size ${item.selectedSize}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (item.monogramSummary != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.champagneGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.champagneGold.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.sparkles,
                            size: 11,
                            color: AppColors.champagneGold,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Bespoke Monogram: ${item.monogramSummary}',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: isDark ? AppColors.champagneGold : const Color(0xFF4B2FD6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            controller.formatPrice(item.totalPrice),
                            style: AppTypography.priceTag(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          )),

                      // Quantity Stepper
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF27223F) : const Color(0xFFF3F1FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              icon: const Icon(CupertinoIcons.minus, size: 14),
                              onPressed: () => controller.updateQuantity(item.id, -1),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              icon: const Icon(CupertinoIcons.plus, size: 14),
                              onPressed: () => controller.updateQuantity(item.id, 1),
                            ),
                          ],
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
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isDiscount = false,
    bool isFreeShipping = false,
    bool isTotal = false,
  }) {
    final textColor = isTotal
        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
        : (isDark ? AppColors.textMutedDark : AppColors.textMuted);

    final valueColor = isDiscount
        ? AppColors.saleRed
        : isFreeShipping
            ? AppColors.inStockGreen
            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

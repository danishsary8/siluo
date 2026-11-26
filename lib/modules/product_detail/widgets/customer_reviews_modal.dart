import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../data/models/product_model.dart';

class CustomerReviewsModal extends StatelessWidget {
  final Product product;

  const CustomerReviewsModal({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    HapticService.selection();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerReviewsModal(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final reviews = [
      {
        'author': 'Éléonore Moreau',
        'location': 'Paris, France',
        'rating': 5.0,
        'size': 'Purchased Size S',
        'date': '3 days ago',
        'title': 'Pure architectural perfection',
        'content':
            'The virgin wool drape is exquisite. It holds its structured silhouette even when left unbelted. An absolute staple that rivals heritage houses at twice the price.',
      },
      {
        'author': 'Kaito Tanaka',
        'location': 'Tokyo, Japan',
        'rating': 4.9,
        'size': 'Purchased Size M',
        'date': '1 week ago',
        'title': 'Sublime textures and precision',
        'content':
            'The hand-carved horn buttons and storm flap detailing are remarkable. True to size with enough relaxed shoulder room for cashmere layering.',
      },
      {
        'author': 'Sophia Sterling',
        'location': 'New York, USA',
        'rating': 5.0,
        'size': 'Purchased Size S',
        'date': '2 weeks ago',
        'title': 'Compliments from everyone in SoHo',
        'content':
            'Arrived in pristine packaging with wooden Atelier garment hanger and dust cover. Truly a white-glove experience from ordering to unboxing.',
      },
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
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

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CLIENT CRITIQUE & REVIEWS', style: AppTypography.microTag(color: AppColors.champagneGold)),
                    const SizedBox(height: 2),
                    Text(
                      'Verified Client Perspectives',
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
                // Rating Score & Fit Breakdown
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.cardBorderDark : const Color(0xFFE7E2F8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: List.generate(
                                          5,
                                          (_) => const Icon(
                                            Icons.star_rounded,
                                            size: 16,
                                            color: AppColors.champagneGold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Based on ${product.reviewsCount} verified audits',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.inStockGreen.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '92% TRUE TO SIZE',
                              style: TextStyle(
                                color: AppColors.inStockGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Sizing scale bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Container(height: 6, color: Colors.grey.shade400)),
                            const SizedBox(width: 2),
                            Expanded(flex: 92, child: Container(height: 6, color: AppColors.champagneGold)),
                            const SizedBox(width: 2),
                            Expanded(flex: 4, child: Container(height: 6, color: Colors.grey.shade400)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Runs Small (4%)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                          Text('True to Size (92%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.champagneGold : AppColors.ctaDark)),
                          Text('Runs Large (4%)', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Reviews List
                ...reviews.map((rev) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rev['author'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                Text(
                                  '${rev['location']} • ${rev['size']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 14, color: AppColors.champagneGold),
                                const SizedBox(width: 2),
                                Text(
                                  (rev['rating'] as double).toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          rev['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rev['content'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

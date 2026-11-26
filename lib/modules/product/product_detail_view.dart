import 'package:clothing_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/product.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/animated_primary_button.dart';
import '../../widgets/rating_stars.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late Product product;
  late CartController cartController;

  String selectedSize = '';
  int selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as Product;
    cartController = Get.find<CartController>();

    if (product.sizes.isNotEmpty) {
      selectedSize = product.sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF7A5CF4);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.toNamed(AppRoutes.cart),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12.withValues(alpha: 0.06)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Hero(
                      tag: product.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name + Price + Rating
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${product.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: primary,
                                ),
                              ),
                              RatingStars(
                                rating: product.rating,
                                reviews: product.reviews,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Size
                    if (product.sizes.isNotEmpty) ...[
                      _Card(
                        title: "Size",
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: product.sizes.map((size) {
                            final isSelected = size == selectedSize;
                            return ChoiceChip(
                              label: Text(size),
                              selected: isSelected,
                              selectedColor: primary,
                              backgroundColor: const Color(0xFFEEEAFB),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: isSelected
                                      ? primary
                                      : Colors.black.withValues(alpha: 0.08),
                                ),
                              ),
                              onSelected: (_) {
                                setState(() => selectedSize = size);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Color
                    _Card(
                      title: "Color",
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(product.colors.length, (index) {
                          final isSelected = index == selectedColorIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedColorIndex = index);
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(product.colors[index]),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? primary : Colors.black12,
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                  size: 18, color: Colors.white)
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Description
                    _Card(
                      title: "Description",
                      child: Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: AnimatedPrimaryButton(
                    text: "Add to Cart",
                    onTap: () {
                      cartController.add(product);
                      Get.snackbar(
                        "Added to Cart",
                        "${product.name} added successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        margin: const EdgeInsets.all(12),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String? title;
  final Widget child;

  const _Card({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}

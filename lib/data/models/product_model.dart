import 'package:flutter/material.dart';

class ProductColorVariant {
  final String name;
  final Color color;
  final List<String> images;

  const ProductColorVariant({
    required this.name,
    required this.color,
    required this.images,
  });
}

class Product {
  final String id;
  final String title;
  final String category;
  final String brand;
  final String gender;
  final double price;
  final double? originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewsCount;
  final String fabricCare;
  final String sizeFitNotes;
  final String description;
  final int stockLeft;
  final List<String> sizes;
  final List<ProductColorVariant> colorVariants;
  final bool isNewSeason;
  final bool isTrending;
  final bool isFlashDeal;
  final bool isBestSeller;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    this.brand = 'SILOU',
    this.gender = 'Women',
    required this.price,
    this.originalPrice,
    this.discountPercent = 0,
    required this.rating,
    required this.reviewsCount,
    required this.fabricCare,
    required this.sizeFitNotes,
    required this.description,
    required this.stockLeft,
    required this.sizes,
    required this.colorVariants,
    this.isNewSeason = false,
    this.isTrending = false,
    this.isFlashDeal = false,
    this.isBestSeller = false,
  });

  int get computedDiscountPercent {
    if (discountPercent > 0) return discountPercent;
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return 0;
  }

  String get primaryImage => colorVariants.isNotEmpty && colorVariants.first.images.isNotEmpty
      ? colorVariants.first.images.first
      : '';
}

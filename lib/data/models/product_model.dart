import 'package:flutter/material.dart';

import 'json_utils.dart';

/// One colourway of a [Product], with its own gallery images.
class ProductColorVariant {
  /// Display name, e.g. `Classic Camel`.
  final String name;

  /// Swatch colour shown in the colour picker.
  final Color color;

  /// Gallery image URLs for this colourway (first is the primary image).
  final List<String> images;

  const ProductColorVariant({
    required this.name,
    required this.color,
    required this.images,
  });

  /// Parses the `colorVariants[]` item of the product JSON (see docs/API.md).
  factory ProductColorVariant.fromJson(JsonMap json) => ProductColorVariant(
        name: json.str('name'),
        color: colorFromHex(json.str('hex')),
        images: json.strList('images'),
      );

  /// Serialises to the API JSON shape.
  JsonMap toJson() => {'name': name, 'hex': colorToHex(color), 'images': images};
}

/// A catalogue item as returned by `GET /products` (see docs/API.md).
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

  /// Parses one item of `GET /products`. Throws [FormatException] when a
  /// required field is missing or has the wrong type.
  factory Product.fromJson(JsonMap json) => Product(
        id: json.str('id'),
        title: json.str('title'),
        category: json.str('category'),
        brand: json.strOrNull('brand') ?? 'SILOU',
        gender: json.strOrNull('gender') ?? 'Women',
        price: json.dbl('price'),
        originalPrice: json.dblOrNull('originalPrice'),
        discountPercent: json.integerOr('discountPercent', 0),
        rating: json.dbl('rating'),
        reviewsCount: json.integer('reviewsCount'),
        fabricCare: json.str('fabricCare'),
        sizeFitNotes: json.str('sizeFitNotes'),
        description: json.str('description'),
        stockLeft: json.integer('stockLeft'),
        sizes: json.strList('sizes'),
        colorVariants: json.objList('colorVariants', ProductColorVariant.fromJson),
        isNewSeason: json.boolOr('isNewSeason'),
        isTrending: json.boolOr('isTrending'),
        isFlashDeal: json.boolOr('isFlashDeal'),
        isBestSeller: json.boolOr('isBestSeller'),
      );

  /// Serialises to the API JSON shape (used by the mock API and tests).
  JsonMap toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'brand': brand,
        'gender': gender,
        'price': price,
        if (originalPrice != null) 'originalPrice': originalPrice,
        'discountPercent': discountPercent,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'fabricCare': fabricCare,
        'sizeFitNotes': sizeFitNotes,
        'description': description,
        'stockLeft': stockLeft,
        'sizes': sizes,
        'colorVariants': colorVariants.map((v) => v.toJson()).toList(),
        'isNewSeason': isNewSeason,
        'isTrending': isTrending,
        'isFlashDeal': isFlashDeal,
        'isBestSeller': isBestSeller,
      };

  /// Discount to display: the explicit [discountPercent], or one derived from
  /// [originalPrice].
  int get computedDiscountPercent {
    if (discountPercent > 0) return discountPercent;
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return 0;
  }

  /// First image of the first colourway, or an empty string when none.
  String get primaryImage => colorVariants.isNotEmpty && colorVariants.first.images.isNotEmpty
      ? colorVariants.first.images.first
      : '';
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/soundscape_model.dart';
import '../data/mock/mock_atelier_data.dart';
import '../core/utils/haptic_service.dart';

class AtelierController extends GetxController {
  static AtelierController get to => Get.find<AtelierController>();

  // Navigation
  final RxInt currentTabIndex = 0.obs;

  // Theme
  final RxBool isDarkMode = false.obs;

  // Products
  final RxList<Product> allProducts = <Product>[].obs;
  final RxString selectedDepartment = 'Women'.obs;
  final RxString selectedBrand = 'All'.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  // Wishlist
  final RxSet<String> wishlistProductIds = <String>{}.obs;

  // Cart
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxString promoCode = ''.obs;
  final RxDouble discountPercent = 0.0.obs;

  // Filters
  final Rx<RangeValues> priceRange = const RangeValues(10, 200).obs;
  final RxList<String> selectedFilterSizes = <String>[].obs;
  final RxString sortBy = 'Featured'.obs;

  // Recently Viewed Memory
  final RxList<Product> recentlyViewed = <Product>[].obs;

  // Animation trigger for Cart Bag icon bounce
  final RxInt bagBounceTrigger = 0.obs;

  void recordProductView(Product product) {
    recentlyViewed.removeWhere((p) => p.id == product.id);
    recentlyViewed.insert(0, product);
    if (recentlyViewed.length > 8) {
      recentlyViewed.removeLast();
    }
  }

  @override
  void onInit() {
    super.onInit();
    allProducts.assignAll(mockAtelierProducts);
    // Pre-populate some favorites for aesthetic discovery
    wishlistProductIds.addAll(['atl_01', 'atl_02']);
    // Pre-populate 1 cart item
    final trench = mockAtelierProducts.first;
    cartItems.add(
      CartItem(
        id: 'cart_init_1',
        product: trench,
        selectedSize: 'S',
        selectedColor: trench.colorVariants.first,
        quantity: 1,
      ),
    );
  }

  void switchTab(int index) {
    if (currentTabIndex.value != index) {
      HapticService.selection();
      currentTabIndex.value = index;
    }
  }

  void toggleDarkMode() {
    HapticService.selection();
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void selectDepartment(String dept) {
    HapticService.selection();
    selectedDepartment.value = dept;
  }

  void selectBrand(String brand) {
    HapticService.selection();
    if (selectedBrand.value == brand) {
      selectedBrand.value = 'All';
    } else {
      selectedBrand.value = brand;
    }
  }

  List<String> get availableBrands => [
    'All',
    'Nike',
    'Adidas',
    'Zara',
    "Levi's",
    'Mango',
    'Cotton On',
    'Calvin Klein',
    'Puma',
    'New Balance',
    'H&M',
  ];

  List<Product> get flashDeals =>
      allProducts.where((p) => p.isFlashDeal || p.computedDiscountPercent >= 40).toList();

  List<Product> get bestSellers =>
      allProducts.where((p) => p.isBestSeller || p.rating >= 4.8).toList();

  void selectCategory(String category) {
    HapticService.light();
    selectedCategory.value = category;
  }

  List<Product> get filteredProducts {
    return allProducts.where((p) {
      // Department filter
      if (selectedDepartment.value != 'All') {
        if (selectedDepartment.value == 'Sale') {
          if (p.computedDiscountPercent == 0 && !p.isFlashDeal) return false;
        } else if (selectedDepartment.value == 'Brands') {
          // Keep all or selected brand
        } else if (p.gender != selectedDepartment.value && p.gender != 'Unisex') {
          return false;
        }
      }
      // Brand filter
      if (selectedBrand.value != 'All' &&
          !p.brand.toLowerCase().contains(selectedBrand.value.toLowerCase())) {
        return false;
      }
      // Category filter
      if (selectedCategory.value != 'All' && p.category != selectedCategory.value) {
        return false;
      }
      // Search filter
      if (searchQuery.value.trim().isNotEmpty) {
        final q = searchQuery.value.toLowerCase();
        final matchTitle = p.title.toLowerCase().contains(q);
        final matchBrand = p.brand.toLowerCase().contains(q);
        final matchCategory = p.category.toLowerCase().contains(q);
        final matchDesc = p.description.toLowerCase().contains(q);
        if (!matchTitle && !matchBrand && !matchCategory && !matchDesc) return false;
      }
      // Price filter
      if (p.price < priceRange.value.start || p.price > priceRange.value.end) {
        return false;
      }
      // Size filter
      if (selectedFilterSizes.isNotEmpty) {
        final hasSize = selectedFilterSizes.any((s) => p.sizes.contains(s));
        if (!hasSize) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (sortBy.value == 'Price: Low to High') {
          return a.price.compareTo(b.price);
        } else if (sortBy.value == 'Price: High to Low') {
          return b.price.compareTo(a.price);
        } else if (sortBy.value == 'Rating') {
          return b.rating.compareTo(a.rating);
        }
        return 0; // Default Featured
      });
  }

  // Wishlist Actions
  bool isWishlisted(String productId) => wishlistProductIds.contains(productId);

  void toggleWishlist(String productId) {
    HapticService.selection();
    if (wishlistProductIds.contains(productId)) {
      wishlistProductIds.remove(productId);
    } else {
      wishlistProductIds.add(productId);
    }
  }

  List<Product> get wishlistProducts =>
      allProducts.where((p) => wishlistProductIds.contains(p.id)).toList();

  // Cart Actions
  int get totalCartItemsCount =>
      cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * discountPercent.value;

  double get shippingFee => subtotal > 50 || subtotal == 0 ? 0.0 : 9.99;

  double get taxAmount => (subtotal - discountAmount) * 0.08;

  double get grandTotal => (subtotal - discountAmount) + shippingFee + taxAmount;

  void addToCart({
    required Product product,
    required String size,
    required ProductColorVariant color,
    String? monogramSummary,
    int quantity = 1,
  }) {
    bagBounceTrigger.value++;
    HapticService.success();
    final existingIndex = cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor.name == color.name &&
          item.monogramSummary == monogramSummary,
    );

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          selectedSize: size,
          selectedColor: color,
          monogramSummary: monogramSummary,
          quantity: quantity,
        ),
      );
    }
  }

  void updateQuantity(String cartItemId, int delta) {
    HapticService.selection();
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      final newQty = cartItems[index].quantity + delta;
      if (newQty <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = newQty;
        cartItems.refresh();
      }
    }
  }

  void removeFromCart(String cartItemId) {
    HapticService.medium();
    cartItems.removeWhere((item) => item.id == cartItemId);
  }

  bool applyPromoCode(String code) {
    HapticService.selection();
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'SILOU20' || cleanCode == 'SAVE20') {
      promoCode.value = 'SILOU20';
      discountPercent.value = 0.20;
      return true;
    } else if (cleanCode == 'ATELIER15' || cleanCode == 'WELCOME15') {
      promoCode.value = cleanCode;
      discountPercent.value = 0.15;
      return true;
    }
    return false;
  }

  // Currency System
  final Rx<String> selectedCurrencyCode = 'USD'.obs;

  double get currencyRate {
    switch (selectedCurrencyCode.value) {
      case 'EUR':
        return 0.92;
      case 'GBP':
        return 0.79;
      case 'JPY':
        return 152.0;
      case 'USD':
      default:
        return 1.0;
    }
  }

  String get currencySymbol {
    switch (selectedCurrencyCode.value) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'USD':
      default:
        return '\$';
    }
  }

  void switchCurrency(String code) {
    HapticService.selection();
    selectedCurrencyCode.value = code;
  }

  String formatPrice(double amountInUsd) {
    final converted = amountInUsd * currencyRate;
    final symbol = currencySymbol;
    if (selectedCurrencyCode.value == 'JPY') {
      return '$symbol${converted.round()}';
    }
    return '$symbol${converted.toStringAsFixed(0)}';
  }

  void addMultipleToCart(List<CartItem> newItems) {
    bagBounceTrigger.value++;
    HapticService.success();
    for (final item in newItems) {
      final existingIndex = cartItems.indexWhere(
        (ci) =>
            ci.product.id == item.product.id &&
            ci.selectedSize == item.selectedSize &&
            ci.selectedColor.name == item.selectedColor.name,
      );
      if (existingIndex >= 0) {
        cartItems[existingIndex].quantity += item.quantity;
      } else {
        cartItems.add(item);
      }
    }
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
    promoCode.value = '';
    discountPercent.value = 0.0;
  }

  // Acoustic Studio Soundscape State
  final Rx<SoundscapeTrack?> activeSoundscapeTrack = Rx<SoundscapeTrack?>(null);
  final RxBool isSoundscapePlaying = false.obs;
  final RxDouble soundscapeReverbDepth = 0.65.obs;

  void playSoundscapeTrack(SoundscapeTrack track) {
    HapticService.selection();
    activeSoundscapeTrack.value = track;
    isSoundscapePlaying.value = true;
  }

  void toggleSoundscapePlay() {
    HapticService.light();
    if (activeSoundscapeTrack.value == null) {
      activeSoundscapeTrack.value = SoundscapeTrack.defaultTracks.first;
      isSoundscapePlaying.value = true;
    } else {
      isSoundscapePlaying.value = !isSoundscapePlaying.value;
    }
  }

  void stopSoundscape() {
    HapticService.selection();
    activeSoundscapeTrack.value = null;
    isSoundscapePlaying.value = false;
  }
}

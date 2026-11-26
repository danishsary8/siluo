import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/mock/mock_atelier_data.dart';
import '../../data/models/capsule_collection.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/atelier_product_card.dart';
import '../../shared/widgets/editorial_shimmer_box.dart';
import 'atelier_runway_story_view.dart';
import '../lookbook/style_the_look_view.dart';
import '../visual_search/atelier_visual_search_view.dart';
import '../product_detail/atelier_pdp_view.dart';

class AtelierHomeView extends StatefulWidget {
  const AtelierHomeView({super.key});

  @override
  State<AtelierHomeView> createState() => _AtelierHomeViewState();
}

class _AtelierHomeViewState extends State<AtelierHomeView> {
  final PageController _heroPageController = PageController(viewportFraction: 0.92);
  final TextEditingController _searchController = TextEditingController();
  int _activeHeroIndex = 0;

  // Flash Sale Countdown Timer (Simulated dynamic ticking clock)
  late Timer _countdownTimer;
  Duration _flashRemaining = const Duration(hours: 4, minutes: 38, seconds: 45);

  final List<String> _departments = [
    'Women',
    'Men',
    'Kids',
    'Brands',
    'Sale',
    'All',
  ];

  final List<String> _categories = [
    'All',
    'Outerwear',
    'Tops',
    'Dresses',
    'Denim',
    'Footwear',
    'Activewear',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_flashRemaining.inSeconds > 0) {
            _flashRemaining = _flashRemaining - const Duration(seconds: 1);
          } else {
            _flashRemaining = const Duration(hours: 12, minutes: 0, seconds: 0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    _searchController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  String _formatFlashTimer(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _openRunwayStory(String storyLabel, String imageUrl) {
    HapticService.selection();
    final products = AtelierController.to.allProducts;
    final tagged1 = products.isNotEmpty ? products[0] : mockAtelierProducts.first;
    final tagged2 = products.length > 1 ? products[1] : mockAtelierProducts.first;
    final tagged3 = products.length > 2 ? products[2] : mockAtelierProducts.first;

    Get.to(
      () => AtelierRunwayStoryView(
        storyTitle: storyLabel,
        slides: [
          RunwayStorySlide(
            imageUrl: imageUrl,
            caption: '$storyLabel • Trending Now',
            subCaption: 'Curated street style & premium high-street fashion.',
            taggedProduct: tagged1,
            tagPosition: const Offset(0.5, 0.44),
          ),
          RunwayStorySlide(
            imageUrl: tagged2.primaryImage,
            caption: '$storyLabel • Outfit Inspo',
            subCaption: 'Effortless seasonal layering with top brands.',
            taggedProduct: tagged2,
            tagPosition: const Offset(0.48, 0.50),
          ),
          RunwayStorySlide(
            imageUrl: tagged3.primaryImage,
            caption: '$storyLabel • Complete Look',
            subCaption: 'Style with authentic sneakers and statement bags.',
            taggedProduct: tagged3,
            tagPosition: const Offset(0.52, 0.42),
          ),
        ],
      ),
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. SILOU Brand Header with live badges
          SliverAppBar(
            floating: true,
            pinned: false,
            backgroundColor: isDark
                ? AppColors.canvasDark.withValues(alpha: 0.95)
                : AppColors.canvasLight.withValues(alpha: 0.95),
            elevation: 0,
            titleSpacing: 20,
            title: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SILOU',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: isDark ? Colors.white : AppColors.silouSecondary,
                        ),
                      ),
                      const TextSpan(
                        text: '.',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.silouPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.silouPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SHOPPING',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: AppColors.silouPrimary,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // Dark / Light Mode Toggle
              IconButton(
                icon: Icon(
                  isDark ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                  size: 20,
                  color: isDark ? AppColors.silouFlash : AppColors.ctaDark,
                ),
                onPressed: controller.toggleDarkMode,
              ),

              // Wishlist Icon with Live Counter
              Obx(() {
                final count = controller.wishlistProductIds.length;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.heart,
                        size: 22,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      onPressed: () => controller.switchTab(1), // Nav to wishlist or tab
                    ),
                    if (count > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.silouPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),

              // Cart Icon with Bounce Badge
              Obx(() {
                final cartCount = controller.totalCartItemsCount;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.bag,
                        size: 22,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      onPressed: () => controller.switchTab(3), // Switch to Cart tab
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.silouPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(width: 8),
            ],
          ),

          // 2. Department Selector Bar (Women | Men | Kids | Brands | Sale)
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _departments.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dept = _departments[index];
                  return Obx(() {
                    final isSelected = controller.selectedDepartment.value == dept;
                    final isSale = dept == 'Sale';

                    return GestureDetector(
                      onTap: () => controller.selectDepartment(dept),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isSale ? AppColors.saleRed : AppColors.silouPrimary)
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: (isSale ? AppColors.saleRed : AppColors.silouPrimary)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSale) ...[
                                Icon(
                                  Icons.local_fire_department,
                                  size: 14,
                                  color: isSelected ? Colors.white : AppColors.saleRed,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                dept.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: isSelected
                                      ? Colors.white
                                      : (isSale
                                          ? AppColors.saleRed
                                          : (isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textSecondary)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),

          // 3. Search Bar with Visual Search & Voice Icons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      size: 18,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => controller.searchQuery.value = val,
                        decoration: InputDecoration(
                          hintText: 'Search 50,000+ items, Nike, Zara, Denim...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          controller.searchQuery.value = '';
                        },
                        child: Icon(
                          CupertinoIcons.clear_circled_solid,
                          size: 16,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                    const SizedBox(width: 8),
                    // Camera Visual Search
                    GestureDetector(
                      onTap: () {
                        HapticService.selection();
                        Get.to(
                          () => const AtelierVisualSearchView(),
                          transition: Transition.fadeIn,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.silouPrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.camera_fill,
                          size: 16,
                          color: AppColors.silouPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Quick Feed Stories / Categories Row
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 98,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: mockStories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final story = mockStories[index];
                      return GestureDetector(
                        onTap: () => _openRunwayStory(story.label, story.imageUrl),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.silouPrimary,
                                    AppColors.silouFlash,
                                    Color(0xFFEC4899),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? AppColors.canvasDark : AppColors.canvasLight,
                                ),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(story.imageUrl),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              story.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 5. Hero Campaign Promotional Carousel
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 190,
                  child: PageView.builder(
                    controller: _heroPageController,
                    itemCount: mockCapsules.length,
                    onPageChanged: (idx) {
                      HapticService.selection();
                      setState(() => _activeHeroIndex = idx);
                    },
                    itemBuilder: (context, index) {
                      final capsule = mockCapsules[index];
                      return _buildCapsuleCard(capsule, isDark);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Smooth Dot Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    mockCapsules.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _activeHeroIndex == i ? 22 : 6,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _activeHeroIndex == i
                            ? AppColors.silouPrimary
                            : (isDark ? Colors.white24 : Colors.black12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 6. ⚡ LIVE FLASH SALE SECTION with Countdown Clock
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF271515), const Color(0xFF1E1414)]
                      : [const Color(0xFFFFF1F0), const Color(0xFFFFF7ED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.silouPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.silouPrimary, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        'FLASH DEALS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: isDark ? Colors.white : AppColors.silouSecondary,
                        ),
                      ),
                      const Spacer(),
                      // Live Countdown Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.silouPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.clock_fill, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              _formatFlashTimer(_flashRemaining),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Flash items horizontal list
                  SizedBox(
                    height: 165,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.flashDeals.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, idx) {
                        final product = controller.flashDeals[idx];
                        return _buildFlashDealMiniCard(product, isDark, controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 7. Top Brands Filter Row
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OFFICIAL BRANDS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Obx(() {
                        if (controller.selectedBrand.value != 'All') {
                          return GestureDetector(
                            onTap: () => controller.selectBrand('All'),
                            child: const Text(
                              'Clear filter',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.silouPrimary,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.availableBrands.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final brand = controller.availableBrands[index];
                      return Obx(() {
                        final isSelected = controller.selectedBrand.value == brand;
                        return GestureDetector(
                          onTap: () => controller.selectBrand(brand),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? Colors.white : AppColors.ctaDark)
                                  : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                brand.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: isSelected
                                      ? (isDark ? AppColors.canvasDark : Colors.white)
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),

          // 8. Categories Filter Pills
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return Obx(() {
                    final isSelected = controller.selectedCategory.value == cat;
                    return GestureDetector(
                      onTap: () => controller.selectCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.silouPrimary
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),

          // 9. Section Title: Catalog Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        controller.selectedDepartment.value == 'All'
                            ? 'ALL TRENDING STYLES'
                            : '${controller.selectedDepartment.value.toUpperCase()} COLLECTION',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      )),
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${controller.filteredProducts.length} ITEMS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

          // 10. Curated 2-Column Product Grid
          Obx(() {
            final products = controller.filteredProducts;

            if (products.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.bag_badge_minus,
                          size: 48,
                          color: isDark ? Colors.white30 : Colors.black26,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No items found matching your filters',
                          style: AppTypography.body(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            controller.selectCategory('All');
                            controller.selectBrand('All');
                            controller.selectDepartment('All');
                            controller.searchQuery.value = '';
                          },
                          child: const Text(
                            'Reset All Filters',
                            style: TextStyle(
                              color: AppColors.silouPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Distribute into 2 columns
            final leftColumn = <Widget>[];
            final rightColumn = <Widget>[];

            for (int i = 0; i < products.length; i++) {
              final isLeft = i % 2 == 0;
              final card = Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AtelierProductCard(
                  product: products[i],
                  isStaggered: isLeft,
                ),
              );
              if (isLeft) {
                leftColumn.add(card);
              } else {
                rightColumn.add(card);
              }
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: leftColumn,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: rightColumn,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Bottom padding for bottom navigation
          const SliverToBoxAdapter(
            child: SizedBox(height: 110),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashDealMiniCard(Product product, bool isDark, AtelierController controller) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        Get.to(
          () => AtelierPdpView(product: product),
          transition: Transition.fadeIn,
        );
      },
      child: Container(
        width: 115,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  product.primaryImage,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    color: isDark ? Colors.white10 : Colors.black12,
                    child: const Icon(Icons.image_not_supported, size: 20),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.silouPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${product.computedDiscountPercent}%',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.silouPrimary,
                    ),
                  ),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        controller.formatPrice(product.price),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.silouPrimary,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          controller.formatPrice(product.originalPrice!),
                          style: TextStyle(
                            fontSize: 9,
                            decoration: TextDecoration.lineThrough,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
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

  Widget _buildCapsuleCard(CapsuleCollection capsule, bool isDark) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        Get.to(
          () => const StyleTheLookView(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(milliseconds: 350),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              capsule.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: isDark ? const Color(0xFF202024) : const Color(0xFFE8E5DF),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const EditorialShimmerBox(
                  borderRadius: BorderRadius.zero,
                );
              },
            ),
            // Gradient scrim
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.silouPrimary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      capsule.tag,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    capsule.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    capsule.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      capsule.ctaText,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.silouSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

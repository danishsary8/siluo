import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../../shared/widgets/persistent_soundscape_bar.dart';

// Screens
import '../home/atelier_home_view.dart';
import '../search/atelier_search_view.dart';
import '../cart/atelier_cart_view.dart';
import '../wishlist/atelier_wishlist_view.dart';
import '../profile/atelier_profile_view.dart';

class AtelierShellView extends StatefulWidget {
  const AtelierShellView({super.key});

  @override
  State<AtelierShellView> createState() => _AtelierShellViewState();
}

class _AtelierShellViewState extends State<AtelierShellView>
    with SingleTickerProviderStateMixin {
  late AnimationController _bagBounceController;
  late Animation<double> _bagScaleAnimation;
  Worker? _bounceWorker;

  @override
  void initState() {
    super.initState();
    _bagBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _bagScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 55),
    ]).animate(CurvedAnimation(
      parent: _bagBounceController,
      curve: Curves.easeOutBack,
    ));

    final controller = Get.find<AtelierController>();
    _bounceWorker = ever(controller.bagBounceTrigger, (_) {
      _bagBounceController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _bounceWorker?.dispose();
    _bagBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const pages = <Widget>[
      AtelierHomeView(),
      AtelierSearchView(),
      AtelierCartView(),
      AtelierWishlistView(),
      AtelierProfileView(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: Obx(() => IndexedStack(
            index: controller.currentTabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PersistentSoundscapeBar(),
          _buildGlassNavigationBar(context, controller, isDark),
        ],
      ),
    );
  }

  Widget _buildGlassNavigationBar(
    BuildContext context,
    AtelierController controller,
    bool isDark,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: LiquidGlassContainer(
          borderRadius: 36,
          blur: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: isDark
              ? Colors.black.withValues(alpha: 0.65)
              : Colors.white.withValues(alpha: 0.78),
          borderColor: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.85),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
          child: Obx(() {
            final activeIndex = controller.currentTabIndex.value;
            final cartCount = controller.totalCartItemsCount;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  activeIcon: CupertinoIcons.house_fill,
                  inactiveIcon: CupertinoIcons.house,
                  label: 'Home',
                  isActive: activeIndex == 0,
                  controller: controller,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 1,
                  activeIcon: CupertinoIcons.search,
                  inactiveIcon: CupertinoIcons.search,
                  label: 'Explore',
                  isActive: activeIndex == 1,
                  controller: controller,
                  isDark: isDark,
                ),
                ScaleTransition(
                  scale: _bagScaleAnimation,
                  child: _buildNavItem(
                    index: 2,
                    activeIcon: CupertinoIcons.bag_fill,
                    inactiveIcon: CupertinoIcons.bag,
                    label: 'Bag',
                    badgeCount: cartCount,
                    isActive: activeIndex == 2,
                    controller: controller,
                    isDark: isDark,
                  ),
                ),
                _buildNavItem(
                  index: 3,
                  activeIcon: CupertinoIcons.heart_fill,
                  inactiveIcon: CupertinoIcons.heart,
                  label: 'Wishlist',
                  badgeCount: controller.wishlistProductIds.length,
                  isActive: activeIndex == 3,
                  controller: controller,
                  isDark: isDark,
                ),
                _buildNavItem(
                  index: 4,
                  activeIcon: CupertinoIcons.person_fill,
                  inactiveIcon: CupertinoIcons.person,
                  label: 'Account',
                  isActive: activeIndex == 4,
                  controller: controller,
                  isDark: isDark,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required bool isActive,
    required AtelierController controller,
    required bool isDark,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.switchTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.silouPrimary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? activeIcon : inactiveIcon,
                  size: 20,
                  color: isActive
                      ? Colors.white
                      : (isDark ? AppColors.textMutedDark : AppColors.textMuted),
                ),
                if (isActive) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
            if (badgeCount > 0 && !isActive)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.silouPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
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

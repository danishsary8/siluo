import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../product_detail/atelier_pdp_view.dart';

class AtelierRunwayLiveView extends StatefulWidget {
  const AtelierRunwayLiveView({super.key});

  @override
  State<AtelierRunwayLiveView> createState() => _AtelierRunwayLiveViewState();
}

class _AtelierRunwayLiveViewState extends State<AtelierRunwayLiveView>
    with SingleTickerProviderStateMixin {
  int _activeCameraIndex = 0; // 0: Catwalk, 1: Textiles, 2: Backstage
  int _activeLookIndex = 0;
  int _heartReactionCount = 0;
  Timer? _chatTimer;
  Timer? _lookTimer;
  int _chatCommentIndex = 0;

  late final AnimationController _livePulseController;

  final List<String> _cameraAngles = const [
    'Front Row Catwalk',
    'Macro Fabric',
    'Backstage Lineup',
  ];

  final List<String> _cameraFeeds = const [
    'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=1200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=1200&auto=format&fit=crop&q=80',
  ];

  final List<Map<String, String>> _vipChatStream = const [
    {'author': 'Élodie Laurent', 'role': 'Vogue Paris', 'message': 'The drop-shoulder volume is exceptional. 🖤'},
    {'author': 'Julian Richter', 'role': 'Milan Style Review', 'message': 'Look 04 silhouette completely redefines minimalist tailoring.'},
    {'author': 'Haruka Tanaka', 'role': 'Ginza Couture Club', 'message': 'The drape of that sand-washed silk in motion... breathtaking.'},
    {'author': 'Marcello Rossi', 'role': 'Florence Textile Guild', 'message': 'Pure Lanificio di Tollegno double-faced wool. World-class.'},
  ];

  @override
  void initState() {
    super.initState();
    _livePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Rotate VIP comments every 3.5 seconds
    _chatTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (mounted) {
        setState(() {
          _chatCommentIndex = (_chatCommentIndex + 1) % _vipChatStream.length;
        });
      }
    });

    // Rotate active look every 7 seconds
    _lookTimer = Timer.periodic(const Duration(milliseconds: 7000), (timer) {
      if (mounted) {
        final products = AtelierController.to.allProducts;
        setState(() {
          _activeLookIndex = (_activeLookIndex + 1) % products.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _livePulseController.dispose();
    _chatTimer?.cancel();
    _lookTimer?.cancel();
    super.dispose();
  }

  void _onReactHeart() {
    HapticService.light();
    setState(() => _heartReactionCount++);
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final products = controller.allProducts;
    final currentProduct = products[_activeLookIndex % products.length];
    final activeComment = _vipChatStream[_chatCommentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Live Video Feed Simulation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.network(
              _cameraFeeds[_activeCameraIndex],
              key: ValueKey(_activeCameraIndex),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Cinematic Contrast Scrim
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.88),
                ],
                stops: const [0.0, 0.35, 0.85],
              ),
            ),
          ),

          // Top App Bar & Live Status
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        LiquidGlassContainer(
                          padding: const EdgeInsets.all(10),
                          borderRadius: 24,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(CupertinoIcons.back, color: Colors.white, size: 20),
                          ),
                        ),

                        // Live Badge with Pulsing Red Dot
                        LiquidGlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          borderRadius: 20,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _livePulseController,
                                builder: (context, child) {
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.saleRed.withValues(
                                        alpha: 0.4 + (_livePulseController.value * 0.6),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.saleRed,
                                          blurRadius: 6 * _livePulseController.value,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'LIVE • GRAND PALAIS PARIS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Viewer Count Pill
                        const LiquidGlassContainer(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          borderRadius: 20,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.eye_fill, size: 14, color: AppColors.champagneGold),
                              SizedBox(width: 6),
                              Text(
                                '18.4K',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Multi-Camera Perspective Switcher
                    SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _cameraAngles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final isSelected = _activeCameraIndex == index;
                          return GestureDetector(
                            onTap: () {
                              HapticService.selection();
                              setState(() => _activeCameraIndex = index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.champagneGold
                                    : Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : Colors.white24,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _cameraAngles[index],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // VIP Live Chat Ticker Floating Bubble
          Positioned(
            left: 20,
            right: 80,
            bottom: 180,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: LiquidGlassContainer(
                key: ValueKey(_chatCommentIndex),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                borderRadius: 18,
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.champagneGold,
                      ),
                      child: Center(
                        child: Text(
                          activeComment['author']![0],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                activeComment['author']!,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                activeComment['role']!,
                                style: const TextStyle(fontSize: 9, color: AppColors.champagneGold, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activeComment['message']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Hearts Reactions Column
          Positioned(
            right: 20,
            bottom: 180,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onReactHeart,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.6),
                      border: Border.all(color: AppColors.champagneGold, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.champagneGold.withValues(alpha: 0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.heart_fill, color: AppColors.champagneGold, size: 24),
                    ),
                  ),
                ),
                if (_heartReactionCount > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+$_heartReactionCount',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.champagneGold),
                  ),
                ],
              ],
            ),
          ),

          // Currently on Catwalk Bottom Piece Card
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: LiquidGlassContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: 24,
              borderColor: AppColors.champagneGold.withValues(alpha: 0.5),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      currentProduct.primaryImage,
                      width: 64,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.champagneGold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'CURRENTLY ON CATWALK',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: AppColors.champagneGold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          currentProduct.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                              controller.formatPrice(currentProduct.price),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Quick Shop Button
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.champagneGold,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onPressed: () {
                        HapticService.light();
                        Get.to(() => AtelierPdpView(product: currentProduct));
                      },
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.bag_fill, size: 13),
                          SizedBox(width: 4),
                          Text('SHOP', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

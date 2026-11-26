import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../product_detail/atelier_pdp_view.dart';
import '../../shared/widgets/image_fallback.dart';

class RunwayStorySlide {
  final String imageUrl;
  final String caption;
  final String subCaption;
  final Product taggedProduct;
  final Offset tagPosition; // Percentage offset on image (e.g. 0.5, 0.4)

  const RunwayStorySlide({
    required this.imageUrl,
    required this.caption,
    required this.subCaption,
    required this.taggedProduct,
    required this.tagPosition,
  });
}

class AtelierRunwayStoryView extends StatefulWidget {
  final String storyTitle;
  final List<RunwayStorySlide> slides;

  const AtelierRunwayStoryView({
    super.key,
    required this.storyTitle,
    required this.slides,
  });

  @override
  State<AtelierRunwayStoryView> createState() => _AtelierRunwayStoryViewState();
}

class _AtelierRunwayStoryViewState extends State<AtelierRunwayStoryView>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _progressController;
  bool _showTagCard = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextSlide();
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    if (_currentIndex < widget.slides.length - 1) {
      setState(() {
        _currentIndex++;
        _showTagCard = false;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousSlide() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showTagCard = false;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      _progressController.reset();
      _progressController.forward();
    }
  }

  void _pause() {
    _progressController.stop();
  }

  void _resume() {
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = widget.slides[_currentIndex];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) => setState(_pause),
        onLongPressEnd: (_) => setState(_resume),
        onTapUp: (details) {
          final dx = details.globalPosition.dx;
          if (dx < size.width * 0.35) {
            _previousSlide();
          } else {
            _nextSlide();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Cinematic Background Image
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Image.network(
                currentSlide.imageUrl,
                key: ValueKey(currentSlide.imageUrl),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF18181A)),
              ),
            ),

            // Subtle vignette gradients
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),

            // 2. Top Segmented Progress Bar & Story Title
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(widget.slides.length, (index) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                double value = 0.0;
                                if (index < _currentIndex) {
                                  value = 1.0;
                                } else if (index == _currentIndex) {
                                  value = _progressController.value;
                                }
                                return FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    // Header Bar
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.champagneGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.storyTitle.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                            child: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. Interactive Floating Garment Pin
            Positioned(
              left: size.width * currentSlide.tagPosition.dx - 20,
              top: size.height * currentSlide.tagPosition.dy - 20,
              child: GestureDetector(
                onTap: () {
                  HapticService.selection();
                  setState(() => _showTagCard = !_showTagCard);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Interactive Bottom Tag Drawer Card
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  if (_showTagCard) ...[
                    _buildInteractiveProductTray(currentSlide.taggedProduct),
                    const SizedBox(height: 12),
                  ],
                  // Caption & Swipe up Indicator
                  GestureDetector(
                    onTap: () {
                      HapticService.selection();
                      setState(() => _showTagCard = !_showTagCard);
                    },
                    child: LiquidGlassContainer(
                      blur: 20,
                      borderRadius: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      color: Colors.black.withValues(alpha: 0.55),
                      borderColor: Colors.white.withValues(alpha: 0.2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentSlide.caption,
                                  style: AppTypography.productTitle(color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentSlide.subCaption,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.champagneGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.tag_fill, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  _showTagCard ? 'HIDE' : 'VIEW PIECE',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildInteractiveProductTray(Product product) {
    final controller = AtelierController.to;

    return LiquidGlassContainer(
      blur: 24,
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      color: Colors.black.withValues(alpha: 0.8),
      borderColor: Colors.white.withValues(alpha: 0.25),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              product.primaryImage,
              width: 56,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ImageFallback(width: 56, height: 72),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      controller.formatPrice(product.price),
                      style: const TextStyle(
                        color: AppColors.champagneGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    )),
                const SizedBox(height: 6),
                Text(
                  '100% Italian Craft • In Stock',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Get.to(() => AtelierPdpView(product: product));
            },
            child: const Text(
              'INSPECT',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

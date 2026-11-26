import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../product_detail/atelier_pdp_view.dart';
import '../journal/atelier_journal_view.dart';

class MagazineSpread {
  final String issueNumber;
  final String title;
  final String subtitle;
  final String pullQuote;
  final String author;
  final String imageUrl;
  final String? pinnedProductId;
  final Offset? pinAlignment; // Relative position of garment tag (0.0 to 1.0)

  const MagazineSpread({
    required this.issueNumber,
    required this.title,
    required this.subtitle,
    required this.pullQuote,
    required this.author,
    required this.imageUrl,
    this.pinnedProductId,
    this.pinAlignment,
  });
}

class AtelierMagazineView extends StatefulWidget {
  const AtelierMagazineView({super.key});

  @override
  State<AtelierMagazineView> createState() => _AtelierMagazineViewState();
}

class _AtelierMagazineViewState extends State<AtelierMagazineView>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isPlayingSoundscape = true;
  Product? _activePinnedProduct;

  late final AnimationController _equalizerController;
  late final AnimationController _pulseController;

  final List<MagazineSpread> _spreads = const [
    MagazineSpread(
      issueNumber: 'ISSUE N° 04',
      title: 'THE ARCHITECTURE\nOF DRAPE',
      subtitle: 'AUTUMN / WINTER 2026 COUTURE EDITORIAL',
      pullQuote:
          '“Clothing should not merely enclose the body; it must dialogue with space, air, and movement.”',
      author: 'Éléonore Vance, Creative Director',
      imageUrl:
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=1200&auto=format&fit=crop&q=80',
      pinnedProductId: 'zd_w_01',
      pinAlignment: Offset(0.52, 0.44),
    ),
    MagazineSpread(
      issueNumber: 'ESSAY — SCULPTURAL WOOL',
      title: 'MONOCHROME\nGEOMETRIES',
      subtitle: 'VOLUMETRIC TAILORING & RAW TEXTURES',
      pullQuote:
          '“Weight without stiffness: the double-faced melton wool sculpts clean drop-shoulder silhouettes that defy northern winds.”',
      author: 'Paris Atelier Notes',
      imageUrl:
          'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=1200&auto=format&fit=crop&q=80',
      pinnedProductId: 'zd_w_02',
      pinAlignment: Offset(0.48, 0.40),
    ),
    MagazineSpread(
      issueNumber: 'ESSAY — SILK TWILL',
      title: 'THE WHISPER\nOF CHARMEUSE',
      subtitle: 'SAND-WASHED SILK CUT ON THE TRUE BIAS',
      pullQuote:
          '“Cutting on the bias allows woven silk to behave like liquid mercury, tracing every natural gesture of the silhouette.”',
      author: 'Milan Textile Chronicle',
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1200&auto=format&fit=crop&q=80',
      pinnedProductId: 'zd_w_03',
      pinAlignment: Offset(0.50, 0.48),
    ),
    MagazineSpread(
      issueNumber: 'RUNWAY FINALE',
      title: 'MIDNIGHT\nMINIMALISM',
      subtitle: 'BESPOKE EVENINGWEAR CAPSULE',
      pullQuote:
          '“True luxury whispers. It resides in the millimeter precision of a hand-rolled lapel and the obsidian sheen of pure worsted wool.”',
      author: 'Place Vendôme Archives',
      imageUrl:
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1200&auto=format&fit=crop&q=80',
      pinnedProductId: 'zd_w_05',
      pinAlignment: Offset(0.55, 0.38),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _equalizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _equalizerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTagTapped(String productId) {
    HapticService.selection();
    final product = AtelierController.to.allProducts.firstWhereOrNull((p) => p.id == productId);
    setState(() {
      _activePinnedProduct = (_activePinnedProduct?.id == productId) ? null : product;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Horizontal Full-Bleed Magazine Spreads
          PageView.builder(
            controller: _pageController,
            itemCount: _spreads.length,
            onPageChanged: (i) {
              HapticService.selection();
              setState(() {
                _currentPage = i;
                _activePinnedProduct = null;
              });
            },
            itemBuilder: (context, index) {
              final spread = _spreads[index];
              return _buildSpreadPage(spread, controller);
            },
          ),

          // Top Editorial Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    LiquidGlassContainer(
                      padding: const EdgeInsets.all(10),
                      borderRadius: 24,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(CupertinoIcons.back, color: Colors.white, size: 20),
                      ),
                    ),

                    // Ambient Runway Soundscape Pill
                    GestureDetector(
                      onTap: () {
                        HapticService.light();
                        setState(() => _isPlayingSoundscape = !_isPlayingSoundscape);
                      },
                      child: LiquidGlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        borderRadius: 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSoundEqualizer(),
                            const SizedBox(width: 8),
                            Text(
                              _isPlayingSoundscape ? 'RUNWAY SOUNDSCAPE' : 'SOUND MUTED',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Shopping Bag shortcut
                    LiquidGlassContainer(
                      padding: const EdgeInsets.all(10),
                      borderRadius: 24,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.switchTab(2); // Bag
                        },
                        child: const Icon(CupertinoIcons.bag, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Pinned Product Bottom Drawer (if open)
          if (_activePinnedProduct != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 90,
              child: _buildPinnedGarmentDrawer(_activePinnedProduct!, controller),
            ),

          // Bottom Magazine Spread Pagination Bar
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Spread Number Indicator
                Text(
                  'SPREAD ${_currentPage + 1} OF ${_spreads.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: AppColors.champagneGold,
                  ),
                ),

                // Smooth Segmented Indicator
                Row(
                  children: List.generate(
                    _spreads.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentPage == i ? 24 : 6,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? AppColors.champagneGold : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadPage(MagazineSpread spread, AtelierController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Full-Bleed Editorial Photo
        Image.network(
          spread.imageUrl,
          fit: BoxFit.cover,
        ),

        // Editorial Scrim & Vignette
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.5),
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.85),
              ],
              stops: const [0.0, 0.45, 0.95],
            ),
          ),
        ),

        // Interactive Garment Tag Pin
        if (spread.pinnedProductId != null && spread.pinAlignment != null)
          Positioned(
            left: MediaQuery.of(context).size.width * spread.pinAlignment!.dx,
            top: MediaQuery.of(context).size.height * spread.pinAlignment!.dy,
            child: GestureDetector(
              onTap: () => _onTagTapped(spread.pinnedProductId!),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing outer ripple
                      Container(
                        width: 38 + (_pulseController.value * 14),
                        height: 38 + (_pulseController.value * 14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.champagneGold.withValues(
                            alpha: 0.3 * (1.0 - _pulseController.value),
                          ),
                        ),
                      ),
                      // Core pin button
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.8),
                          border: Border.all(color: AppColors.champagneGold, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.bag_fill,
                          color: AppColors.champagneGold,
                          size: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

        // Typography & Editorial Content
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 110, 28, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Title & Issue Block
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spread.issueNumber,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                      color: AppColors.champagneGold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spread.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    spread.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              // Bottom Pull Quote Block
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spread.pullQuote,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 19,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '— ${spread.author}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.champagneGold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      HapticService.light();
                      Get.to(
                        () => const AtelierJournalView(),
                        transition: Transition.fadeIn,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.champagneGold.withValues(alpha: 0.7),
                          width: 1.0,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.book_fill, size: 14, color: AppColors.champagneGold),
                          SizedBox(width: 8),
                          Text(
                            'READ EDITORIAL ESSAY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(CupertinoIcons.arrow_right, size: 12, color: AppColors.champagneGold),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(CupertinoIcons.hand_point_left, size: 14, color: Colors.white54),
                      SizedBox(width: 6),
                      Text(
                        'Tap the glowing insignia on the model to shop the look',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white60,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedGarmentDrawer(Product product, AtelierController controller) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 24,
      borderColor: AppColors.champagneGold.withValues(alpha: 0.5),
      child: Row(
        children: [
          // Garment thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.primaryImage,
              width: 68,
              height: 84,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),

          // Details & Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FEATURED IN THIS SPREAD',
                  style: AppTypography.microTag(color: AppColors.champagneGold),
                ),
                const SizedBox(height: 2),
                Text(
                  product.title,
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
                      controller.formatPrice(product.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Action button
          SizedBox(
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.champagneGold,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: () {
                HapticService.light();
                Get.to(() => AtelierPdpView(product: product));
              },
              child: const Row(
                children: [
                  Text('VIEW', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                  SizedBox(width: 4),
                  Icon(CupertinoIcons.arrow_right, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundEqualizer() {
    return AnimatedBuilder(
      animation: _equalizerController,
      builder: (context, child) {
        final val = _isPlayingSoundscape ? _equalizerController.value : 0.0;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(6 + (val * 8)),
            const SizedBox(width: 2),
            _buildBar(14 - (val * 8)),
            const SizedBox(width: 2),
            _buildBar(8 + (val * 6)),
            const SizedBox(width: 2),
            _buildBar(12 - (val * 6)),
          ],
        );
      },
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 2.5,
      height: height.clamp(3.0, 14.0),
      decoration: BoxDecoration(
        color: AppColors.champagneGold,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

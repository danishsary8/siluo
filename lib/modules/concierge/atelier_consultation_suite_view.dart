import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../data/models/product_model.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../salon/atelier_salon_booking_view.dart';

class AtelierConsultationSuiteView extends StatefulWidget {
  const AtelierConsultationSuiteView({super.key});

  @override
  State<AtelierConsultationSuiteView> createState() =>
      _AtelierConsultationSuiteViewState();
}

class _AtelierConsultationSuiteViewState extends State<AtelierConsultationSuiteView>
    with SingleTickerProviderStateMixin {
  bool _isMicMuted = false;
  bool _isVideoOff = false;
  bool _isFrontCamera = true;
  int _activeShowcaseIndex = 0;

  late final AnimationController _waveAnimController;
  late final List<Product> _showcaseProducts;

  @override
  void initState() {
    super.initState();
    final all = AtelierController.to.allProducts;
    _showcaseProducts = all.take(4).toList();

    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveAnimController.dispose();
    super.dispose();
  }

  void _toggleMic() {
    HapticService.selection();
    setState(() => _isMicMuted = !_isMicMuted);
  }

  void _toggleVideo() {
    HapticService.selection();
    setState(() => _isVideoOff = !_isVideoOff);
  }

  void _switchCamera() {
    HapticService.light();
    setState(() => _isFrontCamera = !_isFrontCamera);
  }

  void _endCall() {
    HapticService.heavy();
    Navigator.of(context).pop();
    Get.snackbar(
      'Consultation Concluded',
      'Curated recommendations & fit notes from Éléonore Vance sent to your Atelier dossier.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: AppColors.champagneGold,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  void _reservePiece(Product product) {
    HapticService.success();
    AtelierController.to.addToCart(
      product: product,
      size: product.sizes.isNotEmpty ? product.sizes.first : '38 FR',
      color: product.colorVariants.isNotEmpty
          ? product.colorVariants.first
          : const ProductColorVariant(name: 'Default', color: Colors.black, images: []),
    );
    Get.snackbar(
      'Exclusive Piece Reserved',
      '${product.title} placed on VIP hold in your bag by Éléonore Vance.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(CupertinoIcons.sparkles, color: AppColors.champagneGold),
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final activeProduct = _showcaseProducts.isNotEmpty
        ? _showcaseProducts[_activeShowcaseIndex]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF07060F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Advisor Full-Screen Live Video Feed
          Image.network(
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
          ),

          // Cinematic Studio Lighting & Scrim Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.45, 0.95],
              ),
            ),
          ),

          // 2. Top Header: Stylist Info & Secure Call Indicator
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.champagneGold,
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.person_crop_circle_fill,
                            size: 24,
                            color: AppColors.champagneGold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Éléonore Vance',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.inStockGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Master Stylist • Paris Salon Flagship (1er)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Encrypted VIP Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.champagneGold.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.lock_fill, size: 10, color: AppColors.champagneGold),
                          SizedBox(width: 5),
                          Text(
                            'VIP ENCRYPTED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: AppColors.champagneGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Client Picture-in-Picture (PiP) Floating Self Camera Thumbnail
          Positioned(
            top: 100,
            right: 18,
            child: Container(
              width: 105,
              height: 145,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B22),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.champagneGold.withValues(alpha: 0.7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_isVideoOff)
                    const Center(
                      child: Icon(
                        CupertinoIcons.eye_slash,
                        color: Colors.white54,
                        size: 28,
                      ),
                    )
                  else
                    Image.network(
                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                    ),

                  // Mic Status Icon
                  if (_isMicMuted)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.saleRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.mic_slash_fill,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 4. Stylist Live Audio Equalizer Bar
          Positioned(
            top: 96,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _waveAnimController,
                    builder: (context, _) {
                      final v = _waveAnimController.value;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildWaveBar(6 + 8 * v),
                          const SizedBox(width: 2),
                          _buildWaveBar(12 - 6 * v),
                          const SizedBox(width: 2),
                          _buildWaveBar(8 + 5 * ((v + 0.5) % 1.0)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ÉLÉONORE SPEAKING',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: AppColors.champagneGold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Stylist Shared Catwalk Rack & In-Call Control Dock (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stylist Recommendation Spotlight Card
                    if (activeProduct != null)
                      LiquidGlassContainer(
                        borderRadius: 22,
                        blur: 24,
                        padding: const EdgeInsets.all(12),
                        color: Colors.black.withValues(alpha: 0.8),
                        borderColor: AppColors.champagneGold.withValues(alpha: 0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.sparkles,
                                      size: 12,
                                      color: AppColors.champagneGold,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'STYLIST SHARED LOOK (${_activeShowcaseIndex + 1}/${_showcaseProducts.length})',
                                      style: AppTypography.microTag(
                                        color: AppColors.champagneGold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        HapticService.selection();
                                        setState(() {
                                          _activeShowcaseIndex = (_activeShowcaseIndex - 1 + _showcaseProducts.length) % _showcaseProducts.length;
                                        });
                                      },
                                      child: const Icon(CupertinoIcons.chevron_left, size: 14, color: Colors.white70),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        HapticService.selection();
                                        setState(() {
                                          _activeShowcaseIndex = (_activeShowcaseIndex + 1) % _showcaseProducts.length;
                                        });
                                      },
                                      child: const Icon(CupertinoIcons.chevron_right, size: 14, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    activeProduct.primaryImage,
                                    width: 50,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activeProduct.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        controller.formatPrice(activeProduct.price),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.champagneGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.champagneGold,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () => _reservePiece(activeProduct),
                                  child: const Text(
                                    'RESERVE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),

                    // In-Call Action Dock
                    LiquidGlassContainer(
                      borderRadius: 30,
                      blur: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: Colors.black.withValues(alpha: 0.75),
                      borderColor: Colors.white12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDockIcon(
                            icon: _isMicMuted ? CupertinoIcons.mic_slash_fill : CupertinoIcons.mic_fill,
                            isActive: !_isMicMuted,
                            onTap: _toggleMic,
                          ),
                          _buildDockIcon(
                            icon: _isVideoOff ? CupertinoIcons.eye_slash : CupertinoIcons.videocam_fill,
                            isActive: !_isVideoOff,
                            onTap: _toggleVideo,
                          ),
                          _buildDockIcon(
                            icon: CupertinoIcons.switch_camera_solid,
                            isActive: true,
                            onTap: _switchCamera,
                          ),
                          _buildDockIcon(
                            icon: CupertinoIcons.scissors,
                            isActive: false,
                            onTap: () {
                              HapticService.light();
                              Get.to(() => const AtelierSalonBookingView());
                            },
                          ),
                          // End Call Button
                          GestureDetector(
                            onTap: _endCall,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.saleRed,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.saleRed,
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.phone_down_fill,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDockIcon({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.white24 : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.white : Colors.white38,
        ),
      ),
    );
  }

  Widget _buildWaveBar(double height) {
    return Container(
      width: 2.0,
      height: height.clamp(2.0, 14.0),
      decoration: BoxDecoration(
        color: AppColors.champagneGold,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

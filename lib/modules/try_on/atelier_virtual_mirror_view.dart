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
import '../../shared/widgets/image_fallback.dart';

enum MirrorAmbiance {
  parisDaylight(
    name: 'Paris Daylight',
    kelvin: '5,500K Clean Morning Sun',
    colorTint: Color(0x18C8E6FF),
    glowColor: Color(0xFFD4E8F8),
    icon: CupertinoIcons.sun_max_fill,
  ),
  goldenHour(
    name: 'Place Vendôme Sunset',
    kelvin: '3,200K Amber Golden Hour',
    colorTint: Color(0x35E6A864),
    glowColor: Color(0xFFE8B278),
    icon: CupertinoIcons.sunset_fill,
  ),
  operaGala(
    name: 'Opéra Garnier Candlelit',
    kelvin: '2,400K Warm Nocturne Glow',
    colorTint: Color(0x409E4820),
    glowColor: Color(0xFFD27B46),
    icon: CupertinoIcons.flame_fill,
  ),
  catwalkSpotlight(
    name: 'Grand Palais Runway',
    kelvin: '6,500K Directional Xenon',
    colorTint: Color(0x22FFFFFF),
    glowColor: Color(0xFFECECEC),
    icon: CupertinoIcons.bolt_fill,
  );

  final String name;
  final String kelvin;
  final Color colorTint;
  final Color glowColor;
  final IconData icon;

  const MirrorAmbiance({
    required this.name,
    required this.kelvin,
    required this.colorTint,
    required this.glowColor,
    required this.icon,
  });
}

class AtelierVirtualMirrorView extends StatefulWidget {
  final Product? initialProduct;

  const AtelierVirtualMirrorView({super.key, this.initialProduct});

  @override
  State<AtelierVirtualMirrorView> createState() => _AtelierVirtualMirrorViewState();
}

class _AtelierVirtualMirrorViewState extends State<AtelierVirtualMirrorView>
    with TickerProviderStateMixin {
  late Product _selectedProduct;
  MirrorAmbiance _selectedAmbiance = MirrorAmbiance.goldenHour;
  int _selectedAngleIndex = 0; // 0: Front, 1: 45° Profile, 2: Full Length
  String _selectedSize = '38 FR';

  late final AnimationController _scanLineController;
  late final AnimationController _shutterFlashController;
  bool _isSnapshotCaptured = false;

  final List<String> _angles = const ['Frontal Silhoette', '45° Drape Profile', 'Full-Length Stride'];
  final List<String> _sizes = const ['36 FR', '38 FR', '40 FR', '42 FR'];

  @override
  void initState() {
    super.initState();
    final controller = AtelierController.to;
    _selectedProduct = widget.initialProduct ?? controller.allProducts.first;

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _shutterFlashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _shutterFlashController.dispose();
    super.dispose();
  }

  void _captureSnapshot() {
    HapticService.heavy();
    _shutterFlashController.forward(from: 0.0);
    setState(() => _isSnapshotCaptured = true);

    Get.snackbar(
      'Haute Couture Snapshot Saved',
      'High-resolution fit composition recorded in your Atelier Private Lookbook.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: AppColors.champagneGold,
      icon: const Icon(CupertinoIcons.camera_fill, color: AppColors.champagneGold),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isSnapshotCaptured = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = AtelierController.to;

    return Scaffold(
      backgroundColor: const Color(0xFF07060F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Simulated Live Mirror Viewport Background
          _buildMirrorViewport(context),

          // 2. Dynamic Ambiance Color Grading Overlay
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            color: _selectedAmbiance.colorTint,
          ),

          // 3. Shutter Flash Animation Screen
          AnimatedBuilder(
            animation: _shutterFlashController,
            builder: (context, _) {
              if (_shutterFlashController.value == 0.0) return const SizedBox.shrink();
              return Container(
                color: Colors.white.withValues(
                  alpha: (1.0 - _shutterFlashController.value) * 0.9,
                ),
              );
            },
          ),

          // 4. Biometric HUD Overlays (Shoulder, Drop, Length reticles)
          _buildBiometricHudOverlay(),

          // Snapshot Captured Badge Pill
          if (_isSnapshotCaptured)
            Positioned(
              top: 96,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.champagneGold,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.champagneGold.withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.checkmark_alt, size: 14, color: Colors.black),
                      SizedBox(width: 6),
                      Text(
                        'SAVED TO LOOKBOOK',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 5. Top Controls & Header Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleButton(
                      icon: CupertinoIcons.back,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    Column(
                      children: [
                        Text(
                          'SALON MIROIR VIRTUEL',
                          style: AppTypography.brandLogo(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
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
                            Text(
                              'AR FIT & KINETIC SILHOUETTE',
                              style: AppTypography.microTag(color: AppColors.champagneGold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildCircleButton(
                      icon: CupertinoIcons.camera_fill,
                      color: AppColors.champagneGold,
                      iconColor: Colors.white,
                      onTap: _captureSnapshot,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 6. Bottom Tri-Fold Controls, Ambiance Selector & Actions
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomControls(isDark, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildMirrorViewport(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Garment Model Representation
          Image.network(
            _selectedProduct.primaryImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            errorBuilder: (_, __, ___) => const ImageFallback(width: double.infinity, height: double.infinity),
          ),

          // Vignette & Reflection Edge Frame
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.05,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.4, 0.75, 1.0],
              ),
            ),
          ),

          // Subtle Tri-Fold Mirror Vertical Dividers
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricHudOverlay() {
    return AnimatedBuilder(
      animation: _scanLineController,
      builder: (context, _) {
        final scanY = MediaQuery.of(context).size.height * (0.2 + 0.45 * _scanLineController.value);

        return Stack(
          children: [
            // Horizontal Laser Scan Beam
            Positioned(
              top: scanY,
              left: 30,
              right: 30,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.champagneGold.withValues(alpha: 0.8),
                      Colors.white,
                      AppColors.champagneGold.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.champagneGold.withValues(alpha: 0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),

            // Shoulder Balance Crosshairs
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28,
              left: 40,
              child: _buildHudMarker('SHOULDER PITCH: 41.2 cm • -4° BIAS'),
            ),

            // Chest Drape Tension
            Positioned(
              top: MediaQuery.of(context).size.height * 0.42,
              right: 40,
              child: _buildHudMarker('CHEST VOLUMETRIC DROP: 18.0 cm'),
            ),

            // Hem Aerodynamic Stride clearance
            Positioned(
              top: MediaQuery.of(context).size.height * 0.58,
              left: 40,
              child: _buildHudMarker('HEM CLEARANCE: 34 cm ABOVE ANKLE'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHudMarker(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.champagneGold.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.champagneGold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontFamily: 'Courier',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.champagneGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(bool isDark, AtelierController controller) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Perspective Angle & Size Selector Pills
            LiquidGlassContainer(
              borderRadius: 22,
              blur: 24,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.black.withValues(alpha: 0.75),
              borderColor: Colors.white12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Angle buttons
                  Row(
                    children: List.generate(_angles.length, (i) {
                      final isSelected = _selectedAngleIndex == i;
                      final label = ['FRONT', 'PROFILE', 'FULL'][i];

                      return GestureDetector(
                        onTap: () {
                          HapticService.selection();
                          setState(() => _selectedAngleIndex = i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.champagneGold : Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: isSelected ? Colors.black : Colors.white70,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  // Size selection pill
                  Row(
                    children: _sizes.map((sz) {
                      final isSelected = _selectedSize == sz;
                      return GestureDetector(
                        onTap: () {
                          HapticService.selection();
                          setState(() => _selectedSize = sz);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.white24,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            sz.split(' ').first,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.black : Colors.white60,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 2. Ambiance Lighting Mode Selector Carousel
            LiquidGlassContainer(
              borderRadius: 24,
              blur: 24,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: Colors.black.withValues(alpha: 0.8),
              borderColor: AppColors.champagneGold.withValues(alpha: 0.35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LIGHTING AMBIANCE',
                        style: AppTypography.microTag(color: AppColors.champagneGold),
                      ),
                      Text(
                        _selectedAmbiance.kelvin,
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: MirrorAmbiance.values.map((ambiance) {
                      final isSelected = _selectedAmbiance == ambiance;

                      return GestureDetector(
                        onTap: () {
                          HapticService.selection();
                          setState(() => _selectedAmbiance = ambiance);
                        },
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? ambiance.glowColor.withValues(alpha: 0.3)
                                    : Colors.white.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: isSelected ? ambiance.glowColor : Colors.white24,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: ambiance.glowColor.withValues(alpha: 0.45),
                                          blurRadius: 12,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                ambiance.icon,
                                size: 18,
                                color: isSelected ? ambiance.glowColor : Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ambiance.name.split(' ').first,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 3. Action Bar: Add to Bag & Book Tailor
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 4,
                    ),
                    onPressed: () {
                      HapticService.success();
                      controller.addToCart(
                        product: _selectedProduct,
                        size: _selectedSize,
                        color: _selectedProduct.colorVariants.isNotEmpty
                            ? _selectedProduct.colorVariants.first
                            : const ProductColorVariant(name: 'Default', color: Colors.black, images: []),
                      );
                      Get.snackbar(
                        'Piece Added from Virtual Mirror',
                        '${_selectedProduct.title} (Size $_selectedSize) placed in your bag.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                      );
                    },
                    icon: const Icon(CupertinoIcons.bag_fill, size: 16),
                    label: Text(
                      'ADD TO BAG • ${controller.formatPrice(_selectedProduct.price)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    HapticService.light();
                    Get.to(() => const AtelierSalonBookingView());
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.champagneGold.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.scissors,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        onTap();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color ?? Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: iconColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

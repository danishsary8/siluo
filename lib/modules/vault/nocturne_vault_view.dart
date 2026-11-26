import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/editorial_shimmer_box.dart';

class NocturneVaultView extends StatefulWidget {
  const NocturneVaultView({super.key});

  @override
  State<NocturneVaultView> createState() => _NocturneVaultViewState();
}

class _NocturneVaultViewState extends State<NocturneVaultView>
    with SingleTickerProviderStateMixin {
  bool _isUnlocked = false;
  late AnimationController _holdAnimController;

  @override
  void initState() {
    super.initState();
    _holdAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _holdAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticService.success();
        setState(() => _isUnlocked = true);
      }
    });
  }

  @override
  void dispose() {
    _holdAnimController.dispose();
    super.dispose();
  }

  void _onHoldStart() {
    if (!_isUnlocked) {
      HapticService.selection();
      _holdAnimController.forward();
    }
  }

  void _onHoldEnd() {
    if (!_isUnlocked && _holdAnimController.status != AnimationStatus.completed) {
      _holdAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07060F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'LE SALON PRIVÉ',
          style: AppTypography.brandLogo(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _isUnlocked ? _buildVaultCatalogue() : _buildLockScreen(),
      ),
    );
  }

  Widget _buildLockScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gold Lock Icon Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.champagneGold, width: 1.5),
              ),
              child: const Icon(
                CupertinoIcons.lock_shield_fill,
                color: AppColors.champagneGold,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'ATELIER NOCTURNE VAULT',
              style: AppTypography.sectionTitle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Exclusive access reserved for Atelier Privilege members. Contains numbered runway archives and bespoke 1-of-1 creations.',
              textAlign: TextAlign.center,
              style: AppTypography.body(color: Colors.white60),
            ),
            const SizedBox(height: 50),

            // Press & Hold Optical Fingerprint Ring
            GestureDetector(
              onTapDown: (_) => _onHoldStart(),
              onTapUp: (_) => _onHoldEnd(),
              onTapCancel: () => _onHoldEnd(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated progress ring
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: AnimatedBuilder(
                      animation: _holdAnimController,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _holdAnimController.value,
                          strokeWidth: 3,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.champagneGold),
                          backgroundColor: Colors.white12,
                        );
                      },
                    ),
                  ),
                  // Center gold thumb circle
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.champagneGold.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.5)),
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.sparkles,
                        color: AppColors.champagneGold,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'PRESS & HOLD TO UNLOCK',
              style: AppTypography.microTag(color: AppColors.champagneGold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaultCatalogue() {
    final List<Map<String, dynamic>> vaultPieces = [
      {
        'title': 'Nocturne Hand-Embroidered Velvet Cape',
        'subtitle': 'Numbered Piece 01 / 01 Worldwide',
        'price': '\$2,800',
        'image': 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=1200&q=85',
        'specs': '24k gold bullion metallic thread on vintage Lyon silk velvet.',
      },
      {
        'title': 'Sculptural Obsidian & 18k Cuff',
        'subtitle': 'Numbered Edition 03 / 05',
        'price': '\$1,650',
        'image': 'https://images.unsplash.com/photo-1611591475819-79b8b73ff2f3?auto=format&fit=crop&w=1200&q=85',
        'specs': 'Raw black obsidian hand-carved in Milan with satin yellow gold setting.',
      },
      {
        'title': 'Croc-Embossed Architectural Trunk',
        'subtitle': 'Numbered Edition 02 / 10',
        'price': '\$3,400',
        'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=1200&q=85',
        'specs': 'Structured bridle leather with brushed champagne brass lock mechanism.',
      },
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRIVATE SALON COLLECTION', style: AppTypography.microTag(color: AppColors.champagneGold)),
                const SizedBox(height: 4),
                Text('Numbered Archive Edits', style: AppTypography.sectionTitle(color: Colors.white)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.champagneGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.champagneGold, width: 0.8),
              ),
              child: const Text(
                'UNLOCKED',
                style: TextStyle(
                  color: AppColors.champagneGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // List of Pieces
        ...vaultPieces.map((piece) {
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF111116),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      piece['image'] as String,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const EditorialShimmerBox(
                          height: 240,
                          width: double.infinity,
                          borderRadius: BorderRadius.zero,
                        );
                      },
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.champagneGold, width: 0.8),
                        ),
                        child: Text(
                          piece['subtitle'] as String,
                          style: const TextStyle(
                            color: AppColors.champagneGold,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              piece['title'] as String,
                              style: AppTypography.productTitle(color: Colors.white),
                            ),
                          ),
                          Text(
                            piece['price'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        piece['specs'] as String,
                        style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            HapticService.success();
                            Get.snackbar(
                              'Private Salon Inquiry',
                              'Your concierge request for ${piece['title']} has been logged.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                              margin: const EdgeInsets.all(16),
                            );
                          },
                          child: const Text(
                            'REQUEST PRIVATE APPOINTMENT',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

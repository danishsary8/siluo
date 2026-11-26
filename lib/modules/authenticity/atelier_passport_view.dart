import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/liquid_glass_container.dart';

/// AtelierPassportView renders an ultra-exclusive interactive Holographic NFC Certificate of Authenticity.
/// Features 3D pointer-reactive iridescent foil shimmer, cryptographic blockchain verification,
/// and master tailor artisan signatures.
class AtelierPassportView extends StatefulWidget {
  final String serialNumber;
  final String garmentTitle;
  final String artisan;

  const AtelierPassportView({
    super.key,
    this.serialNumber = 'ATL-8942-PARIS-2026',
    this.garmentTitle = 'Double-Breasted Cashmere Overcoat',
    this.artisan = 'M. Marc Duchamp, Maître Tailleur Paris',
  });

  @override
  State<AtelierPassportView> createState() => _AtelierPassportViewState();
}

class _AtelierPassportViewState extends State<AtelierPassportView>
    with SingleTickerProviderStateMixin {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  Offset _shimmerAlign = const Offset(0, 0);
  bool _isNfcTapped = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event, BoxConstraints constraints) {
    final centerX = constraints.maxWidth / 2;
    final centerY = constraints.maxHeight / 2;
    final dx = (event.localPosition.dx - centerX) / centerX;
    final dy = (event.localPosition.dy - centerY) / centerY;

    setState(() {
      _rotateX = (-dy * 0.12).clamp(-0.15, 0.15);
      _rotateY = (dx * 0.12).clamp(-0.15, 0.15);
      _shimmerAlign = Offset(dx, dy);
    });
  }

  void _resetTilt() {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
      _shimmerAlign = const Offset(0, 0);
    });
  }

  void _handleSimulateNfc() {
    HapticService.heavy();
    setState(() => _isNfcTapped = true);
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _isNfcTapped = false);
    });
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
          'CERTIFICAT D’AUTHENTICITÉ',
          style: AppTypography.brandLogo(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              'TOUCH AND TILT TO INSPECT HOLOGRAPHIC SECURITY SEAL',
              textAlign: TextAlign.center,
              style: AppTypography.microTag(color: AppColors.champagneGold),
            ),
            const SizedBox(height: 20),

            // 3D Tiltable Holographic Passport Card
            LayoutBuilder(
              builder: (context, constraints) {
                return Listener(
                  onPointerMove: (e) => _onPointerMove(e, constraints),
                  onPointerUp: (_) => _resetTilt(),
                  onPointerCancel: (_) => _resetTilt(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_rotateX)
                      ..rotateY(_rotateY),
                    transformAlignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF15122A),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.champagneGold.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.champagneGold.withValues(alpha: 0.2),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                          const BoxShadow(
                            color: Colors.black,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          // Holographic Dynamic Sheen Layer
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: 0.45,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment(-1.5 + _shimmerAlign.dx, -1.0 + _shimmerAlign.dy),
                                        end: Alignment(1.5 + _shimmerAlign.dx, 1.0 + _shimmerAlign.dy),
                                        colors: [
                                          Colors.transparent,
                                          const Color(0xFFD4AF37).withValues(alpha: 0.3), // Gold
                                          const Color(0xFFE0C3FC).withValues(alpha: 0.3), // Iridescent Violet
                                          const Color(0xFF8EC5FC).withValues(alpha: 0.3), // Soft Cyan
                                          const Color(0xFFD4AF37).withValues(alpha: 0.3),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.25, 0.5, 0.7, 0.85, 1.0],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Card Contents
                          Padding(
                            padding: const EdgeInsets.all(26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Crest & NFC Icon
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'A T E L I E R',
                                          style: GoogleFonts.cormorantGaramond(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 4.0,
                                            color: AppColors.champagneGold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'PARIS • PLACE VENDÔME',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.2,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // NFC Chip Emblem
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.champagneGold.withValues(alpha: 0.15),
                                        border: Border.all(
                                          color: AppColors.champagneGold.withValues(alpha: 0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.radiowaves_right,
                                        color: AppColors.champagneGold,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 28),

                                // Serial Code
                                const Text(
                                  'TAMPER-PROOF SERIAL NUMBER',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.serialNumber,
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0,
                                    color: Colors.white,
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Divider(color: Colors.white12, height: 1),
                                ),

                                // Garment Name
                                const Text(
                                  'HAUTE COUTURE SPECIFICATION',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.garmentTitle,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Provenance & Artisan
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'MASTER ARTISAN',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.0,
                                              color: Colors.white38,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            widget.artisan,
                                            style: GoogleFonts.cormorantGaramond(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.champagneGold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ORIGIN WEAVE',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.0,
                                              color: Colors.white38,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            'Lanificio di Tollegno, Biella',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Cryptographic Aura Blockchain Seal
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.checkmark_seal_fill,
                                        color: AppColors.inStockGreen,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Cryptographically Secured • Aura Consortium Blockchain',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // NFC Tap Interactive Action
            GestureDetector(
              onTap: _handleSimulateNfc,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isNfcTapped
                      ? AppColors.inStockGreen.withValues(alpha: 0.15)
                      : const Color(0xFF17132C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isNfcTapped
                        ? AppColors.inStockGreen
                        : AppColors.champagneGold.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isNfcTapped
                            ? AppColors.inStockGreen.withValues(alpha: 0.2)
                            : AppColors.champagneGold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isNfcTapped
                            ? CupertinoIcons.checkmark_alt
                            : CupertinoIcons.dot_radiowaves_left_right,
                        color: _isNfcTapped ? AppColors.inStockGreen : AppColors.champagneGold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isNfcTapped ? 'AUTHENTICITY VERIFIED' : 'TEST PHYSICAL NFC TAG',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: _isNfcTapped ? AppColors.inStockGreen : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _isNfcTapped
                                ? 'Cryptographic handshake verified with Paris registry.'
                                : 'Hold device near the woven care label of your garment.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Ownership Privileges
            LiquidGlassContainer(
              padding: const EdgeInsets.all(20),
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXCLUSIVE ATELIER PRIVILEGES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.champagneGold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPrivilegeRow(CupertinoIcons.sparkles, 'Lifetime Complimentary Seam Alterations'),
                  const SizedBox(height: 10),
                  _buildPrivilegeRow(CupertinoIcons.shield_fill, 'Annual Cedar Steaming & Condition Inspection'),
                  const SizedBox(height: 10),
                  _buildPrivilegeRow(CupertinoIcons.person_crop_circle_badge_checkmark, 'Priority Invitation to Paris Haute Couture Week'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivilegeRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.champagneGold),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}

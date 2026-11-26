import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class AtelierClubView extends StatefulWidget {
  const AtelierClubView({super.key});

  @override
  State<AtelierClubView> createState() => _AtelierClubViewState();
}

class _AtelierClubViewState extends State<AtelierClubView> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  void _onPointerMove(PointerMoveEvent event, BoxConstraints constraints) {
    final centerX = constraints.maxWidth / 2;
    final centerY = constraints.maxHeight / 2;
    final dx = (event.localPosition.dx - centerX) / centerX;
    final dy = (event.localPosition.dy - centerY) / centerY;

    setState(() {
      _rotateX = (-dy * 0.1).clamp(-0.12, 0.12);
      _rotateY = (dx * 0.1).clamp(-0.12, 0.12);
    });
  }

  void _resetTilt() {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08070F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'LE CLUB NOCTURNE',
          style: AppTypography.brandLogo(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          Text(
            'TOUCH AND TILT TO INSPECT TITANIUM MEMBERSHIP CARD',
            textAlign: TextAlign.center,
            style: AppTypography.microTag(color: AppColors.champagneGold),
          ),
          const SizedBox(height: 18),

          // 3D Tiltable Titanium Card
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
                    height: 210,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1631),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.champagneGold.withValues(alpha: 0.7),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.champagneGold.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                        const BoxShadow(
                          color: Colors.black,
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Brushed Metal Specular Highlight
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.15),
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),

                        // Card Content
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Logo & Chip
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
                                      const Text(
                                        'CERCLE OBSIDIEN • TIER IV',
                                        style: TextStyle(
                                          fontSize: 8,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Laser Chip
                                  Container(
                                    width: 38,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                                      border: Border.all(color: AppColors.champagneGold, width: 1.2),
                                    ),
                                    child: const Center(
                                      child: Icon(CupertinoIcons.circle_grid_hex_fill, size: 16, color: AppColors.champagneGold),
                                    ),
                                  ),
                                ],
                              ),

                              // Cardholder Name & Number
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '•••• •••• •••• 9201',
                                    style: GoogleFonts.sourceCodePro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 3.0,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'CLAIRE DUBOIS',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'MEMBER SINCE 2024',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white54,
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
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          // Points Status & Next Tier
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF17132C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TIER PRIVILEGE PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.champagneGold, letterSpacing: 1.0)),
                    Text('4,850 / 5,000 PTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9))),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.92,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.champagneGold),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Only 150 points to unlock "Haute Couture Circle" with annual private runway front-row invitation.',
                  style: TextStyle(fontSize: 11, color: Colors.white60, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Exclusive Privileges
          const Text('ACTIVE MEMBER PRIVILEGES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Colors.white54)),
          const SizedBox(height: 12),
          _buildPrivilegeCard(
            CupertinoIcons.sparkles,
            'Private Salon Fitting Suites',
            'Complimentary champagne and dedicated master tailor fitting in Paris, Milan, London, and Tokyo.',
          ),
          _buildPrivilegeCard(
            CupertinoIcons.ticket_fill,
            'Runway Show Invitations',
            'Exclusive priority reservations for Paris Fashion Week seasonal ready-to-wear and couture shows.',
          ),
          _buildPrivilegeCard(
            CupertinoIcons.airplane,
            'White Glove Global Courier',
            'Zero-emission express delivery with garment hanging bags and same-day courier dispatch in Paris.',
          ),
          _buildPrivilegeCard(
            CupertinoIcons.gift_fill,
            'Annual Bespoke Silk Commission',
            'Complimentary personalized silk carré scarf illustrated by the Atelier creative atelier each winter.',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivilegeCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161229),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.champagneGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.champagneGold, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

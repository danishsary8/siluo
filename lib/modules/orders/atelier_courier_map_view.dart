import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/liquid_glass_container.dart';

class AtelierCourierMapView extends StatefulWidget {
  final String orderId;

  const AtelierCourierMapView({
    super.key,
    this.orderId = '#ATL-894201',
  });

  @override
  State<AtelierCourierMapView> createState() => _AtelierCourierMapViewState();
}

class _AtelierCourierMapViewState extends State<AtelierCourierMapView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  bool _isPinCopied = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyHandoverPin() {
    HapticService.success();
    setState(() => _isPinCopied = true);
    Get.snackbar(
      'Encrypted Handover PIN Copied',
      'Present #4829-ATELIER to Chauffeur Jean-Paul upon white-glove arrival.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: AppColors.champagneGold,
      icon: const Icon(CupertinoIcons.lock_shield_fill, color: AppColors.champagneGold),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isPinCopied = false);
    });
  }

  void _callChauffeur() {
    HapticService.selection();
    Get.snackbar(
      'Connecting Diplomatic Chauffeur',
      'Dialing secure satellite line to Mercedes-Maybach (CDG-774-PAIX)...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090C),
      body: Stack(
        children: [
          // 1. High-Fashion Vector Map Canvas
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _HauteCoutureMapPainter(progress: _animController.value),
                );
              },
            ),
          ),

          // 2. Top Navigation Bar & Live Badge
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
                    _buildRoundButton(
                      icon: CupertinoIcons.back,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.champagneGold.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.champagneGold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE CHAUFFEUR DISPATCH',
                            style: AppTypography.microTag(color: AppColors.champagneGold),
                          ),
                        ],
                      ),
                    ),
                    _buildRoundButton(
                      icon: CupertinoIcons.phone_fill,
                      color: AppColors.champagneGold,
                      iconColor: Colors.white,
                      onTap: _callChauffeur,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Telemetry & Destination Overlay Card (Middle-Top)
          Positioned(
            top: 110,
            left: 20,
            right: 20,
            child: LiquidGlassContainer(
              borderRadius: 22,
              blur: 24,
              padding: const EdgeInsets.all(16),
              color: Colors.black.withValues(alpha: 0.78),
              borderColor: Colors.white12,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.car_detailed,
                        color: AppColors.champagneGold,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EN ROUTE • ETA 24 MIN',
                              style: AppTypography.microTag(color: AppColors.champagneGold),
                            ),
                            const Text(
                              '11:36 AM ARRIVAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Courier',
                                fontWeight: FontWeight.w700,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Traversing Rue du Faubourg Saint-Honoré',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Drawer: Telemetry Metrics, Chauffeur Dossier, and Handover PIN
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
                    // Vehicle Climate & Fabric Protection Bar
                    LiquidGlassContainer(
                      borderRadius: 20,
                      blur: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      color: const Color(0xFF17132C).withValues(alpha: 0.88),
                      borderColor: Colors.white10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTelemetryItem(
                            icon: CupertinoIcons.thermometer,
                            value: '19.5°C',
                            label: 'CABIN CLIMATE',
                          ),
                          Container(width: 1, height: 24, color: Colors.white12),
                          _buildTelemetryItem(
                            icon: CupertinoIcons.drop,
                            value: '45% RH',
                            label: 'SILK HUMIDITY',
                          ),
                          Container(width: 1, height: 24, color: Colors.white12),
                          _buildTelemetryItem(
                            icon: CupertinoIcons.shield_fill,
                            value: 'ACTIVE',
                            label: 'ANTI-CREASE SUSPENSION',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Chauffeur Dossier & Handover PIN Container
                    LiquidGlassContainer(
                      borderRadius: 26,
                      blur: 24,
                      padding: const EdgeInsets.all(18),
                      color: Colors.black.withValues(alpha: 0.85),
                      borderColor: AppColors.champagneGold.withValues(alpha: 0.35),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Chauffeur Identity Row
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.champagneGold,
                                    width: 1.2,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          'Jean-Paul Mercier',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          CupertinoIcons.checkmark_seal_fill,
                                          size: 13,
                                          color: AppColors.champagneGold,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Certified White-Glove Diplomatic Courier',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Mercedes-Maybach S680 • Plate: 75-ATELIER-01',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Courier',
                                        color: AppColors.champagneGold.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Colors.white12),
                          const SizedBox(height: 14),

                          // Handover Encrypted Passcode Box
                          GestureDetector(
                            onTap: _copyHandoverPin,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.champagneGold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.champagneGold.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'HANDOVER PASSCODE',
                                        style: AppTypography.microTag(color: AppColors.champagneGold),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        '# 4 8 2 9 - A T E L I E R',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Courier',
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _isPinCopied ? AppColors.inStockGreen : AppColors.champagneGold,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isPinCopied ? CupertinoIcons.checkmark_alt : CupertinoIcons.doc_on_clipboard,
                                          size: 12,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _isPinCopied ? 'COPIED' : 'COPY',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.6,
                                            color: Colors.black,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.champagneGold),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w600,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }

  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color ?? Colors.black.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 16,
            color: iconColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

class _HauteCoutureMapPainter extends CustomPainter {
  final double progress;

  _HauteCoutureMapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Velvet Base Map Background
    final bgPaint = Paint()..color = const Color(0xFF0B0917);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Parisian City Grid Lines (Haussmann Boulevards)
    final gridPaint = Paint()
      ..color = const Color(0xFF1B1B22)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final riverPaint = Paint()
      ..color = const Color(0xFF141724)
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke;

    // Draw stylized Seine River Curve
    final riverPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.40,
        size.width * 0.65,
        size.height * 0.52,
        size.width,
        size.height * 0.48,
      );
    canvas.drawPath(riverPath, riverPaint);

    // Radial Avenue Lines from Place Charles de Gaulle / Vendôme
    final center = Offset(size.width * 0.5, size.height * 0.42);
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final end = Offset(
        center.dx + 400 * math.cos(angle),
        center.dy + 400 * math.sin(angle),
      );
      canvas.drawLine(center, end, gridPaint);
    }

    // Concentric Circular Ring Boulevards
    for (double r = 60; r <= 320; r += 65) {
      canvas.drawCircle(center, r, gridPaint);
    }

    // 3. Active Delivery Route (Golden Bezier curve from CDG to Vendôme to Residence)
    final startPoint = Offset(size.width * 0.85, size.height * 0.18); // CDG Airport
    final midPoint = Offset(size.width * 0.48, size.height * 0.40); // 12 Rue de la Paix
    final endPoint = Offset(size.width * 0.25, size.height * 0.62); // Residence

    final routePath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..cubicTo(
        size.width * 0.70,
        size.height * 0.28,
        size.width * 0.60,
        size.height * 0.35,
        midPoint.dx,
        midPoint.dy,
      )
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.45,
        size.width * 0.35,
        size.height * 0.55,
        endPoint.dx,
        endPoint.dy,
      );

    // Route Outer Glow
    final glowPaint = Paint()
      ..color = AppColors.champagneGold.withValues(alpha: 0.25)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(routePath, glowPaint);

    // Route Solid Core
    final routePaint = Paint()
      ..color = AppColors.champagneGold
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(routePath, routePaint);

    // 4. Milestone Waypoint Pins
    _drawWaypoint(canvas, startPoint, 'CDG AIRPORT', false);
    _drawWaypoint(canvas, midPoint, 'ATELIER RUE DE LA PAIX', false);
    _drawWaypoint(canvas, endPoint, 'PRIVATE RESIDENCE', true);

    // 5. Animated Chauffeur Car Beacon
    // Calculate vehicle position along route based on progress
    final t = (progress + 0.3) % 1.0;
    final carPos = _evalBezierPoint(startPoint, midPoint, endPoint, t);

    // Pulsing Radar Rings around car
    final pulsePaint = Paint()
      ..color = AppColors.champagneGold.withValues(alpha: 0.4 * (1.0 - (progress % 1.0)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(carPos, 16 + (progress * 18), pulsePaint);

    // Core Car Pin
    final carCorePaint = Paint()..color = Colors.white;
    canvas.drawCircle(carPos, 6, carCorePaint);
    final carBorderPaint = Paint()
      ..color = AppColors.champagneGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(carPos, 6, carBorderPaint);
  }

  Offset _evalBezierPoint(Offset p0, Offset p1, Offset p2, double t) {
    // Quadratic bezier approximation between points
    final u = 1 - t;
    final tt = t * t;
    final uu = u * u;
    final x = uu * p0.dx + 2 * u * t * p1.dx + tt * p2.dx;
    final y = uu * p0.dy + 2 * u * t * p1.dy + tt * p2.dy;
    return Offset(x, y);
  }

  void _drawWaypoint(Canvas canvas, Offset pos, String label, bool isDestination) {
    final dotPaint = Paint()..color = isDestination ? Colors.white : AppColors.champagneGold;
    canvas.drawCircle(pos, isDestination ? 5 : 4, dotPaint);

    final ringPaint = Paint()
      ..color = isDestination ? AppColors.champagneGold : Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(pos, 8, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _HauteCoutureMapPainter oldDelegate) => true;
}

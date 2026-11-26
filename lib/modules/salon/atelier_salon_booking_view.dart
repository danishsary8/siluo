import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/image_fallback.dart';

class SalonCity {
  final String id;
  final String name;
  final String address;
  final String imageUrl;

  const SalonCity({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
  });
}

class AtelierSalonBookingView extends StatefulWidget {
  const AtelierSalonBookingView({super.key});

  @override
  State<AtelierSalonBookingView> createState() => _AtelierSalonBookingViewState();
}

class _AtelierSalonBookingViewState extends State<AtelierSalonBookingView> {
  int _selectedCityIndex = 0;
  int _selectedStylistIndex = 0;
  int _selectedHospitalityIndex = 0;
  int _selectedTimeIndex = 1;
  bool _isConfirmed = false;

  final List<SalonCity> _cities = const [
    SalonCity(
      id: 'paris',
      name: 'Place Vendôme, Paris',
      address: '14 Rue de la Paix, 1er Arrondissement',
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&auto=format&fit=crop&q=80',
    ),
    SalonCity(
      id: 'milan',
      name: 'Via Montenapoleone, Milan',
      address: 'Via Montenapoleone 8, Quadrilatero della Moda',
      imageUrl: 'https://images.unsplash.com/photo-1513581166391-887a96ddeafd?w=800&auto=format&fit=crop&q=80',
    ),
    SalonCity(
      id: 'london',
      name: 'New Bond Street, London',
      address: '42 New Bond Street, Mayfair',
      imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&auto=format&fit=crop&q=80',
    ),
    SalonCity(
      id: 'tokyo',
      name: 'Ginza Six, Tokyo',
      address: '6-10-1 Ginza, Chuo-ku',
      imageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800&auto=format&fit=crop&q=80',
    ),
  ];

  final List<Map<String, String>> _stylists = const [
    {'name': 'M. Marc Duchamp', 'role': 'Senior Tailor • Outerwear & Drape Specialist'},
    {'name': 'Éléonore Vance', 'role': 'Creative Stylist • Eveningwear & Silk Bias'},
    {'name': 'Kenji Takahashi', 'role': 'Master Couturier • Minimalist Geometries'},
  ];

  final List<Map<String, dynamic>> _hospitality = const [
    {
      'title': 'Dom Pérignon Vintage 2013',
      'subtitle': 'Served with artisanal Pierre Hermé macarons',
      'icon': CupertinoIcons.sparkles,
    },
    {
      'title': 'Mariage Frères Grand Cru Tea',
      'subtitle': 'Imperial Marco Polo black tea with madeleines',
      'icon': CupertinoIcons.leaf_arrow_circlepath,
    },
    {
      'title': 'Italian Roast Espresso & Still Water',
      'subtitle': 'Double-shot extraction with dark praline cacao',
      'icon': CupertinoIcons.drop,
    },
  ];

  final List<String> _times = const [
    '11:00 AM',
    '02:30 PM',
    '04:30 PM',
    '06:00 PM',
  ];

  void _handleConfirm() {
    HapticService.heavy();
    setState(() => _isConfirmed = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      appBar: AppBar(
        title: Text(
          'VIP PRIVATE SALON',
          style: AppTypography.productTitle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _isConfirmed ? _buildConfirmedInvitation(isDark) : _buildBookingForm(isDark),
      ),
    );
  }

  Widget _buildBookingForm(bool isDark) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'COMPLIMENTARY PRIVATE FITTING APPOINTMENT',
          style: AppTypography.microTag(color: AppColors.champagneGold),
        ),
        const SizedBox(height: 4),
        Text(
          'Select your preferred Atelier house and enjoy dedicated styling in our private fitting suites.',
          style: AppTypography.body(
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),

        // 1. Select Flagship City
        Text(
          '1. SELECT ATELIER FLAGSHIP HOUSE',
          style: AppTypography.microTag(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _cities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final city = _cities[index];
              final isSelected = _selectedCityIndex == index;

              return GestureDetector(
                onTap: () {
                  HapticService.selection();
                  setState(() => _selectedCityIndex = index);
                },
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.champagneGold
                          : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColors.champagneGold.withValues(alpha: 0.25),
                          blurRadius: 14,
                        ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(city.imageUrl, fit: BoxFit.cover,
 errorBuilder: ImageFallback.builder,),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              city.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              city.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 28),

        // 2. Select Personal Stylist
        Text(
          '2. PERSONAL MASTER COUTURIER',
          style: AppTypography.microTag(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: _stylists.asMap().entries.map((entry) {
            final idx = entry.key;
            final stylist = entry.value;
            final isSelected = _selectedStylistIndex == idx;

            return GestureDetector(
              onTap: () {
                HapticService.selection();
                setState(() => _selectedStylistIndex = idx);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.ctaDark)
                        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected ? AppColors.champagneGold : Colors.grey.shade300,
                      child: Text(
                        stylist['name']![0],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stylist['name']!,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            stylist['role']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(CupertinoIcons.checkmark_alt, color: AppColors.champagneGold, size: 18),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // 3. Hospitality Ritual
        Text(
          '3. COMPLIMENTARY HOSPITALITY RITUAL',
          style: AppTypography.microTag(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: _hospitality.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isSelected = _selectedHospitalityIndex == idx;

            return GestureDetector(
              onTap: () {
                HapticService.selection();
                setState(() => _selectedHospitalityIndex = idx);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.champagneGold
                        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, color: AppColors.champagneGold, size: 20),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            item['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // 4. Time Slot
        Text(
          '4. SELECT APPOINTMENT TIME (TOMORROW)',
          style: AppTypography.microTag(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _times.asMap().entries.map((entry) {
            final idx = entry.key;
            final time = entry.value;
            final isSelected = _selectedTimeIndex == idx;

            return GestureDetector(
              onTap: () {
                HapticService.selection();
                setState(() => _selectedTimeIndex = idx);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.ctaDark)
                      : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
                  ),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? AppColors.canvasDark : Colors.white)
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 36),

        // Confirm Reservation Button
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
              foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: _handleConfirm,
            child: Text(
              'CONFIRM VIP SALON RESERVATION',
              style: AppTypography.buttonLabel(
                color: isDark ? AppColors.canvasDark : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmedInvitation(bool isDark) {
    final selectedCity = _cities[_selectedCityIndex];
    final selectedStylist = _stylists[_selectedStylistIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gold Seal Badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.champagneGold, width: 2),
                color: AppColors.champagneGold.withValues(alpha: 0.15),
              ),
              child: const Icon(CupertinoIcons.checkmark_alt, size: 36, color: AppColors.champagneGold),
            ),
            const SizedBox(height: 24),

            Text(
              'RÉSERVATION CONFIRMÉE',
              style: AppTypography.microTag(color: AppColors.champagneGold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Salon Fitting is Booked',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            // Invitation Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1631) : const Color(0xFFF5F2FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.champagneGold.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  Text(
                    selectedCity.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedCity.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMuted),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Stylist', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(selectedStylist['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Time', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Tomorrow at ${_times[_selectedTimeIndex]}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.champagneGold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : AppColors.ctaDark,
                  foregroundColor: isDark ? AppColors.canvasDark : Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'RETURN TO ATELIER',
                  style: AppTypography.buttonLabel(
                    color: isDark ? AppColors.canvasDark : Colors.white,
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

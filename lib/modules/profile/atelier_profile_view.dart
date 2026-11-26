import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../concierge/atelier_concierge_sheet.dart';
import '../vault/nocturne_vault_view.dart';
import '../orders/atelier_order_tracking_view.dart';
import '../authenticity/atelier_passport_view.dart';
import '../salon/atelier_salon_booking_view.dart';
import '../wardrobe/atelier_wardrobe_view.dart';
import '../vip/atelier_club_view.dart';
import '../soundscape/atelier_acoustic_view.dart';
import '../archive/atelier_heritage_archive_view.dart';
import '../journal/atelier_journal_view.dart';
import '../concierge/atelier_consultation_suite_view.dart';

class AtelierProfileView extends StatelessWidget {
  const AtelierProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AtelierController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
          physics: const BouncingScrollPhysics(),
          children: [
            // Editorial Header & User Info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.champagneGold, width: 1.5),
                  ),
                  child: const CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sary Danish',
                        style: AppTypography.sectionTitle(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          HapticService.light();
                          Get.to(() => const AtelierClubView());
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.silouPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.silouPrimary, width: 0.8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.star_fill, size: 12, color: AppColors.silouPrimary),
                              SizedBox(width: 4),
                              Text(
                                'SILOU VIP (GOLD TIER)',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: AppColors.silouPrimary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(CupertinoIcons.chevron_right, size: 10, color: AppColors.silouPrimary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Atelier Settings & Preferences Section
            _buildSectionHeader('PREFERENCES & APPEARANCE', isDark),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Column(
                children: [
                  // Dark Mode Switch Tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                              size: 22,
                              color: isDark ? AppColors.champagneGold : AppColors.ctaDark,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'Obsidian Dark Mode',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        Obx(() => CupertinoSwitch(
                              value: controller.isDarkMode.value,
                              activeTrackColor: AppColors.champagneGold,
                              onChanged: (_) => controller.toggleDarkMode(),
                            )),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.shield_lefthalf_fill,
                    title: 'Le Club Nocturne',
                    subtitle: 'Titanium membership card & couture privileges',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierClubView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.tray_full_fill,
                    title: 'Le Dressing Privé',
                    subtitle: 'Digital wardrobe vault & AI capsule stylist',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierWardrobeView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.lock_shield_fill,
                    title: 'Le Salon Privé (Nocturne Vault)',
                    subtitle: 'Exclusive 1-of-1 archive couture access',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const NocturneVaultView());
                    },
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.champagneGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.champagneGold, width: 0.8),
                      ),
                      child: const Text(
                        'VIP ONLY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.champagneGold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.radiowaves_right,
                    title: 'Digital Couture Passports',
                    subtitle: 'Aura Blockchain NFC Authenticity Certificates',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierPassportView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.sparkles,
                    title: 'Private Salon Fitting',
                    subtitle: 'Book In-Person VIP Suite (Paris, Milan, London, Tokyo)',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierSalonBookingView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.videocam_fill,
                    title: 'Live Video Salon Suite',
                    subtitle: 'Remote couture appointment with Éléonore Vance (Paris 1er)',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierConsultationSuiteView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.waveform_path,
                    title: 'Le Studio Acoustique',
                    subtitle: 'Spatial sensory runway soundscapes & haptic rhythm',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierAcousticView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.archivebox_fill,
                    title: 'L’Archive Historique (1924–2026)',
                    subtitle: 'Century retrospective, vintage sketches & Solingen shears',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierHeritageArchiveView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.book_fill,
                    title: 'L’Édition Journal & Culture',
                    subtitle: 'Curated couture literature, drop-caps & craftsmanship essays',
                    isDark: isDark,
                    onTap: () {
                      HapticService.selection();
                      Get.to(() => const AtelierJournalView());
                    },
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1),
                  _buildProfileTile(
                    icon: CupertinoIcons.person_crop_square,
                    title: 'Bespoke Measurements',
                    subtitle: 'Bust 84cm • Waist 66cm • Hips 92cm',
                    isDark: isDark,
                  ),
                  const Divider(height: 1),
                  Obx(() => _buildProfileTile(
                        icon: CupertinoIcons.globe,
                        title: 'Currency & Region',
                        subtitle: '${controller.selectedCurrencyCode.value} (${controller.currencySymbol})',
                        isDark: isDark,
                        onTap: () => AtelierConciergeSheet.show(context),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Order History Timeline
            _buildSectionHeader('RECENT ORDERS', isDark),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Column(
                children: [
                  _buildOrderTimelineTile(
                    orderId: '#ATL-894201',
                    date: 'Yesterday, 14:20',
                    itemsSummary: '1x Double-Breasted Wool Trench (S)',
                    status: 'In Workshop Transit',
                    isDelivered: false,
                    isDark: isDark,
                  ),
                  const Divider(height: 1),
                  _buildOrderTimelineTile(
                    orderId: '#ATL-781932',
                    date: 'Sep 18, 2026',
                    itemsSummary: '1x Bias-Cut Silk Slip Dress (M)',
                    status: 'Delivered to Paris',
                    isDelivered: true,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Saved Addresses
            _buildSectionHeader('SAVED ADDRESSES', isDark),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.house_fill, color: AppColors.champagneGold, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primary Residence (Default)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '14 Rue de la Paix, 1er Arrondissement, Paris, 75001',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Sign Out / Concierge
            Center(
              child: TextButton.icon(
                onPressed: () => AtelierConciergeSheet.show(context),
                icon: const Icon(CupertinoIcons.chat_bubble_2, size: 18, color: AppColors.champagneGold),
                label: const Text(
                  'Contact Atelier Concierge',
                  style: TextStyle(
                    color: AppColors.champagneGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: AppTypography.microTag(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTimelineTile({
    required String orderId,
    required String date,
    required String itemsSummary,
    required String status,
    required bool isDelivered,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        HapticService.selection();
        Get.to(() => AtelierOrderTrackingView(orderId: orderId));
      },
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDelivered
                  ? AppColors.inStockGreen.withValues(alpha: 0.12)
                  : AppColors.champagneGold.withValues(alpha: 0.15),
            ),
            child: Icon(
              isDelivered ? CupertinoIcons.check_mark : CupertinoIcons.cube_box,
              size: 18,
              color: isDelivered ? AppColors.inStockGreen : AppColors.champagneGold,
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
                      orderId,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  itemsSummary,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDelivered ? AppColors.inStockGreen : AppColors.champagneGold,
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
}

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
import '../../controllers/account_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../shared/widgets/auth_gate.dart';
import '../auth/atelier_auth_view.dart';
import '../account/atelier_address_book_view.dart';
import '../account/atelier_inbox_view.dart';
import '../account/atelier_measurements_view.dart';
import '../account/atelier_order_history_view.dart';

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
            // Editorial Header & User Info (guest invite when signed out)
            Obx(() {
              final user = AuthController.to.user.value;
              if (user == null) return _GuestWelcomeCard(isDark: isDark);
              return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.champagneGold, width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.champagneGold.withValues(alpha: 0.14),
                    child: Text(
                      user.initials,
                      style: AppTypography.sectionTitle(color: AppColors.champagneGold),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.sectionTitle(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          HapticService.light();
                          AuthGate.open(() => const AtelierClubView());
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
            );
            }),
            const SizedBox(height: 32),

            // Atelier Settings & Preferences Section
            _buildSectionHeader('Preferences', isDark),
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
                      AuthGate.open(() => const AtelierClubView(), reason: 'Sign in to see your membership');
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
                      AuthGate.open(() => const AtelierWardrobeView(), reason: 'Sign in to open your wardrobe');
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
                      AuthGate.open(() => const NocturneVaultView(), reason: 'Members only — sign in to enter');
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
                      AuthGate.open(() => const AtelierPassportView(), reason: 'Sign in to view your certificates');
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
                      AuthGate.open(() => const AtelierSalonBookingView(), reason: 'Sign in to book a fitting');
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
                      AuthGate.open(() => const AtelierConsultationSuiteView(), reason: 'Sign in to book a video session');
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
                  Obx(() => _buildProfileTile(
                        icon: CupertinoIcons.person_crop_square,
                        title: 'Bespoke Measurements',
                        subtitle: AccountController.to.measurementSummary,
                        isDark: isDark,
                        onTap: () {
                          HapticService.light();
                          AuthGate.open(() => const AtelierMeasurementsView(), reason: 'Sign in to save your measurements');
                        },
                      )),
                  const Divider(height: 1),
                  Obx(() {
                    final unread = AccountController.to.unreadCount;
                    return _buildProfileTile(
                      icon: CupertinoIcons.bell,
                      title: 'Inbox & Notifications',
                      subtitle: unread == 0 ? 'All caught up' : '$unread unread messages',
                      isDark: isDark,
                      onTap: () {
                        HapticService.light();
                        AuthGate.open(() => const AtelierInboxView(), reason: 'Sign in to read your messages');
                      },
                      trailing: unread == 0
                          ? null
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.silouPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$unread',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                              ),
                            ),
                    );
                  }),
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

            // Personal sections only make sense once signed in.
            Obx(() {
              if (!AuthController.to.isSignedIn) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            // Order History Timeline
            Row(
              children: [
                _buildSectionHeader('Recent orders', isDark),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    HapticService.light();
                    AuthGate.open(() => const AtelierOrderHistoryView(), reason: 'Sign in to see your orders');
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
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
            _buildSectionHeader('Saved addresses', isDark),
            const SizedBox(height: 10),
            Builder(builder: (_) {
              final a = AccountController.to.defaultAddress;
              final count = AccountController.to.addresses.length;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    HapticService.light();
                    AuthGate.open(() => const AtelierAddressBookView(), reason: 'Sign in to manage addresses');
                  },
                  child: Ink(
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
                                a == null ? 'No saved address' : '${a.label} (Default) • $count saved',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                a?.oneLine ?? 'Tap to add an address',
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
                ),
              );
            }),
                ],
              );
            }),
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
            Obx(() {
              if (!AuthController.to.isSignedIn) return const SizedBox.shrink();
              return Center(
                child: TextButton.icon(
                  onPressed: () => _confirmSignOut(context),
                  icon: const Icon(CupertinoIcons.square_arrow_right, size: 18, color: AppColors.saleRed),
                  label: const Text(
                    'Sign out',
                    style: TextStyle(color: AppColors.saleRed, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    HapticService.light();
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Your bag stays on this device. Sign in again any time.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok == true) AuthController.to.signOut();
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: AppTypography.editorialHeading(
        fontSize: 22,
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
        AuthGate.open(() => AtelierOrderTrackingView(orderId: orderId), reason: 'Sign in to track this order');
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


/// Shown at the top of Account for guests: a clear, friendly invitation to
/// sign in or join, matching the editorial cards below it.
class _GuestWelcomeCard extends StatelessWidget {
  const _GuestWelcomeCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMuted;

    Widget perk(IconData icon, String label) => Expanded(
          child: Column(
            children: [
              Icon(icon, size: 20, color: AppColors.champagneGold),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: muted, height: 1.3),
              ),
            ],
          ),
        );

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.signatureGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(22.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.champagneGold.withValues(alpha: 0.12),
                  ),
                  child: const Icon(CupertinoIcons.person_crop_circle, size: 28, color: AppColors.champagneGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, guest', style: AppTypography.sectionTitle(color: text)),
                      Text(
                        'Sign in or join to unlock your account',
                        style: TextStyle(fontSize: 12.5, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                perk(CupertinoIcons.cube_box, 'Track\norders'),
                perk(CupertinoIcons.heart, 'Synced\nwishlist'),
                perk(CupertinoIcons.bolt, 'Faster\ncheckout'),
                perk(CupertinoIcons.star, 'VIP\nperks'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.silouPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        HapticService.selection();
                        AuthGate.showAuth(mode: AuthMode.register);
                      },
                      child: const Text(
                        'JOIN FREE',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: text,
                        side: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight, width: 1.2),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        HapticService.selection();
                        AuthGate.showAuth();
                      },
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: text),
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
}

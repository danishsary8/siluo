import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../account/atelier_address_book_view.dart';
import '../concierge/atelier_concierge_sheet.dart';

import '../../routes/app_routes.dart';
import '../../theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12.withValues(alpha: 0.06)),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ===== Profile Header =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 👤 Profile Image Avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        "assets/images/profile.jpg", // ✅ change path if needed
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 34,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Danish",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "081669444",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Account",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _settingTile(
              title: "Address",
              icon: Icons.location_on_outlined,
              onTap: () => Get.to<void>(() => const AtelierAddressBookView()),
            ),
            _settingTile(
              title: "Wishlist",
              icon: Icons.favorite_border,
              onTap: () => Get.toNamed(AppRoutes.wishlist),
            ),
            _settingTile(
              title: "Payment",
              icon: Icons.credit_card,
              onTap: () => Get.snackbar("Payment", "Visa •••• 4242 is your default card",
                  snackPosition: SnackPosition.BOTTOM),
            ),

            const SizedBox(height: 18),

            const Text(
              "More",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _settingTile(
              title: "Orders",
              icon: Icons.shopping_bag_outlined,
              onTap: () => Get.toNamed(AppRoutes.orders),
            ),
            _settingTile(
              title: "Notifications",
              icon: Icons.notifications_none,
              onTap: () => Get.toNamed(AppRoutes.notifications),
            ),
            _settingTile(
              title: "Support",
              icon: Icons.help_outline,
              onTap: () => AtelierConciergeSheet.show(context),
            ),

            const SizedBox(height: 22),

            // ===== Sign Out Button =====
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.login);
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _settingTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black45),
      ),
    );
  }
}

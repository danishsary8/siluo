import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../modules/auth/atelier_auth_view.dart';

/// Guards pages that hold personal data (orders, addresses, inbox, sizes,
/// payments). Guests are sent to sign-in first and then on to the page they
/// asked for; signed-in shoppers go straight through.
class AuthGate {
  AuthGate._();

  /// Resolves to true once the shopper is signed in.
  static Future<bool> ensure({String? reason, AuthMode mode = AuthMode.signIn}) async {
    if (AuthController.to.isSignedIn) return true;
    final ok = await Get.to<bool>(
      () => AtelierAuthView(reason: reason, initialMode: mode),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
    return ok == true || AuthController.to.isSignedIn;
  }

  /// Opens [page], asking guests to sign in first.
  static Future<void> open(Widget Function() page, {String? reason}) async {
    if (await ensure(reason: reason)) {
      await Get.to<void>(page);
    }
  }

  /// Opens the sign-in / create-account screen directly.
  static Future<bool> showAuth({AuthMode mode = AuthMode.signIn, String? reason}) =>
      ensure(mode: mode, reason: reason);

  /// A gentle, dismissible reminder for guests, shown at most every 3 days.
  static Future<void> maybeNudge(BuildContext context) async {
    final auth = AuthController.to;
    if (!auth.shouldNudge) return;
    auth.markNudged();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _JoinSheet(),
    );
  }
}

class _JoinSheet extends StatelessWidget {
  const _JoinSheet();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMuted;

    Widget perk(IconData icon, String label) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.champagneGold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 17, color: AppColors.champagneGold),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppTypography.bodyMedium(color: text))),
            ],
          ),
        );

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(gradient: AppColors.signatureGradient, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 14),
            Text('Make SILOU yours', style: AppTypography.sectionTitle(color: text)),
            const SizedBox(height: 4),
            Text('Create a free account in under a minute.', style: AppTypography.body(color: muted)),
            const SizedBox(height: 12),
            perk(CupertinoIcons.heart, 'Keep your wishlist and bag on every visit'),
            perk(CupertinoIcons.cube_box, 'Track orders and get delivery updates'),
            perk(CupertinoIcons.bolt, 'Faster checkout with saved addresses'),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.silouPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  HapticService.selection();
                  Navigator.of(context).pop();
                  AuthGate.showAuth(mode: AuthMode.register);
                },
                child: const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    AuthGate.showAuth();
                  },
                  child: const Text('I have an account', style: TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.w700)),
                ),
                Text('•', style: TextStyle(color: muted)),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Maybe later', style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

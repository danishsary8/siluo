import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/haptic_service.dart';
import '../../modules/shell/atelier_shell_view.dart';

/// Round frosted back button used on full-screen pages.
///
/// Pops to the previous page when there is one; when the page was opened
/// with nothing beneath it (e.g. after a reload of the installed web app) it
/// goes to the shop instead, so the shopper is never stuck.
class AtelierBackButton extends StatelessWidget {
  const AtelierBackButton({super.key, this.onDark = false, this.icon = CupertinoIcons.chevron_back});

  /// Use light colours when the button sits on a photo or dark backdrop.
  final bool onDark;
  final IconData icon;

  static void goBack(BuildContext context) {
    HapticService.selection();
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      Get.offAll(() => const AtelierShellView());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = onDark || Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.surfaceLight,
        shape: CircleBorder(
          side: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.18) : AppColors.cardBorderLight,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => goBack(context),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

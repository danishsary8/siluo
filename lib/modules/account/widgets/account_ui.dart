import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/haptic_service.dart';

/// Shared building blocks for the account pages so they match the
/// editorial look of the rest of the app.
class AccountUi {
  static bool dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color canvas(BuildContext c) =>
      dark(c) ? AppColors.canvasDark : AppColors.canvasLight;
  static Color surface(BuildContext c) =>
      dark(c) ? AppColors.surfaceDark : AppColors.surfaceLight;
  static Color border(BuildContext c) =>
      dark(c) ? AppColors.cardBorderDark : AppColors.cardBorderLight;
  static Color text(BuildContext c) =>
      dark(c) ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  static Color muted(BuildContext c) =>
      dark(c) ? AppColors.textMutedDark : AppColors.textMuted;

  static PreferredSizeWidget appBar(
    BuildContext context,
    String title, {
    List<Widget> actions = const [],
  }) {
    return AppBar(
      backgroundColor: canvas(context),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        tooltip: 'Back',
        icon: Icon(CupertinoIcons.chevron_back, color: text(context)),
        onPressed: () {
          HapticService.selection();
          Get.back<void>();
        },
      ),
      title: Text(
        title,
        style: AppTypography.editorialHeading(color: text(context), fontSize: 22),
      ),
      actions: actions,
    );
  }

  static BoxDecoration card(BuildContext context, {bool highlighted = false}) {
    return BoxDecoration(
      color: surface(context),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: highlighted ? AppColors.champagneGold : border(context),
        width: highlighted ? 1.5 : 1,
      ),
    );
  }

  static Widget sectionLabel(BuildContext context, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 6),
        child: Text(label, style: AppTypography.editorialHeading(color: text(context), fontSize: 20)),
      );

  static void toast(String title, String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      borderRadius: 16,
      backgroundColor: AppColors.ctaDark,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(CupertinoIcons.check_mark_circled, color: AppColors.champagneGold),
    );
  }
}

/// Full-width primary button with a press-scale animation.
class AccountPrimaryButton extends StatefulWidget {
  const AccountPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  State<AccountPrimaryButton> createState() => _AccountPrimaryButtonState();
}

class _AccountPrimaryButtonState extends State<AccountPrimaryButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final dark = AccountUi.dark(context);
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapCancel: () => setState(() => _down = false),
      onTapUp: enabled ? (_) => setState(() => _down = false) : null,
      onTap: enabled
          ? () {
              HapticService.medium();
              widget.onPressed!();
            }
          : null,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: dark ? AppColors.signatureGradient : null,
              color: dark ? null : AppColors.ctaDark,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: Colors.white),
                  const SizedBox(width: 10),
                ],
                Text(
                  widget.label.toUpperCase(),
                  style: AppTypography.buttonLabel(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

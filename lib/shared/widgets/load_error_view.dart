import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';

/// Inline panel shown when content failed to load, with a retry button.
///
/// [message] should come from `AppFailure.message`: plain language that says
/// what went wrong and what to do.
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'Couldn\'t load this',
  });

  /// Short heading, e.g. `Couldn't load the shop`.
  final String title;

  /// Explanation and next step for the shopper.
  final String message;

  /// Called when the shopper taps "Try again".
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            size: 44,
            color: isDark ? AppColors.textMutedDark : AppColors.textLightMuted,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.editorialHeading(
              fontSize: 22,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.body(color: isDark ? AppColors.textMutedDark : AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.champagneGold : AppColors.ctaDark,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            ),
            onPressed: () {
              HapticService.light();
              onRetry();
            },
            icon: const Icon(CupertinoIcons.arrow_clockwise, size: 16),
            label: const Text('Try again', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

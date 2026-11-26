import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Placeholder shown when a network image fails to load (offline, 404, slow
/// CDN).
///
/// Use it as an `Image.network` `errorBuilder`. Flutter's default error widget
/// ignores the image's intended size and can overflow its parent by hundreds
/// of pixels, so pass the same [width]/[height] the image would have had.
/// When they are omitted the placeholder fills bounded constraints, or falls
/// back to a small square inside unbounded ones.
class ImageFallback extends StatelessWidget {
  const ImageFallback({super.key, this.width, this.height});

  /// Intended image width; `null` fills the available width when bounded.
  final double? width;

  /// Intended image height; `null` fills the available height when bounded.
  final double? height;

  /// Ready-made `errorBuilder` for images without an explicit size.
  static Widget builder(BuildContext context, Object error, StackTrace? stackTrace) =>
      const ImageFallback();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _resolve(width, constraints.maxWidth, constraints.hasBoundedWidth);
        final h = _resolve(height, constraints.maxHeight, constraints.hasBoundedHeight);
        return SizedBox(
          width: w,
          height: h,
          child: ColoredBox(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceSubtle,
            child: Center(
              child: Icon(
                CupertinoIcons.photo,
                size: (w < h ? w : h).clamp(12.0, 28.0),
                color: isDark ? AppColors.textMutedDark : AppColors.textLightMuted,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Uses a finite requested size as-is; otherwise (null or infinity) fills
  /// bounded space, or falls back to 48px when the space is unbounded.
  static double _resolve(double? requested, double max, bool bounded) {
    if (requested != null && requested.isFinite) return requested;
    return bounded ? max : 48.0;
  }
}

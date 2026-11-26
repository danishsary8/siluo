import 'package:flutter/material.dart';

/// SILOU "Electric Editorial" palette.
///
/// Token names are kept from the original design (e.g. `champagneGold` is
/// still the main accent slot) so every screen picks up the new colours
/// without code changes. Values: vivid violet accent + SILOU coral, on ink
/// indigo typography, a lavender-tinted light canvas and a midnight dark mode.
abstract class AppColors {
  // Canvas & Backgrounds (Light)
  static const Color canvasLight = Color(0xFFF7F5FF);       // Lavender Mist canvas
  static const Color surfaceLight = Color(0xFFFFFFFF);      // Pure White cards
  static const Color cardBorderLight = Color(0xFFE7E2F8);   // Soft Lilac border
  static const Color glassFillLight = Color(0xCCF7F5FF);    // 80% frosted mist
  static const Color surfaceSubtle = Color(0xFFEFEBFF);     // Lilac tint fill

  // Typography & Foreground (Light)
  static const Color textPrimaryLight = Color(0xFF16112F);  // Ink Indigo
  static const Color textSecondary = Color(0xFF3B3560);     // Deep Dusk
  static const Color textMuted = Color(0xFF6A6488);         // Lavender Slate (4.9:1 on canvas)
  static const Color textLightMuted = Color(0xFFA29DBE);    // Soft Haze

  // Accents & CTAs
  static const Color ctaDark = Color(0xFF1B1442);           // Midnight Ink CTA
  static const Color champagneGold = Color(0xFF6E4BFF);     // Electric Violet (main accent)
  static const Color champagneLight = Color(0xFFEEE9FF);    // Pale Violet wash
  static const Color saleRed = Color(0xFFE5294B);           // Raspberry Sale
  static const Color inStockGreen = Color(0xFF12A150);      // Fresh Emerald

  // Silou Signature Shopping Palette
  static const Color silouPrimary = Color(0xFFFF4D3D);      // SILOU Coral
  static const Color silouSecondary = Color(0xFF16112F);    // Ink Indigo
  static const Color silouFlash = Color(0xFFFF8A00);        // Flash Tangerine
  static const Color silouBadgeBlue = Color(0xFF2F6BFF);    // Cobalt badge
  static const Color silouYellow = Color(0xFFFFC21A);       // Star rating
  static const Color silouTagBg = Color(0xFFFFE4E1);        // Coral tag wash
  static const Color silouGreenBg = Color(0xFFDDF7E8);      // Mint shipping wash

  // Canvas & Backgrounds (Dark Mode)
  static const Color canvasDark = Color(0xFF0C0A19);        // Midnight Indigo
  static const Color surfaceDark = Color(0xFF17132C);       // Deep Plum card
  static const Color cardBorderDark = Color(0xFF2A2447);    // Violet-night border
  static const Color glassFillDark = Color(0xCC17132C);     // Dark frosted plum
  static const Color textPrimaryDark = Color(0xFFF5F3FF);   // Moonlight
  static const Color textMutedDark = Color(0xFFABA5CC);     // Lilac Grey

  /// Signature gradient (violet → coral) for hero accents.
  static const LinearGradient signatureGradient = LinearGradient(
    colors: [champagneGold, Color(0xFFB04BFF), silouPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

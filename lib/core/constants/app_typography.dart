import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Editorial Display Serifs (Cormorant Garamond)
  static TextStyle displayHero({Color color = AppColors.textPrimaryLight}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.15,
        color: color,
      );

  static TextStyle sectionTitle({Color color = AppColors.textPrimaryLight}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.2,
        color: color,
      );

  static TextStyle productTitle({Color color = AppColors.textPrimaryLight}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle brandLogo({Color color = AppColors.textPrimaryLight}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 3.5,
        color: color,
      );

  // Modern Grotesque Sans (Plus Jakarta Sans)
  static TextStyle priceTag({Color color = AppColors.textPrimaryLight}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle originalPrice({Color color = AppColors.textLightMuted}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.lineThrough,
        color: color,
      );

  static TextStyle body({Color color = AppColors.textMuted}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.textPrimaryLight}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle buttonLabel({Color color = Colors.white}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: color,
      );

  static TextStyle categoryChip({required bool isSelected, bool isDark = false}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        letterSpacing: 0.2,
        color: isSelected
            ? (isDark ? AppColors.canvasDark : Colors.white)
            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      );

  static TextStyle microTag({Color color = AppColors.textMuted}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color,
      );

  /// Editorial section heading: the magazine-style serif used for section
  /// titles in sentence case ("Official brands", "Your bag").
  static TextStyle editorialHeading({
    Color color = AppColors.textPrimaryLight,
    double fontSize = 24,
  }) =>
      GoogleFonts.cormorantGaramond(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.1,
        color: color,
      );

  /// Small supporting count / meta text beside a heading ("11 items").
  static TextStyle headingMeta({Color color = AppColors.textMuted}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      );
}

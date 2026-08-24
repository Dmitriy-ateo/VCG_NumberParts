import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.3,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );

  static TextStyle get badge => GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get buttonLarge => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.textWhite,
        letterSpacing: 0.5,
      );

  static TextStyle get numberTile => GoogleFonts.fredoka(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );
}

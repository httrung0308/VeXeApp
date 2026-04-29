import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Định nghĩa typography cho ứng dụng VeXe
/// Typography definitions using Lexend font
class AppTypography {
  AppTypography._();

  static String get _fontFamily => GoogleFonts.lexend().fontFamily!;

  // Display - Tiêu đề lớn nhất
  static TextStyle get display => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  // Headings
  static TextStyle get h1 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h2 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h3 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get h4 => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // Body Text
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get body => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // Caption & Labels
  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  static TextStyle get label => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // Button Text
  static TextStyle get buttonLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );

  static TextStyle get button => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );

  // Price Display
  static TextStyle get priceLarge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppColors.primary,
        height: 1.2,
      );

  static TextStyle get price => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: AppColors.primary,
        height: 1.2,
      );

  static TextStyle get priceSmall => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.primary,
        height: 1.2,
      );

  // Badge Text
  static TextStyle get badge => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.textOnPrimary,
        height: 1.2,
      );
}

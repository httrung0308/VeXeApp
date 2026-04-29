import 'package:flutter/material.dart';

/// Định nghĩa màu sắc cho ứng dụng VeXe
/// Color definitions for VeXe app
class AppColors {
  AppColors._();

  // Primary Colors - Thương hiệu
  static const Color primary = Color(0xFF1A237E); // Deep Navy
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color primaryDark = Color(0xFF0D1642);

  // Secondary Colors - Accent chính
  static const Color secondary = Color(0xFF2ECC71); // Mint Green
  static const Color secondaryLight = Color(0xFF58D68D);
  static const Color secondaryDark = Color(0xFF27AE60);

  // Accent Colors - Highlight, warnings
  static const Color accent = Color(0xFFF59E0B); // Warm Amber
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Slate - Main bg
  static const Color surface = Color(0xFFFFFFFF); // Cards
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Semantic Colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Seat Colors
  static const Color seatAvailable = Color(0xFFFFFFFF);
  static const Color seatAvailableBorder = Color(0xFF2ECC71);
  static const Color seatSelected = Color(0xFF2ECC71);
  static const Color seatOccupied = Color(0xFFE2E8F0);
  static const Color seatOccupiedIcon = Color(0xFF94A3B8);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x001A237E), Color(0xCC1A237E)],
  );
}

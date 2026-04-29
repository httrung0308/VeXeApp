import 'package:flutter/material.dart';

/// Định nghĩa spacing & dimensions cho ứng dụng VeXe
/// Spacing and dimension constants
class AppSpacing {
  AppSpacing._();

  // Base unit: 4px
  static const double unit = 4.0;

  // Spacing scale
  static const double xxs = 4.0;   // 1 unit
  static const double xs = 8.0;    // 2 units
  static const double sm = 12.0;   // 3 units
  static const double md = 16.0;   // 4 units
  static const double lg = 24.0;   // 6 units
  static const double xl = 32.0;   // 8 units
  static const double xxl = 48.0;  // 12 units
  static const double xxxl = 64.0; // 16 units

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(md);

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);

  // Input padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const double inputHeight = 56.0;

  // Button dimensions
  static const double buttonHeightLarge = 56.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 40.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 28.0;
  static const double iconSizeXLarge = 32.0;

  // Touch targets
  static const double minTouchTarget = 48.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 24.0;
  static const double radiusXL = 32.0;

  // Border radius objects
  static final BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);

  // Bottom safe area
  static const double bottomSafeArea = 34.0;
  static const double bottomNavHeight = 80.0;

  // App bar
  static const double appBarHeight = 56.0;

  // Card elevation - soft shadow
  static List<BoxShadow> get shadowLevel1 => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowLevel2 => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLevel3 => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 40,
          offset: const Offset(0, 20),
        ),
      ];
}

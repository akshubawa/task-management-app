import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF6B35);

  static const Color primaryLight = Color(0xFFFF8C42);

  static const Color primaryDark = Color(0xFFE85A24);

  static const Color background = Color(0xFF1A1A1A);

  static const Color backgroundSecondary = Color(0xFF252525);

  static const Color surface = Color(0xFF2A2A2A);

  static const Color surfaceElevated = Color(0xFF303030);

  static const Color inputBackground = Color(0xFF2D2D2D);

  static const Color textPrimary = Color(0xFFFFFFFF);

  static const Color textSecondary = Color(0xFFB0B0B0);

  static const Color textTertiary = Color(0xFF808080);

  static const Color textHint = Color(0xFF666666);

  static const Color textDisabled = Color(0xFF4D4D4D);

  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF66BB6A);
  static const Color successDark = Color(0xFF388E3C);

  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);

  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color info = Color(0xFF29B6F6);
  static const Color infoLight = Color(0xFF4FC3F7);
  static const Color infoDark = Color(0xFF0288D1);

  static const Color activeIndicator = Color(0xFF4CAF50);

  static const Color inactiveIndicator = Color(0xFF757575);

  static const Color border = Color(0xFF3D3D3D);

  static const Color borderLight = Color(0xFF4D4D4D);

  static const Color borderFocus = Color(0xFFFF6B35);

  static const Color borderError = Color(0xFFE53935);

  static const Color iconPrimary = Color(0xFFFFFFFF);

  static const Color iconSecondary = Color(0xFFB0B0B0);

  static const Color iconTertiary = Color(0xFF808080);

  static const Color iconActive = Color(0xFFFF6B35);

  static const Color tabIndicator = Color(0xFFFF6B35);

  static const Color tabInactive = Color(0xFF4D4D4D);

  static const Color divider = Color(0xFF3D3D3D);

  static const Color shadow = Color(0x40000000);

  static const Color overlay = Color(0x80000000);

  static const Color buttonPrimary = Color(0xFFFF6B35);

  static const Color buttonPrimaryText = Color(0xFFFFFFFF);

  static const Color buttonSecondary = Color(0xFF2A2A2A);

  static const Color buttonSecondaryText = Color(0xFFFFFFFF);

  static const Color buttonDisabled = Color(0xFF3D3D3D);

  static const Color buttonDisabledText = Color(0xFF666666);

  static const Color buttonDanger = Color(0xFF9E2A2A);
  static const Color buttonDangerText = Color(0xFFE53935);

  static const Color badgeActive = Color(0xFF4CAF50);

  static const Color badgeExpired = Color(0xFFE53935);

  static const Color badgePending = Color(0xFFFFA726);

  static const Color badgeNew = Color(0xFF29B6F6);

  static const Color amountPaid = Color(0xFF4CAF50);

  static const Color amountUnpaid = Color(0xFFE53935);

  static const Color amountPending = Color(0xFFFFA726);

  static const Color planBronze = Color(0xFFCD7F32);

  static const Color planSilver = Color(0xFFC0C0C0);

  static const Color planGold = Color(0xFFFFD700);

  static const Color planPlatinum = Color(0xFFE5E4E2);

  static const Color chartPrimary = Color(0xFFFF6B35);

  static const Color chartSecondary = Color(0xFF4CAF50);

  static const Color chartTertiary = Color(0xFF29B6F6);

  static const Color chartGrid = Color(0xFF3D3D3D);

  static const Color attendanceHigh = Color(0xFF4CAF50);

  static const Color attendanceMedium = Color(0xFFFFA726);

  static const Color attendanceLow = Color(0xFFE53935);

  static const Color transparent = Colors.transparent;

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF252525)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2A2A2A), Color(0xFF303030)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);

  static Color whiteWithOpacity(double opacity) =>
      white.withValues(alpha: opacity);

  static Color blackWithOpacity(double opacity) =>
      black.withValues(alpha: opacity);

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return success;
      case 'expired':
      case 'inactive':
        return error;
      case 'pending':
        return warning;
      default:
        return textSecondary;
    }
  }

  static Color getPlanColor(String planName) {
    if (planName.toLowerCase().contains('gold')) {
      return planGold;
    } else if (planName.toLowerCase().contains('silver')) {
      return planSilver;
    } else if (planName.toLowerCase().contains('bronze') ||
        planName.toLowerCase().contains('basic')) {
      return planBronze;
    } else if (planName.toLowerCase().contains('platinum')) {
      return planPlatinum;
    }
    return primary;
  }

  static Color getAttendanceColor(int percentage) {
    if (percentage >= 70) {
      return attendanceHigh;
    } else if (percentage >= 40) {
      return attendanceMedium;
    } else {
      return attendanceLow;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String primaryFontFamily = 'Inter';
  static const String secondaryFontFamily = 'Inter';

  static TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle h1 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle h5 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle h6 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLargeMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle bodyMediumMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmallMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  static TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,

    height: 1.2,
    color: AppColors.buttonPrimary,
  );

  static TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
    color: AppColors.buttonPrimaryText,
  );

  static TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.buttonPrimaryText,
  );

  static TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  static TextStyle captionMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle overline = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static TextStyle inputText = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle inputHint = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.textHint,
  );

  static TextStyle inputLabel = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle link = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.primary,
    decoration: TextDecoration.none,
  );

  static TextStyle linkSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.primary,
    decoration: TextDecoration.none,
  );

  static TextStyle priceLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.primary,
  );

  static TextStyle priceMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.primary,
  );

  static TextStyle priceSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.primary,
  );

  static TextStyle badge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle tabActive = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.primary,
  );

  static TextStyle tabInactive = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.2,
    color: AppColors.textSecondary,
  );

  static TextStyle error = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.error,
  );

  static TextStyle success = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.success,
  );

  static TextStyle attendancePercentage = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static TextStyle statNumberLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle statNumberMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle statLabel = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size.sp);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withValues(alpha: opacity));
  }

  static TextStyle withUnderline(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.underline);
  }

  static TextStyle withLineThrough(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.lineThrough);
  }

  static TextStyle withItalic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }

  static TextStyle getStyle(String styleName) {
    switch (styleName.toLowerCase()) {
      case 'h1':
        return h1;
      case 'h2':
        return h2;
      case 'h3':
        return h3;
      case 'h4':
        return h4;
      case 'h5':
        return h5;
      case 'h6':
        return h6;
      case 'bodylarge':
        return bodyLarge;
      case 'bodymedium':
        return bodyMedium;
      case 'bodysmall':
        return bodySmall;
      case 'buttonlarge':
        return buttonLarge;
      case 'buttonmedium':
        return buttonMedium;
      case 'buttonsmall':
        return buttonSmall;
      case 'caption':
        return caption;
      case 'overline':
        return overline;
      default:
        return bodyMedium;
    }
  }
}

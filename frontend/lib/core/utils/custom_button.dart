import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

enum ButtonSizeType { small, medium, large, extraLarge }

enum ButtonShapeType {
  rounded, // Fully rounded corners
  semiRounded, // Medium rounded corners
  rectangular, // Sharp corners
  pill, // Pill shaped (very rounded)
}

enum ButtonType {
  filled, // Solid background
  outlined, // Border only
  text, // No background or border
  elevated, // Material elevated button
}

class CustomButton extends StatelessWidget {
  // Required
  final VoidCallback? onPressed;

  // Optional - Content
  final String? text;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? child; // For complete custom content

  // Optional - Styling
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  // Optional - Size & Shape
  final ButtonSizeType sizeType;
  final ButtonShapeType shapeType;
  final double? customHeight;
  final double? customWidth;
  final EdgeInsetsGeometry? padding;

  // Optional - Effects
  final double elevation;
  final bool hasShadow;
  final bool hasBorder;
  final double? borderWidth;
  final ButtonType buttonType;

  // Optional - Advanced
  final double? borderRadius;
  final Gradient? gradient;
  final bool isLoading;
  final Color? loadingColor;
  final double? iconSpacing;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
    this.sizeType = ButtonSizeType.medium,
    this.shapeType = ButtonShapeType.semiRounded,
    this.customHeight,
    this.customWidth,
    this.padding,
    this.elevation = 0,
    this.hasShadow = false,
    this.hasBorder = false,
    this.borderWidth,
    this.buttonType = ButtonType.filled,
    this.borderRadius,
    this.gradient,
    this.isLoading = false,
    this.loadingColor,
    this.iconSpacing,
  });

  @override
  Widget build(BuildContext context) {
    // Get button dimensions based on size type
    final dimensions = _getButtonDimensions();
    final height = customHeight ?? dimensions['height']!;
    final width = customWidth ?? dimensions['width'];

    // Get border radius based on shape type
    final calculatedBorderRadius = borderRadius ?? _getBorderRadius(height);

    // Get colors based on button type
    final colors = _getButtonColors();

    // Get icon spacing - responsive
    final calculatedIconSpacing = iconSpacing ?? 8.0.w;

    // Build button content
    final buttonContent = _buildButtonContent(
      colors['textColor']!,
      dimensions['fontSize']!,
      calculatedIconSpacing,
    );

    // Apply elevation and shadow
    final decoration = _buildDecoration(
      colors['backgroundColor'],
      colors['borderColor'],
      calculatedBorderRadius,
    );

    return Container(
      // height: height,
      width: width,
      decoration: hasShadow
          ? _buildShadowDecoration(calculatedBorderRadius)
          : null,
      child: Material(
        color: Colors.transparent,
        elevation: elevation,
        borderRadius: BorderRadius.circular(calculatedBorderRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(calculatedBorderRadius),
          child: Container(
            decoration: decoration,
            padding: padding ?? _getDefaultPadding(),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: dimensions['fontSize']! * 1.2,
                      width: dimensions['fontSize']! * 1.2,
                      child: CircularProgressIndicator(
                        strokeWidth: AppDimensions.progressIndicatorStrokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          loadingColor ?? colors['textColor']!,
                        ),
                      ),
                    )
                  : buttonContent,
            ),
          ),
        ),
      ),
    );
  }

  // Get button dimensions based on size type using AppDimensions
  Map<String, double?> _getButtonDimensions() {
    switch (sizeType) {
      case ButtonSizeType.small:
        return {
          'height': AppDimensions.buttonHeightSmall,
          'width': null,
          'fontSize': AppTypography.buttonSmall.fontSize ?? 12.0.sp,
        };
      case ButtonSizeType.medium:
        return {
          'height': AppDimensions.buttonHeightMedium,
          'width': null,
          'fontSize': AppTypography.buttonMedium.fontSize ?? 14.0.sp,
        };
      case ButtonSizeType.large:
        return {
          'height': AppDimensions.buttonHeightLarge,
          'width': null,
          'fontSize': AppTypography.buttonLarge.fontSize ?? 16.0.sp,
        };
      case ButtonSizeType.extraLarge:
        return {
          'height': AppDimensions.buttonHeightExtraLarge,
          'width': null,
          'fontSize': AppTypography.buttonLarge.fontSize ?? 16.0.sp,
        };
    }
  }

  // Get border radius based on shape type using AppDimensions
  double _getBorderRadius(double height) {
    switch (shapeType) {
      case ButtonShapeType.rounded:
        return height / 2; // Fully rounded
      case ButtonShapeType.semiRounded:
        return AppDimensions.radiusM; // Default from design system (12.r)
      case ButtonShapeType.rectangular:
        return AppDimensions.radiusNone; // 0
      case ButtonShapeType.pill:
        return AppDimensions.radiusCircular; // 999.r
    }
  }

  // Get button colors based on type using AppColors
  Map<String, Color?> _getButtonColors() {
    Color? bgColor;
    Color? txtColor;
    Color? brdColor;

    switch (buttonType) {
      case ButtonType.filled:
        bgColor = backgroundColor ?? AppColors.buttonPrimary;
        txtColor = textColor ?? AppColors.buttonPrimaryText;
        brdColor = hasBorder ? (borderColor ?? AppColors.borderFocus) : null;
        break;
      case ButtonType.outlined:
        bgColor = backgroundColor ?? Colors.transparent;
        txtColor = textColor ?? AppColors.primary;
        brdColor = borderColor ?? AppColors.primary;
        break;
      case ButtonType.text:
        bgColor = Colors.transparent;
        txtColor = textColor ?? AppColors.primary;
        brdColor = null;
        break;
      case ButtonType.elevated:
        bgColor = backgroundColor ?? AppColors.buttonPrimary;
        txtColor = textColor ?? AppColors.buttonPrimaryText;
        brdColor = hasBorder ? (borderColor ?? AppColors.borderFocus) : null;
        break;
    }

    return {
      'backgroundColor': bgColor,
      'textColor': txtColor,
      'borderColor': brdColor,
    };
  }

  // Build button decoration
  BoxDecoration _buildDecoration(
    Color? bgColor,
    Color? brdColor,
    double radius,
  ) {
    return BoxDecoration(
      color: gradient == null ? bgColor : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border:
          (hasBorder || buttonType == ButtonType.outlined) && brdColor != null
          ? Border.all(
              color: brdColor,
              width: borderWidth ?? AppDimensions.borderWidthMedium,
            )
          : null,
    );
  }

  // Build shadow decoration using AppColors
  BoxDecoration _buildShadowDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: (backgroundColor ?? AppColors.primary).withValues(alpha: 0.3),
          blurRadius: 12.r, // Responsive blur radius
          offset: Offset(0, 4.h), // Responsive offset
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Build button content with text and icons
  Widget _buildButtonContent(
    Color txtColor,
    double defaultFontSize,
    double spacing,
  ) {
    if (child != null) {
      return child!;
    }

    final List<Widget> rowChildren = [];

    if (prefixIcon != null) {
      rowChildren.add(prefixIcon!);
      rowChildren.add(SizedBox(width: spacing)); // Responsive spacing
    }

    if (text != null) {
      rowChildren.add(
        Flexible(
          child: Text(
            text!,
            style: TextStyle(
              color: txtColor,
              fontSize: fontSize ?? defaultFontSize,
              fontWeight: fontWeight ?? FontWeight.w600,
              fontFamily: AppTypography.primaryFontFamily,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (suffixIcon != null) {
      rowChildren.add(SizedBox(width: spacing)); // Responsive spacing
      rowChildren.add(suffixIcon!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowChildren,
    );
  }

  // Get default padding based on size using AppDimensions
  EdgeInsetsGeometry _getDefaultPadding() {
    switch (sizeType) {
      case ButtonSizeType.small:
        return AppDimensions.buttonPaddingSmall;
      case ButtonSizeType.medium:
        return AppDimensions.buttonPaddingMedium;
      case ButtonSizeType.large:
      case ButtonSizeType.extraLarge:
        return AppDimensions.buttonPaddingLarge;
    }
  }
}

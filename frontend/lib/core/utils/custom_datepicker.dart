import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:intl/intl.dart';

enum DatePickerSize { small, medium, large }

class CustomDatePicker extends StatefulWidget {
  // Required
  final ValueChanged<DateTime?>? onDateSelected;

  // Optional - Labels
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  // Optional - Initial & Range
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  // Optional - Format
  final String dateFormat; // e.g., 'dd/MM/yyyy', 'MMM dd, yyyy'

  // Optional - Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // Optional - Styling
  final DatePickerSize size;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? contentPadding;

  // Optional - Behavior
  final bool enabled;

  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd/MM/yyyy',
    this.prefixIcon,
    this.suffixIcon,
    this.size = DatePickerSize.medium,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.hintColor,
    this.borderRadius,
    this.borderWidth,
    this.contentPadding,
    this.enabled = true,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
        ],

        // Date Picker Field
        GestureDetector(
          onTap: widget.enabled ? _showDatePickerDialog : null,
          child: Container(
            // height: _getHeight(),
            padding: _getContentPadding(),
            decoration: _buildDecoration(),
            child: Row(
              children: [
                // Prefix Icon
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  SizedBox(width: AppDimensions.spacingM),
                ],

                // Selected Date or Hint
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    style: _getTextStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Suffix Icon (Calendar)
                SizedBox(width: AppDimensions.spacingS),
                widget.suffixIcon ??
                    Icon(
                      Icons.calendar_today,
                      color: widget.enabled
                          ? AppColors.iconActive
                          : AppColors.inactiveIndicator,
                      size: AppDimensions.iconM,
                    ),
              ],
            ),
          ),
        ),

        // Helper Text
        if (widget.helperText != null && widget.errorText == null) ...[
          SizedBox(height: AppDimensions.spacingXs),
          Text(
            widget.helperText!,
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],

        // Error Text
        if (widget.errorText != null) ...[
          SizedBox(height: AppDimensions.spacingXs),
          Text(widget.errorText!, style: AppTypography.error),
        ],
      ],
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case DatePickerSize.small:
        return AppDimensions.buttonHeightSmall;
      case DatePickerSize.medium:
        return AppDimensions.inputHeightMedium;
      case DatePickerSize.large:
        return AppDimensions.inputHeightLarge;
    }
  }

  EdgeInsets _getContentPadding() {
    if (widget.contentPadding != null)
      return widget.contentPadding as EdgeInsets;

    switch (widget.size) {
      case DatePickerSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
      case DatePickerSize.medium:
        return AppDimensions.inputPadding as EdgeInsets;
      case DatePickerSize.large:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h);
    }
  }

  String _getDisplayText() {
    if (_selectedDate != null) {
      return DateFormat(widget.dateFormat).format(_selectedDate!);
    }
    return widget.hintText ?? 'Select date';
  }

  TextStyle _getTextStyle() {
    TextStyle baseStyle;
    switch (widget.size) {
      case DatePickerSize.small:
        baseStyle = AppTypography.bodySmall;
        break;
      case DatePickerSize.medium:
        baseStyle = AppTypography.inputText;
        break;
      case DatePickerSize.large:
        baseStyle = AppTypography.bodyLarge;
        break;
    }

    if (_selectedDate == null) {
      return baseStyle.copyWith(color: widget.hintColor ?? AppColors.textHint);
    }

    return baseStyle.copyWith(
      color: widget.enabled
          ? (widget.textColor ?? AppColors.textPrimary)
          : AppColors.textDisabled,
    );
  }

  BoxDecoration _buildDecoration() {
    final radius = widget.borderRadius ?? AppDimensions.radiusM;
    final borderWidth = widget.borderWidth ?? AppDimensions.borderWidthThin;

    Color fillColor = widget.fillColor ?? AppColors.inputBackground;
    Color borderColor = widget.borderColor ?? Colors.transparent;

    if (!widget.enabled) {
      fillColor = AppColors.surface;
      borderColor = AppColors.border;
    } else if (_isFocused) {
      borderColor = widget.focusedBorderColor ?? AppColors.primary;
    } else if (widget.errorText != null) {
      borderColor = AppColors.error;
    }

    return BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }

  Future<void> _showDatePickerDialog() async {
    setState(() => _isFocused = true);

    final DateTime firstDate = widget.firstDate ?? DateTime(1900);
    final DateTime lastDate = widget.lastDate ?? DateTime.now();
    final DateTime initialDate =
        _selectedDate ??
        (DateTime.now().isAfter(lastDate) ? lastDate : DateTime.now());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surface,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() => _isFocused = false);

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDateSelected?.call(pickedDate);
    }
  }
}

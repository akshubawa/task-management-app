import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

enum InputFieldType {
  text,
  email,
  password,
  phone,
  number,
  multiline,
  search,
  date,
  time,
}

enum InputFieldSize { small, medium, large }

class CustomTextField extends StatefulWidget {
  // Required
  final TextEditingController? controller;

  // Optional - Content
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? initialValue;

  // Optional - Icons & Prefix/Suffix
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final String? prefixText;
  final String? suffixText;

  // Optional - Input Configuration
  final InputFieldType fieldType;
  final InputFieldSize fieldSize;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;

  // Optional - Validation
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool obscureText;

  // Optional - Styling
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? labelColor;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? contentPadding;

  // Optional - Behavior
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool showCursor;

  // Optional - Password specific
  final bool showPasswordToggle;

  // Optional - Character counter
  final bool showCounter;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.fieldType = InputFieldType.text,
    this.fieldSize = InputFieldSize.medium,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.obscureText = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.borderRadius,
    this.borderWidth,
    this.contentPadding,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.autofocus = false,
    this.showCursor = true,
    this.showPasswordToggle = true,
    this.showCounter = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText =
        widget.obscureText || widget.fieldType == InputFieldType.password;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (if provided and not using floating label)
        if (widget.labelText != null && !_shouldFloatLabel()) ...[
          Text(
            widget.labelText!,
            style: AppTypography.labelLarge.copyWith(
              color: widget.labelColor ?? AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
        ],

        // Text Field
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          showCursor: widget.showCursor,
          keyboardType: _getKeyboardType(),
          textInputAction:
              widget.textInputAction ?? _getDefaultTextInputAction(),
          textCapitalization: widget.textCapitalization,
          inputFormatters: _getInputFormatters(),
          maxLength: widget.maxLength,
          maxLines: _getMaxLines(),
          minLines: widget.minLines,
          validator: widget.validator,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          style: _getTextStyle(),
          decoration: _buildInputDecoration(),
          buildCounter: widget.showCounter
              ? null
              : (_, {required currentLength, required isFocused, maxLength}) =>
                    null,
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
      ],
    );
  }

  // Get keyboard type based on field type
  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) return widget.keyboardType!;

    switch (widget.fieldType) {
      case InputFieldType.email:
        return TextInputType.emailAddress;
      case InputFieldType.phone:
        return TextInputType.phone;
      case InputFieldType.number:
        return TextInputType.number;
      case InputFieldType.multiline:
        return TextInputType.multiline;
      case InputFieldType.text:
      case InputFieldType.password:
      case InputFieldType.search:
      case InputFieldType.date:
      case InputFieldType.time:
      default:
        return TextInputType.text;
    }
  }

  // Get default text input action
  TextInputAction _getDefaultTextInputAction() {
    if (widget.fieldType == InputFieldType.multiline) {
      return TextInputAction.newline;
    }
    return TextInputAction.done;
  }

  // Get max lines based on field type
  int? _getMaxLines() {
    if (widget.maxLines != null) return widget.maxLines;

    switch (widget.fieldType) {
      case InputFieldType.multiline:
        return 5;
      case InputFieldType.password:
        return 1;
      default:
        return widget.maxLines ?? 1;
    }
  }

  // Get input formatters
  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.inputFormatters != null) return widget.inputFormatters;

    switch (widget.fieldType) {
      case InputFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case InputFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  // Check if label should float
  bool _shouldFloatLabel() {
    return widget.fieldType != InputFieldType.multiline;
  }

  // Get text style based on size
  TextStyle _getTextStyle() {
    TextStyle baseStyle;

    switch (widget.fieldSize) {
      case InputFieldSize.small:
        baseStyle = AppTypography.bodySmall;
        break;
      case InputFieldSize.medium:
        baseStyle = AppTypography.inputText;
        break;
      case InputFieldSize.large:
        baseStyle = AppTypography.bodyLarge;
        break;
    }

    return baseStyle.copyWith(
      color: widget.enabled
          ? (widget.textColor ?? AppColors.textPrimary)
          : AppColors.textDisabled,
    );
  }

  // Get content padding based on size
  EdgeInsets _getContentPadding() {
    if (widget.contentPadding != null)
      return widget.contentPadding as EdgeInsets;

    switch (widget.fieldSize) {
      case InputFieldSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
      case InputFieldSize.medium:
        return AppDimensions.inputPadding as EdgeInsets;
      case InputFieldSize.large:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h);
    }
  }

  // Build input decoration
  InputDecoration _buildInputDecoration() {
    final radius = widget.borderRadius ?? AppDimensions.radiusM;
    final borderWidth = widget.borderWidth ?? AppDimensions.borderWidthThin;

    return InputDecoration(
      labelText: _shouldFloatLabel() ? widget.labelText : null,
      labelStyle: AppTypography.inputLabel.copyWith(
        color: widget.labelColor ?? AppColors.textSecondary,
      ),
      floatingLabelStyle: AppTypography.labelMedium.copyWith(
        color: _isFocused
            ? (widget.focusedBorderColor ?? AppColors.primary)
            : (widget.labelColor ?? AppColors.textSecondary),
      ),
      hintText: widget.hintText,
      hintStyle: AppTypography.inputHint.copyWith(
        color: widget.hintColor ?? AppColors.textHint,
      ),
      helperText: widget.helperText,
      helperStyle: AppTypography.caption.copyWith(
        color: AppColors.textTertiary,
      ),
      errorText: widget.errorText,
      errorStyle: AppTypography.error,
      errorMaxLines: 2,

      // Prefix & Suffix
      prefixIcon: _buildPrefixIcon(),
      suffixIcon: _buildSuffixIcon(),
      prefix: widget.prefix,
      suffix: widget.suffix,
      prefixText: widget.prefixText,
      suffixText: widget.suffixText,
      prefixStyle: AppTypography.inputText,
      suffixStyle: AppTypography.inputText,
      prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
      suffixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),

      // Styling
      filled: true,
      fillColor: widget.enabled
          ? (widget.fillColor ?? AppColors.inputBackground)
          : AppColors.surface,
      contentPadding: _getContentPadding(),

      // Borders
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: widget.borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: widget.borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: widget.focusedBorderColor ?? AppColors.primary,
          width: AppDimensions.borderWidthMedium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: widget.errorBorderColor ?? AppColors.error,
          width: borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: widget.errorBorderColor ?? AppColors.error,
          width: AppDimensions.borderWidthMedium,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: AppColors.border, width: borderWidth),
      ),
    );
  }

  // Build prefix icon
  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;

    switch (widget.fieldType) {
      case InputFieldType.email:
        return Icon(
          Icons.email_outlined,
          color: _isFocused ? AppColors.primary : AppColors.iconSecondary,
          size: AppDimensions.iconM,
        );
      case InputFieldType.password:
        return Icon(
          Icons.lock_outline,
          color: _isFocused ? AppColors.primary : AppColors.iconSecondary,
          size: AppDimensions.iconM,
        );
      case InputFieldType.phone:
        return Icon(
          Icons.phone_outlined,
          color: _isFocused ? AppColors.primary : AppColors.iconSecondary,
          size: AppDimensions.iconM,
        );
      case InputFieldType.search:
        return Icon(
          Icons.search,
          color: _isFocused ? AppColors.primary : AppColors.iconSecondary,
          size: AppDimensions.iconM,
        );
      case InputFieldType.date:
        return Icon(
          Icons.calendar_today_outlined,
          color: _isFocused ? AppColors.primary : AppColors.iconSecondary,
          size: AppDimensions.iconM,
        );
      case InputFieldType.time:
        return Icon(
          Icons.access_time_outlined,
          color: _isFocused ? AppColors.primary : AppColors.iconSecondary,
          size: AppDimensions.iconM,
        );
      default:
        return null;
    }
  }

  // Build suffix icon
  Widget? _buildSuffixIcon() {
    // Password toggle
    if (widget.fieldType == InputFieldType.password &&
        widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.iconSecondary,
          size: AppDimensions.iconM,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return widget.suffixIcon;
  }
}

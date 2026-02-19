import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

enum DropdownSize { small, medium, large }

enum DropdownStyle {
  filled, // Filled background (default)
  outlined, // Border only
  underlined, // Bottom border only
}

class DropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;
  final Widget? trailing;
  final bool enabled;

  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.trailing,
    this.enabled = true,
  });
}

class CustomDropdown<T> extends StatefulWidget {
  // Required
  final List<DropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  // Optional - Labels
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  // Optional - Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // Optional - Styling
  final DropdownSize size;
  final DropdownStyle style;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? contentPadding;

  // Optional - Behavior
  final bool enabled;
  final bool searchable;
  final String? searchHintText;
  final double? maxHeight;
  final bool showCheckmark;

  // Optional - Dropdown Menu Styling
  final Color? dropdownColor;
  final double? dropdownBorderRadius;
  final double? dropdownElevation;
  final EdgeInsetsGeometry? dropdownPadding;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.size = DropdownSize.medium,
    this.style = DropdownStyle.filled,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderRadius,
    this.borderWidth,
    this.contentPadding,
    this.enabled = true,
    this.searchable = false,
    this.searchHintText,
    this.maxHeight,
    this.showCheckmark = true,
    this.dropdownColor,
    this.dropdownBorderRadius,
    this.dropdownElevation,
    this.dropdownPadding,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppDimensions.durationNormal,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
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

        // Dropdown Field
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: widget.enabled ? _toggleDropdown : null,
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

                  // Selected Value or Hint
                  Expanded(
                    child: Text(
                      _getDisplayText(),
                      style: _getTextStyle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Suffix Icon (Arrow)
                  SizedBox(width: AppDimensions.spacingS),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: AppDimensions.durationNormal,
                    child:
                        widget.suffixIcon ??
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: widget.enabled
                              ? (widget.iconColor ?? AppColors.iconSecondary)
                              : AppColors.iconTertiary,
                          size: AppDimensions.iconL,
                        ),
                  ),
                ],
              ),
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
      case DropdownSize.small:
        return AppDimensions.buttonHeightSmall;
      case DropdownSize.medium:
        return AppDimensions.inputHeightMedium;
      case DropdownSize.large:
        return AppDimensions.inputHeightLarge;
    }
  }

  EdgeInsets _getContentPadding() {
    if (widget.contentPadding != null)
      return widget.contentPadding as EdgeInsets;

    switch (widget.size) {
      case DropdownSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
      case DropdownSize.medium:
        return AppDimensions.inputPadding as EdgeInsets;
      case DropdownSize.large:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h);
    }
  }

  String _getDisplayText() {
    if (widget.value != null) {
      final item = widget.items.firstWhere(
        (item) => item.value == widget.value,
      );
      return item.label;
    }
    return widget.hintText ?? 'Select an option';
  }

  TextStyle _getTextStyle() {
    TextStyle baseStyle;
    switch (widget.size) {
      case DropdownSize.small:
        baseStyle = AppTypography.bodySmall;
        break;
      case DropdownSize.medium:
        baseStyle = AppTypography.inputText;
        break;
      case DropdownSize.large:
        baseStyle = AppTypography.bodyLarge;
        break;
    }

    if (widget.value == null) {
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
    } else if (_isOpen) {
      borderColor = widget.focusedBorderColor ?? AppColors.primary;
    } else if (widget.errorText != null) {
      borderColor = AppColors.error;
    }

    switch (widget.style) {
      case DropdownStyle.filled:
        return BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: borderWidth),
        );
      case DropdownStyle.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: _isOpen
                ? (widget.focusedBorderColor ?? AppColors.primary)
                : (borderColor != Colors.transparent
                      ? borderColor
                      : AppColors.border),
            width: _isOpen ? AppDimensions.borderWidthMedium : borderWidth,
          ),
        );
      case DropdownStyle.underlined:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: _isOpen
                  ? (widget.focusedBorderColor ?? AppColors.primary)
                  : (borderColor != Colors.transparent
                        ? borderColor
                        : AppColors.border),
              width: _isOpen ? AppDimensions.borderWidthMedium : borderWidth,
            ),
          ),
        );
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _isOpen = true;
    _focusNode.requestFocus();
    _searchQuery = '';
    _searchController.clear();
    _animationController.forward();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _closeDropdown() {
    _isOpen = false;
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
    setState(() {});
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final maxHeight = widget.maxHeight ?? 300.h;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Positioned dropdown menu
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4.h,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4.h),
                child: Material(
                  elevation:
                      widget.dropdownElevation ?? AppDimensions.elevationMedium,
                  borderRadius: BorderRadius.circular(
                    widget.dropdownBorderRadius ?? AppDimensions.radiusM,
                  ),
                  color: widget.dropdownColor ?? AppColors.surface,
                  child: FadeTransition(
                    opacity: _expandAnimation,
                    child: SizeTransition(
                      sizeFactor: _expandAnimation,
                      axisAlignment: -1.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: _buildDropdownContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownContent() {
    final filteredItems = widget.searchable
        ? widget.items.where((item) {
            return item.label.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }).toList()
        : widget.items;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Bar
        if (widget.searchable) ...[
          Padding(
            padding:
                widget.dropdownPadding ??
                EdgeInsets.all(AppDimensions.spacingM),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.searchHintText ?? 'Search...',
                hintStyle: AppTypography.inputHint,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.iconSecondary,
                  size: AppDimensions.iconM,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.iconSecondary,
                          size: AppDimensions.iconS,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                isDense: true,
              ),
              style: AppTypography.bodySmall,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Divider(height: 1.h, thickness: 1.h, color: AppColors.divider),
        ],

        // Items List
        Flexible(
          child: filteredItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  shrinkWrap: true,
                  padding:
                      widget.dropdownPadding ??
                      EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return _buildDropdownItem(filteredItems[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDropdownItem(DropdownItem<T> item) {
    final isSelected = item.value == widget.value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.enabled
            ? () {
                widget.onChanged?.call(item.value);
                _closeDropdown();
              }
            : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              // Item Icon
              if (item.icon != null) ...[
                item.icon!,
                SizedBox(width: AppDimensions.spacingM),
              ],

              // Item Label
              Expanded(
                child: Text(
                  item.label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: item.enabled
                        ? (isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary)
                        : AppColors.textDisabled,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Trailing Widget or Checkmark
              if (item.trailing != null)
                item.trailing!
              else if (widget.showCheckmark && isSelected)
                Icon(
                  Icons.check_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.iconM,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacing2Xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: AppColors.iconTertiary,
            size: AppDimensions.icon3Xl,
          ),
          SizedBox(height: AppDimensions.spacingM),
          Text(
            'No results found',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingXs),
          Text(
            'Try adjusting your search',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

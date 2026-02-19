import 'package:flutter/material.dart';
import 'package:task_management/core/utils/device_utils.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// Left side
  final bool showBackButton;
  final String? avatarPath;
  final VoidCallback? onBack;
  final VoidCallback? onAvatarTap;

  /// Right side
  final bool showNotification;
  final VoidCallback? onNotificationTap;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.avatarPath,
    this.onBack,
    this.onAvatarTap,
    this.showNotification = false,
    this.onNotificationTap,
    this.actions,
  });
  bool _isTablet() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    return size.shortestSide >= 600;
  }

  double get _appBarHeight => _isTablet() ? 76 : 56;

  @override
  Size get preferredSize => Size.fromHeight(_appBarHeight);

  double _getHeight(BuildContext context) {
    final tablet = isTablet(context);
    return tablet ? 66 : 56;
  }

  @override
  Widget build(BuildContext context) {
    final height = _getHeight(context);
    return AppBar(
      toolbarHeight: height,
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,

      leading: _buildLeading(context),
      title: Text(title, style: AppTypography.h3),
      actions: _buildActions(),
    );
  }

  // ---------------- Leading ----------------

  Widget? _buildLeading(BuildContext context) {
    if (showBackButton) {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.iconPrimary),
        onPressed: onBack ?? () => Navigator.pop(context),
      );
    }

    if (avatarPath != null) {
      return Padding(
        padding: EdgeInsets.only(left: AppDimensions.spacingM),
        child: GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: AppDimensions.radiusCircular,
            backgroundImage: AssetImage(avatarPath!),
            backgroundColor: AppColors.surface,
          ),
        ),
      );
    }

    return null;
  }

  // ---------------- Actions ----------------

  List<Widget>? _buildActions() {
    final List<Widget> actionWidgets = [];

    if (showNotification) {
      actionWidgets.add(
        IconButton(
          icon: Icon(
            Icons.notifications,
            size: AppDimensions.iconXl,
            color: AppColors.iconPrimary,
          ),
          onPressed: onNotificationTap,
        ),
      );
    }

    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    if (actionWidgets.isEmpty) return null;

    return actionWidgets;
  }
}

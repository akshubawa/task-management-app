import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/core/utils/app_info_helper.dart';
import 'package:task_management/core/utils/device_utils.dart';

class SideMenu extends StatelessWidget {
  final String userName;
  final String gymName;
  final String userRole;
  final String? userImageUrl;

  /// Username to encode in the member QR (e.g. login username). Falls back to [userName] if null.
  final String? usernameForQr;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onShareAppTap;
  final VoidCallback onHelpSupportTap;
  final VoidCallback onLogoutTap;

  const SideMenu({
    super.key,
    required this.userName,
    required this.gymName,
    required this.userRole,
    this.userImageUrl,
    this.usernameForQr,
    required this.onProfileTap,
    required this.onSettingsTap,
    required this.onShareAppTap,
    required this.onHelpSupportTap,
    required this.onLogoutTap,
  });

  /// Show member QR only when role is not owner (ADMIN) or platform admin (PLATFORM_ADMIN).
  bool get _shouldShowMemberQr {
    final r = userRole.toUpperCase();
    return r != 'ADMIN' && r != 'PLATFORM_ADMIN';
  }

  String? get _qrData {
    final u = usernameForQr ?? userName;
    if (u.isEmpty || u == 'Loading...' || u == 'Error') return null;
    return u;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = isTablet(context) ? screenWidth * 0.75 : null;

    return Drawer(
      width: drawerWidth,
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Profile Header Section - Make it scrollable if needed
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileHeader(),

                    // Menu Items
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: onSettingsTap,
                    ),
                    _buildMenuItem(
                      icon: Icons.share_outlined,
                      title: 'Share App',
                      onTap: onShareAppTap,
                    ),
                    _buildMenuItem(
                      icon: Icons.headset_mic_outlined,
                      title: 'Help & Support',
                      onTap: onHelpSupportTap,
                    ),
                    SizedBox(height: AppDimensions.spacingS),
                  ],
                ),
              ),
            ),

            // Bottom Section - Fixed at bottom
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: AppColors.border,
                  thickness: AppDimensions.borderWidthThin,
                  height: 1,
                ),

                // Logout Button at Bottom
                _buildLogoutButton(),

                // Version Info
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AppDimensions.spacingM,
                    top: AppDimensions.spacingXs,
                  ),
                  child: FutureBuilder<String>(
                    future: getAppVersion(),
                    builder: (context, snapshot) {
                      final version = snapshot.data ?? '1.0.0';
                      return Text(
                        'VERSION $version'.toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with online indicator and admin badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: AppDimensions.avatarL / 2,
                    backgroundColor: AppColors.primary,
                    backgroundImage: userImageUrl != null
                        ? NetworkImage(userImageUrl!)
                        : null,
                    child: userImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: AppDimensions.icon2Xl,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                  // Online indicator (green dot)
                  Positioned(
                    right: 2.w,
                    bottom: 2.h,
                    child: Container(
                      width: AppDimensions.statusDotSizeLarge,
                      height: AppDimensions.statusDotSizeLarge,
                      decoration: BoxDecoration(
                        color: AppColors.activeIndicator,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppDimensions.spacingM),
              // Admin Badge - Flexible to prevent overflow
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    userRole.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spacingL),

          // User Name - Handle overflow
          Text(
            userName,
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: AppDimensions.spacingXs),

          // Gym Name - Handle overflow
          Text(
            gymName,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: AppDimensions.spacingL),

          // View & Edit Profile Button
          InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'View & Edit Profile',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacingXs),
                  Icon(
                    Icons.chevron_right,
                    size: AppDimensions.iconS,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXl,
          vertical: AppDimensions.spacingM,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppDimensions.iconL,
              color: AppColors.iconSecondary,
            ),
            SizedBox(width: AppDimensions.spacingL),
            Flexible(
              child: Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: onLogoutTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXl,
          vertical: AppDimensions.spacingL,
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout,
              size: AppDimensions.iconL,
              color: AppColors.primary,
            ),
            SizedBox(width: AppDimensions.spacingL),
            Text(
              'Logout',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

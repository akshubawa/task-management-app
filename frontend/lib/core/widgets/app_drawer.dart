import 'package:flutter/material.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_router.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/core/di/injector.dart';
import 'package:task_management/core/utils/app_info_helper.dart';
import 'package:task_management/features/auth/data/entity/user_entity.dart';
import 'package:task_management/features/auth/domain/repository/auth_repository.dart';

/// Side drawer with profile (from API), logout, and app version.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = Injector.instance<AuthRepository>();
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingHorizontal,
                  vertical: AppDimensions.spacingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHeader(authRepository: authRepo),
                    SizedBox(height: AppDimensions.spacing2Xl),
                    _LogoutTile(
                      onLogout: () => _performLogout(context, authRepo),
                    ),
                  ],
                ),
              ),
            ),
            _VersionFooter(),
          ],
        ),
      ),
    );
  }

  void _performLogout(BuildContext context, AuthRepository authRepo) {
    Navigator.of(context).pop(); // close drawer
    authRepo.logout();
    AppRouter.navigateAndRemoveUntil(context, AppRouter.login);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEntity>(
      future: authRepository.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _ProfileHeaderPlaceholder(isLoading: true);
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _ProfileHeaderPlaceholder(
            isLoading: false,
            error: snapshot.hasError ? snapshot.error.toString() : null,
          );
        }
        return _ProfileHeaderContent(user: snapshot.data!);
      },
    );
  }
}

class _ProfileHeaderPlaceholder extends StatelessWidget {
  const _ProfileHeaderPlaceholder({
    required this.isLoading,
    this.error,
  });

  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppDimensions.borderRadiusL,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryWithOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppDimensions.avatarL / 2,
            backgroundColor: AppColors.whiteWithOpacity(0.25),
            child: isLoading
                ? SizedBox(
                    width: AppDimensions.icon2Xl,
                    height: AppDimensions.icon2Xl,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: AppDimensions.icon2Xl,
                    color: AppColors.white,
                  ),
          ),
          SizedBox(width: AppDimensions.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  Container(
                    height: 18,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.whiteWithOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                else
                  Text(
                    error != null ? 'Could not load profile' : 'Profile',
                    style: AppTypography.h4.copyWith(color: AppColors.white),
                  ),
                if (!isLoading && error == null) ...[
                  SizedBox(height: AppDimensions.spacingXs),
                  Container(
                    height: 14,
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppColors.whiteWithOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderContent extends StatelessWidget {
  const _ProfileHeaderContent({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppDimensions.borderRadiusL,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryWithOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppDimensions.avatarL / 2,
            backgroundColor: AppColors.whiteWithOpacity(0.25),
            child: Text(
              user.fullName.isNotEmpty
                  ? user.fullName.substring(0, 1).toUpperCase()
                  : '?',
              style: AppTypography.h3.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: AppTypography.h4.copyWith(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimensions.spacingXs),
                Text(
                  user.email,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.whiteWithOpacity(0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.mobileNumber.isNotEmpty) ...[
                  SizedBox(height: AppDimensions.spacingXXs),
                  Text(
                    user.mobileNumber,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.whiteWithOpacity(0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onLogout,
        borderRadius: AppDimensions.borderRadiusM,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.spacingM,
            horizontal: AppDimensions.spacingM,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.buttonDanger.withValues(alpha: 0.2),
                  borderRadius: AppDimensions.borderRadiusS,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: AppDimensions.iconL,
                  color: AppColors.buttonDangerText,
                ),
              ),
              SizedBox(width: AppDimensions.spacingL),
              Text(
                'Log out',
                style: AppTypography.bodyLargeMedium.copyWith(
                  color: AppColors.buttonDangerText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      child: FutureBuilder<String>(
        future: getAppVersion(),
        builder: (context, snapshot) {
          final version = snapshot.hasData ? snapshot.data! : '—';
          return Text(
            'Version $version',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_strings.dart';
import 'package:task_management/core/constants/app_typography.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LoginLogo(),
        SizedBox(height: AppDimensions.spacingL),
        Text(
          AppStrings.welcomeBack,
          style: AppTypography.displaySmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spacingS),
        Text(
          AppStrings.loginSubtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      height: 72.w,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Icon(
        Icons.check_rounded,
        size: AppDimensions.icon3Xl,
        color: AppColors.white,
      ),
    );
  }
}

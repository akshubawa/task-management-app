import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_router.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/core/services/local_storage.dart';

/// Splash screen shown on app launch. Navigates to login or home based on token.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    final token = await LocalStorage.getAccessToken();
    final hasToken = token != null && token.isNotEmpty;
    if (!mounted) return;
    if (hasToken) {
      AppRouter.navigateAndRemoveUntil(context, AppRouter.home);
    } else {
      AppRouter.navigateAndRemoveUntil(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt_rounded,
                size: 80.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 24.h),
              Text(
                'Task Management',
                style: AppTypography.h1.copyWith(
                  fontSize: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Get things done',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 48.h),
              SizedBox(
                width: 32.w,
                height: 32.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

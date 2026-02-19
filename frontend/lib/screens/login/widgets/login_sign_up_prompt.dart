import 'package:flutter/material.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_router.dart';
import 'package:task_management/core/constants/app_strings.dart';
import 'package:task_management/core/constants/app_typography.dart';

class LoginSignUpPrompt extends StatelessWidget {
  const LoginSignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => AppRouter.navigateTo(context, AppRouter.signUp),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              AppStrings.signUp,
              style: AppTypography.link,
            ),
          ),
        ),
      ],
    );
  }
}

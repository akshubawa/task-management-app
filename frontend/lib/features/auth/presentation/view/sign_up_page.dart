import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_router.dart';
import 'package:task_management/core/constants/app_strings.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/core/utils/custom_button.dart';
import 'package:task_management/core/utils/custom_textfield.dart';
import 'package:task_management/features/auth/presentation/cubit/register_cubit.dart';
import 'package:task_management/features/auth/presentation/cubit/register_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: const Text('Account created. Please log in.'),
            autoCloseDuration: const Duration(seconds: 3),
          );
          AppRouter.navigateAndReplace(context, AppRouter.login);
        }
        if (state is RegisterFailure) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            title: Text(state.message),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingHorizontal,
              vertical: AppDimensions.screenPaddingVertical,
            ),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                _SignUpHeader(),
                SizedBox(height: AppDimensions.spacing3Xl),
                const _SignUpFormCard(),
                SizedBox(height: AppDimensions.spacing2Xl),
                const _TermsText(),
                SizedBox(height: AppDimensions.spacing2Xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.task_alt_rounded, size: 56.sp, color: AppColors.primary),
        SizedBox(height: 16.h),
        Text(
          AppStrings.createAccount,
          style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.signUpSubtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SignUpFormCard extends StatefulWidget {
  const _SignUpFormCard();

  @override
  State<_SignUpFormCard> createState() => _SignUpFormCardState();
}

class _SignUpFormCardState extends State<_SignUpFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onCreateAccountPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final mobile = _mobileController.text.replaceAll(
        RegExp(r'[\s\-\(\)]'),
        '',
      );
      context.read<RegisterCubit>().register(
        fullName: _fullNameController.text,
        mobileNumber: mobile.isEmpty ? _mobileController.text : mobile,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  int _passwordStrength(String value) {
    if (value.isEmpty) return 0;
    int s = 0;
    if (value.length >= 8) s++;
    if (value.contains(RegExp(r'[A-Z]')) && value.contains(RegExp(r'[a-z]')))
      s++;
    if (value.contains(RegExp(r'[0-9]'))) s++;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) s++;
    return s.clamp(0, 4);
  }

  String _strengthLabel(int s) {
    switch (s) {
      case 0:
        return 'WEAK';
      case 1:
        return 'FAIR';
      case 2:
        return 'GOOD';
      case 3:
        return 'STRONG';
      case 4:
        return 'STRONG';
      default:
        return 'WEAK';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppDimensions.cardPaddingLarge,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(
          color: AppColors.border,
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _fullNameController,
              labelText: AppStrings.fullName,
              hintText: AppStrings.fullNameHint,
              fieldType: InputFieldType.text,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spacingL),
            CustomTextField(
              controller: _emailController,
              labelText: AppStrings.emailAddress,
              hintText: AppStrings.emailHint,
              fieldType: InputFieldType.email,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spacingL),
            CustomTextField(
              controller: _mobileController,
              labelText: AppStrings.mobileNumber,
              hintText: AppStrings.mobileNumberHint,
              fieldType: InputFieldType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spacingL),
            CustomTextField(
              controller: _passwordController,
              labelText: AppStrings.password,
              hintText: '••••••••',
              fieldType: InputFieldType.password,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Please enter a password';
                }
                if (v.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spacingS),
            _PasswordStrengthBar(
              strength: _passwordStrength(_passwordController.text),
              label: _strengthLabel(
                _passwordStrength(_passwordController.text),
              ),
            ),
            SizedBox(height: AppDimensions.spacing2Xl),
            BlocBuilder<RegisterCubit, RegisterState>(
              buildWhen: (prev, curr) =>
                  prev is RegisterLoading != curr is RegisterLoading,
              builder: (context, state) {
                final isLoading = state is RegisterLoading;
                return SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightLarge,
                  child: CustomButton(
                    onPressed: isLoading ? null : _onCreateAccountPressed,
                    text: AppStrings.createAccount,
                    isLoading: isLoading,
                    loadingColor: AppColors.buttonPrimaryText,
                    suffixIcon: isLoading
                        ? null
                        : Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.buttonPrimaryText,
                            size: AppDimensions.iconM,
                          ),
                    sizeType: ButtonSizeType.large,
                    shapeType: ButtonShapeType.semiRounded,
                  ),
                );
              },
            ),
            SizedBox(height: AppDimensions.spacing2Xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.alreadyHaveAccount,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => AppRouter.goBack(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(AppStrings.login, style: AppTypography.link),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength, required this.label});

  final int strength;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(4, (i) {
              final filled = i < strength;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: filled ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          AppStrings.minCharacters,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(text: AppStrings.termsPrefix),
            TextSpan(
              text: AppStrings.termsOfService,
              style: TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(text: AppStrings.and),
            TextSpan(
              text: AppStrings.privacyPolicy,
              style: TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}

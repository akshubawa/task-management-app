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
import 'package:task_management/features/auth/presentation/cubit/login_cubit.dart';
import 'package:task_management/features/auth/presentation/cubit/login_state.dart';
import 'package:task_management/features/auth/presentation/widget/login_header.dart';
import 'package:task_management/screens/login/widgets/login_sign_up_prompt.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: Text(
              state.result.user.fullName.isEmpty
                  ? 'Login successful'
                  : 'Welcome back, ${state.result.user.fullName}!',
            ),
            autoCloseDuration: const Duration(seconds: 3),
          );
          AppRouter.navigateAndRemoveUntil(context, AppRouter.home);
        }
        if (state is LoginFailure) {
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
                const LoginHeader(),
                SizedBox(height: AppDimensions.spacing3Xl),
                const _LoginFormCard(),
                SizedBox(height: AppDimensions.spacing2Xl),
                const LoginSignUpPrompt(),
                SizedBox(height: AppDimensions.spacing2Xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormCard extends StatefulWidget {
  const _LoginFormCard();

  @override
  State<_LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<_LoginFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
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
            Text(
              AppStrings.password,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            CustomTextField(
              controller: _passwordController,
              labelText: null,
              hintText: '••••••••',
              fieldType: InputFieldType.password,
              textInputAction: TextInputAction.done,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spacingL),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (prev, curr) =>
                  prev is LoginLoading != curr is LoginLoading,
              builder: (context, state) {
                final isLoading = state is LoginLoading;
                return SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightLarge,
                  child: CustomButton(
                    onPressed: isLoading ? null : _onLoginPressed,
                    text: AppStrings.login,
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
          ],
        ),
      ),
    );
  }
}

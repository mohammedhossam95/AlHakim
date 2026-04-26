// ignore_for_file: use_build_context_synchronously

import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/constants.dart';
import '/core/utils/validator.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/loading_view.dart';
import '/core/widgets/my_default_button.dart';
import '/core/widgets/tags_text_form_field.dart';
import '/injection_container.dart';

class ResetPasswordScreen extends StatefulWidget {
  final AuthParams authParams;

  const ResetPasswordScreen({super.key, required this.authParams});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPassword() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _passwordFocus.unfocus();
        _confirmPasswordFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: colors.backGround,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Gaps.vGap10,
                    const AuthAppBar(showBackButton: true),
                    Gaps.vGap40,
                    Text('reset_password'.tr, style: TextStyles.semiBold24()),
                    Gaps.vGap10,
                    Text(
                      'reset_password_text'.tr,
                      style: TextStyles.medium14(color: colors.lightTextColor),
                    ),
                    Gaps.vGap30,
                    AppTextFormField(
                      borderColor: colors.textColor.withValues(alpha: .2),
                      backgroundColor: const Color(
                        0xffd0d0d0,
                      ).withValues(alpha: .2),
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      textInputAction: TextInputAction.next,
                      validatorType: ValidatorType.password,
                      hintText: 'new_password'.tr,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20.r,
                          color: colors.lightTextColor,
                        ),
                        onPressed: _togglePassword,
                      ),
                    ),
                    Gaps.vGap20,
                    AppTextFormField(
                      borderColor: colors.textColor.withValues(alpha: .2),
                      backgroundColor: const Color(
                        0xffd0d0d0,
                      ).withValues(alpha: .2),
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      hintText: 'confirm_new_password'.tr,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'required'.tr;
                        }
                        if (value != _passwordController.text) {
                          return 'passwords_not_match'.tr;
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20.r,
                          color: colors.lightTextColor,
                        ),
                        onPressed: _toggleConfirmPassword,
                      ),
                    ),
                    Gaps.vGap30,
                    BlocConsumer<RegisterCubit, RegisterState>(
                      listener: _handleResetPasswordStateChanges,
                      builder: _buildResetPasswordButton,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordButton(BuildContext context, RegisterState state) {
    return Column(
      children: [
        state is RegisterIsLoading
            ? LoadingView(bgColor: colors.main)
            : MyDefaultButton(
                color: colors.main,
                borderColor: colors.main,
                onPressed: _resetPasswordPressed,
                btnText: 'confirm_button',
              ),
        if (state is RegisterError) ...[
          Gaps.vGap10,
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyles.regular14(color: colors.errorColor),
          ),
        ],
      ],
    );
  }

  void _resetPasswordPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // You'll need to create a specific usecase for password reset in your backend
      // For now showing a success message
      Constants.showSnakToast(
        context: context,
        type: 1,
        message: 'password_reset_success'.tr,
      );

      Future.delayed(const Duration(seconds: 2), () {
        context.go(Routes.loginScreenRoute);
      });
    }
  }

  void _handleResetPasswordStateChanges(
    BuildContext context,
    RegisterState state,
  ) {
    if (state is RegisterLoaded) {
      Constants.showSnakToast(
        context: context,
        type: 1,
        message: 'password_reset_success'.tr,
      );

      context.go(Routes.loginScreenRoute);
    } else if (state is RegisterError) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: state.message,
      );
    }
  }
}

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/domain/usecases/params/reset_password_params.dart';
import 'package:alhakim/features/auth/presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:alhakim/features/auth/presentation/widgets/pin_widget.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  final AuthParams authParams;

  const ResetPasswordScreen({super.key, required this.authParams});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_otpController.text.trim().length < 6) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: 'enter_verification_code'.tr,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: 'passwords_not_match'.tr,
      );
      return;
    }

    context.read<ResetPasswordCubit>().resetPassword(
      ResetPasswordParams(
        countryCode: widget.authParams.countryCode ?? '',
        phoneNumber: widget.authParams.phoneNumber ?? '',
        otp: _otpController.text.trim(),
        password: _passwordController.text.trim(),
        passwordConfirmation: _confirmPasswordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    'activation_code'.tr,
                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),
                  Gaps.vGap12,
                  PinCodeWidget(
                    pinLength: 6,
                    controller: _otpController,
                    focus: _otpFocus,
                    textSubmit: (_) {},
                  ),
                  Gaps.vGap16,
                  MyTextFormField(
                    controller: _passwordController,
                    hintText: 'new_password'.tr,
                    obscureText: _obscurePassword,
                    validatorType: ValidatorType.password,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: colors.main,
                      size: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.lightTextColor,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  Gaps.vGap16,
                  MyTextFormField(
                    controller: _confirmPasswordController,
                    hintText: 'confirm_password'.tr,
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
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: colors.main,
                      size: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.lightTextColor,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                  ),
                  Gaps.vGap30,
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: (context, state) {
                      if (state is ResetPasswordSuccess) {
                        Constants.showSnakToast(
                          context: context,
                          type: 1,
                          message:
                              state.response.message ??
                              'password_reset_success'.tr,
                        );
                        context.go(Routes.loginScreenRoute);
                      } else if (state is ResetPasswordError) {
                        Constants.showSnakToast(
                          context: context,
                          type: 3,
                          message: state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is ResetPasswordLoading;
                      return isLoading
                          ? const LoadingView()
                          : MyDefaultButton(
                              btnText: 'confirm',

                              onPressed: _onSubmit,
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

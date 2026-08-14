import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/change_password_params.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/app_snack_bar.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/tags_text_form_field.dart';
import 'package:alhakim/features/settings/presentaion/cubit/change_password_cubit/change_password_cubit.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ChangePasswordCubit>().changePassword(
      ChangePasswordParams(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
        newPasswordConfirmation: _confirmPasswordController.text.trim(),
      ),
    );
  }

  Widget _visibilityToggle({
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: colors.lightTextColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccessState) {
              showAppSnackBar(
                context: context,
                type: ToastType.success,
                message:
                    state.resp.message ?? 'password_changed_success'.tr,
              );
              context.pop();
            }
            if (state is ChangePasswordErrorState) {
              showAppSnackBar(
                context: context,
                type: ToastType.error,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ChangePasswordLoadingState;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      title: 'changePassword'.tr,
                      isInTabBar: false,
                    ),
                    Gaps.vGap40,
                    Text(
                      'currentPassword'.tr,
                      style: TextStyles.bold14(color: colors.textColor),
                    ),
                    Gaps.vGap10,
                    AppTextFormField(
                      controller: _currentPasswordController,
                      focusNode: _currentPasswordFocus,
                      hintText: 'currentPassword'.tr,
                      obscureText: _obscureCurrent,
                      textInputAction: TextInputAction.next,
                      validatorType: ValidatorType.password,
                      borderColor: colors.textColor.withValues(alpha: 0.24),
                      suffixIcon: _visibilityToggle(
                        obscure: _obscureCurrent,
                        onToggle: () {
                          setState(() => _obscureCurrent = !_obscureCurrent);
                        },
                      ),
                    ),
                    Gaps.vGap16,
                    Text(
                      'newPassword'.tr,
                      style: TextStyles.bold14(color: colors.textColor),
                    ),
                    Gaps.vGap10,
                    AppTextFormField(
                      controller: _newPasswordController,
                      focusNode: _newPasswordFocus,
                      hintText: 'newPassword'.tr,
                      obscureText: _obscureNew,
                      textInputAction: TextInputAction.next,
                      borderColor: colors.textColor.withValues(alpha: 0.24),
                      validator: (value) {
                        final passwordError = Validator.call(
                          value: value,
                          type: ValidatorType.password,
                        );
                        if (passwordError != null) return passwordError;
                        if (value!.trim() ==
                            _currentPasswordController.text.trim()) {
                          return 'new_password_same_as_current'.tr;
                        }
                        return null;
                      },
                      suffixIcon: _visibilityToggle(
                        obscure: _obscureNew,
                        onToggle: () {
                          setState(() => _obscureNew = !_obscureNew);
                        },
                      ),
                    ),
                    Gaps.vGap16,
                    Text(
                      'confirmNewPassword'.tr,
                      style: TextStyles.bold14(color: colors.textColor),
                    ),
                    Gaps.vGap10,
                    AppTextFormField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      hintText: 'confirmNewPassword'.tr,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      borderColor: colors.textColor.withValues(alpha: 0.24),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'required'.tr;
                        }
                        if (value.trim() !=
                            _newPasswordController.text.trim()) {
                          return 'passwords_not_match'.tr;
                        }
                        return null;
                      },
                      suffixIcon: _visibilityToggle(
                        obscure: _obscureConfirm,
                        onToggle: () {
                          setState(() => _obscureConfirm = !_obscureConfirm);
                        },
                      ),
                    ),
                    Gaps.vGap50,
                    MyDefaultButton(
                      btnText: 'save_changes',
                      borderColor: colors.main,
                      color: colors.main,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onSubmit,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

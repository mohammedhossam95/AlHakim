import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/presentation/cubit/login/login_cubit.dart';
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _phoneFocus.unfocus(),
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
                      'forgot_password_text'.tr,
                      style: TextStyles.medium14(color: colors.lightTextColor),
                    ),
                    Gaps.vGap30,
                    AppTextFormField(
                      borderColor: colors.textColor.withValues(alpha: .2),
                      backgroundColor: const Color(
                        0xffd0d0d0,
                      ).withValues(alpha: .2),
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      isPhone: false,
                      validatorType: ValidatorType.phone,
                      hintText: 'phone_number'.tr,
                    ),
                    Gaps.vGap30,
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: _handleLoginStateChanges,
                      builder: _buildSendCodeButton,
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

  Widget _buildSendCodeButton(BuildContext context, LoginState state) {
    return Column(
      children: [
        state is LoginIsLoading
            ? LoadingView(bgColor: colors.main)
            : MyDefaultButton(
                color: colors.main,
                borderColor: colors.main,
                onPressed: _forgetPasswordPressed,
                btnText: 'send_code',
              ),
        if (state is LoginError) ...[
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

  void _forgetPasswordPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authParams = AuthParams(phone: _phoneController.text);

      context.read<LoginCubit>().login(authParams);
    }
  }

  void _handleLoginStateChanges(BuildContext context, LoginState state) {
    if (state is LoginLoaded) {
      final response = state.response.data;
      final AuthParams params = AuthParams(
        pendingUserId: response.pendingUserId,
        otp: response.otp,
        passwordResetId: response.passwordResetId,
        otpType: 'forgot_password',
        phone: _phoneController.text,
      );
      context.pushNamed(Routes.otpAuthRoute, extra: params);
    } else if (state is LoginError) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: state.message,
      );
    }
  }
}

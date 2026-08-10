import 'dart:async';

import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/presentation/cubit/resend_otp_cubit/resend_otp_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/pin_widget.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/constants.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';

class OtpAuthScreen extends StatefulWidget {
  final AuthParams authParams;

  const OtpAuthScreen({super.key, required this.authParams});

  @override
  State<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends State<OtpAuthScreen> {
  final _otpController = TextEditingController();
  final _pinFocus = FocusNode();

  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  String _internationalPhone() {
    var cc = (widget.authParams.countryCode ?? '').trim().replaceAll(' ', '');
    if (!cc.startsWith('+')) {
      cc = '+$cc';
    }
    final nsn = (widget.authParams.phoneNumber ?? '').replaceAll(
      RegExp(r'[\s\-.]'),
      '',
    );
    return '$cc$nsn';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinFocus.unfocus();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _showError(String msg) {
    if (!mounted) return;
    Constants.showSnakToast(context: context, message: msg, type: 3);
  }

  Future<void> _onVerifyPressed() async {
    final code = _otpController.text.trim();
    if (code.length < 6) {
      _showError('enter_verification_code'.tr);
      return;
    }

    if (!mounted) return;
    context.read<VerifyCodeCubit>().verifyCode(
      AuthParams(
        otp: code,
        phoneNumber: widget.authParams.phoneNumber,
        countryCode: widget.authParams.countryCode,
        userType: sessionCubit.state.userType,
      ),
    );
  }

  void _onResendPressed() {
    if (!_canResend) return;

    context.read<ResendOtpCubit>().resendOtp(
      AuthParams(
        phoneNumber: widget.authParams.phoneNumber,
        countryCode: widget.authParams.countryCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Center(child: CustomBackButton())),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerifyCodeCubit, VerifyCodeState>(
            listener: (context, state) {
              if (state is VerifyCodeLoaded) {
                Constants.showSnakToast(
                  context: context,
                  type: 1,
                  message: state.response.message ?? '',
                );
                final data = state.response.data as AuthModel?;
                if (data == null) return;

                sharedPreferences.saveAuth(data);

                if (data.token != null && data.token!.isNotEmpty) {
                  secureStorage.saveAccessToken(data.token!);
                }

                context.read<SessionCubit>().loginSuccess(
                  sessionCubit.state.userType,
                );

                context.read<BottomNavBarCubit>().changeCurrentScreen(
                  index: 0,
                );
                context.go(Routes.mainPageRoute);
              } else if (state is VerifyCodeError) {
                _showError(state.message);
              }
            },
          ),
          BlocListener<ResendOtpCubit, ResendOtpState>(
            listener: (context, state) {
              if (state is ResendOtpSuccess) {
                _startTimer();
                _otpController.clear();
                _pinFocus.requestFocus();
                Constants.showSnakToast(
                  context: context,
                  message: state.response.message ?? 'resend_code'.tr,
                  type: 1,
                );
              } else if (state is ResendOtpError) {
                _showError(state.message);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeIn(
                  child: Center(
                    child: Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: colors.main,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
                Gaps.vGap20,
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'activation_code'.tr,
                    style: TextStyles.medium20(),
                  ),
                ),
                Gaps.vGap10,
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    "${'enter_verification_code'.tr}\t\t${_internationalPhone()} ",
                    style: TextStyles.regular12(
                      color: colors.lightTextColor.withValues(alpha: 0.7),
                    ).copyWith(height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.vGap20,
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: PinCodeWidget(
                    pinLength: 6,
                    controller: _otpController,
                    focus: _pinFocus,
                    textSubmit: (_) => _onVerifyPressed(),
                  ),
                ),
                Gaps.vGap20,
                _canResend ? _buildResendButton() : _buildTimer(),
                Gaps.vGap10,
                BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
                  builder: (context, state) {
                    final isLoading = state is VerifyCodeIsLoading;
                    return FadeIn(
                      delay: const Duration(milliseconds: 700),
                      child: MyDefaultButton(
                        color: colors.main,
                        svgAsset: SvgAssets.iconArrowBackEn,
                        btnText: 'verify_confirm',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _onVerifyPressed,
                      ),
                    );
                  },
                ),
                Gaps.vGap40,
                _buildChangeNumberButton(),
                Gaps.vGap30,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _secondsRemaining.toString(),
            style: TextStyles.semiBold15(color: colors.lightTextColor),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.access_time_rounded,
            size: 18,
            color: colors.lightTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildResendButton() {
    return BlocBuilder<ResendOtpCubit, ResendOtpState>(
      builder: (context, state) {
        final isLoading = state is ResendOtpLoading;
        return TextButton(
          onPressed: _canResend && !isLoading ? _onResendPressed : null,
          child: isLoading
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('resend_code'.tr),
        );
      },
    );
  }

  Widget _buildChangeNumberButton() {
    return InkWell(
      onTap: context.pop,
      child: Center(
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: const [10, 5],
            strokeWidth: 1.5.r,
            radius: Radius.circular(20.r),
            color: colors.lightTextColor,
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_outlined, size: 18, color: Color(0xFF6B7280)),
              Gaps.hGap8,
              Text(
                'change_number'.tr,
                style: TextStyles.regular10(color: colors.lightTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

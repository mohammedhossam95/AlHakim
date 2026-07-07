import 'dart:async';

import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/services/firebase/firebase_service.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/pin_widget.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/constants.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/loading_view.dart';
import '/core/widgets/my_default_button.dart';

class OtpAuthScreen extends StatefulWidget {
  final AuthParams authParams;
  final OtpVerificationManager? otpManager;

  const OtpAuthScreen({super.key, required this.authParams, this.otpManager});

  @override
  State<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends State<OtpAuthScreen> {
  final _otpController = TextEditingController();
  final _pinFocus = FocusNode();

  late final OtpVerificationManager _otpManager;

  bool _isLoading = false;
  bool _isVerifying = false;
  bool _otpSent = false;
  bool _flowHandled = false;

  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;
  String? firebaseToken;

  @override
  void initState() {
    super.initState();
    _otpManager =
        widget.otpManager ??
        OtpVerificationManager(FirebaseOtpVerificationService());
    _sendOtp();
    _startTimer();
    getFirebaseToken();
  }

  void getFirebaseToken() async {
    FirebaseMessaging.instance
        .getToken()
        .then((devicefcmToken) {
          firebaseToken = devicefcmToken;
        })
        .catchError((e) {
          firebaseToken = '';
        });
  }

  String _internationalPhone() {
    var cc = (widget.authParams.countryCode ?? '').trim().replaceAll(' ', '');
    if (cc.startsWith('+')) {
      cc = cc.substring(1);
    }
    final nsn = (widget.authParams.phoneNumber ?? '').replaceAll(
      RegExp(r'[\s\-.]'),
      '',
    );
    return '+$cc$nsn';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinFocus.unfocus();
    _otpController.dispose();
    super.dispose();
  }

  /// 🔥 Central success handler (REGISTER or FORGET PASSWORD)
  Future<void> _handleSuccessFlow() async {
    if (_flowHandled) return;
    _flowHandled = true;

    if (!mounted) return;
    onConfirmPressed();
  }

  Future<void> _sendOtp() async {
    if (_isLoading) return;

    final phone = _internationalPhone();

    try {
      setState(() => _isLoading = true);

      final result = await _otpManager.sendOtp(phone);

      if (result.status == OtpResultStatus.autoVerified) {
        await _handleSuccessFlow();
        return;
      }

      setState(() => _otpSent = true);
    } on OtpVerificationException catch (e) {
      _showError(_mapError(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying || !_otpSent) return;

    if (_otpController.text.trim().length < 6) {
      _showError("Enter complete OTP");
      return;
    }

    if (_secondsRemaining == 0) {
      _showError("OTP expired, please resend");
      return;
    }

    try {
      setState(() => _isVerifying = true);

      final result = await _otpManager.verifyOtp(_otpController.text.trim());

      if (result.status == OtpResultStatus.verified) {
        await _handleSuccessFlow();
      }
    } on OtpVerificationException catch (e) {
      _showError(_mapError(e.code));
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    final phone = _internationalPhone();

    try {
      setState(() => _isLoading = true);

      await _otpManager.resendOtp(phone);

      _startTimer();
      _otpController.clear();
      _pinFocus.requestFocus();

      if (!mounted) return;
      Constants.showSnakToast(
        context: context,
        message: "OTP resent successfully",
        type: 1,
      );
    } on OtpVerificationException catch (e) {
      _showError(_mapError(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  String _mapError(String code) {
    switch (code) {
      case 'INVALID_OTP':
        return "Invalid OTP";
      case 'OTP_EXPIRED':
        return "OTP expired, please resend";
      case 'TOO_MANY_REQUESTS':
        return "Too many attempts, try later";
      case 'INVALID_PHONE':
        return "Invalid phone number";
      case 'NO_VERIFICATION_ID':
        return "Verification session missing. Resend the code.";
      case 'RESEND_NOT_AVAILABLE':
        return "Cannot resend yet. Wait or go back and try again.";
      case 'NETWORK_ERROR':
        return "Network error. Check connection and try again.";
      case 'APP_NOT_AUTHORIZED':
        return "App not authorized for phone sign-in. Check Firebase setup.";
      case 'QUOTA_EXCEEDED':
        return "SMS quota exceeded. Try again later.";
      case 'CAPTCHA_FAILED':
        return "Verification check failed. Retry or update the app.";
      default:
        return "Something went wrong";
    }
  }

  void onConfirmPressed() async {
    final code = _otpController.text;
    if (code.length < 6) return;
    final phone = await Constants.phoneParsing(
      phone: widget.authParams.phoneNumber,
      countryCode: "${widget.authParams.countryCode}",
      withCode: false,
    );
    if (!mounted) return;
    context.read<VerifyCodeCubit>().verifyCode(
      AuthParams(
        otp: _otpController.text,
        phoneNumber: phone ?? '',
        countryCode: "${widget.authParams.countryCode}",
        userType: sessionCubit.state.userType,
        firebaseToken: firebaseToken,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Center(child: CustomBackButton())),

      body: BlocListener<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          if (state is VerifyCodeLoaded) {
            Constants.showSnakToast(
              context: context,
              type: 1,
              message: state.response.message,
            );
            final data = state.response.data as AuthModel;
            sharedPreferences.saveAuth(data);

            if (data.token != null && data.token!.isNotEmpty) {
              secureStorage.saveAccessToken(data.token!);
            }

            context.read<SessionCubit>().loginSuccess(
              sessionCubit.state.userType,
            );

            switch (data.nextStep) {
              case "complete_profile":
                context.pushReplacementNamed(
                  Routes.completeProfileRegisterScreenRoute,
                );
                return;

              case "go_to_home":
              default:
                context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);

                context.pushReplacementNamed(Routes.mainPageRoute);
                return;
            }
          }

          if (state is VerifyCodeError) {
            _flowHandled = false;
            _showError(state.message.toString());
          }
        },
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
                  delay: Duration(milliseconds: 300),
                  child: Text(
                    'activation_code'.tr,
                    style: TextStyles.medium20(),
                  ),
                ),
                Gaps.vGap10,
                FadeInUp(
                  delay: Duration(milliseconds: 400),
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
                  delay: Duration(milliseconds: 600),
                  child: PinCodeWidget(
                    pinLength: 6,
                    controller: _otpController,
                    focus: _pinFocus,
                    textSubmit: (_) => _verifyOtp(),
                  ),
                ),

                Gaps.vGap20,
                _canResend ? _buildResendButton() : _buildTimer(),

                Gaps.vGap10,

                _isVerifying
                    ? const LoadingView()
                    : FadeIn(
                        delay: Duration(milliseconds: 700),
                        child: MyDefaultButton(
                          color: colors.main,
                          svgAsset: SvgAssets.iconArrowBackEn,
                          btnText: 'verify_confirm',
                          onPressed: _otpSent ? _verifyOtp : () {},
                        ),
                      ),

                Gaps.vGap40,
                _buildChangeNumberButton(),
                Gaps.vGap20,
                if (_isLoading)
                  FadeInUp(
                    delay: Duration(milliseconds: 800),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
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
    return TextButton(
      onPressed: _canResend ? _resendOtp : null,
      child: Text(
        _canResend ? "resend_code".tr : "Resend in $_secondsRemaining s",
      ),
    );
  }

  Widget _buildChangeNumberButton() {
    return InkWell(
      onTap: context.pop,
      child: Center(
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [10, 5],
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

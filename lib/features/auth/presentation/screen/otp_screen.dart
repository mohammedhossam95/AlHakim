// ignore_for_file: use_build_context_synchronously

import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/presentation/cubit/resend_otp_cubit/resend_otp_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/pin_widget.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
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

  const OtpAuthScreen({super.key, required this.authParams});

  @override
  State<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends State<OtpAuthScreen>
    with TickerProviderStateMixin {
  final TextEditingController codeController = TextEditingController();
  final FocusNode codeFocus = FocusNode();

  late AnimationController timeController;

  final Duration timeOut = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    timeController = AnimationController(vsync: this, duration: timeOut);
    timeController.reverse(from: 1.0);
  }

  @override
  void dispose() {
    timeController.dispose();
    codeController.dispose();
    super.dispose();
  }

  String get timerString {
    final duration = timeController.duration! * timeController.value;
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _onConfirmPressed() async {
    final code = codeController.text;
    if (code.length < 6) return;

    final phone = await Constants.phoneParsing(
      phone: widget.authParams.phoneNumber,
      countryCode: "${widget.authParams.countryCode}",

      withCode: false,
    );
    context.read<VerifyCodeCubit>().verifyCode(
      AuthParams(
        otp: codeController.text,
        phoneNumber: phone ?? '',
        countryCode: "${widget.authParams.countryCode}",
        userType: sessionCubit.state.userType,
        secretaryPhone: widget.authParams.secretaryPhone,
        secretaryCountryCode: widget.authParams.secretaryCountryCode,
      ),
    );
  }

  Widget _buildOtpUI({required bool isLoading, required String? errorMessage}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeIn(
              child: Center(
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: colors.main.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.done_outline_sharp,
                    color: colors.main,
                    size: 30.sp,
                  ),
                ),
              ),
            ),

            Gaps.vGap40,

            FadeInUp(
              delay: Duration(milliseconds: 300),
              child: Text('activation_code'.tr, style: TextStyles.semiBold24()),
            ),

            Gaps.vGap10,

            FadeInUp(
              delay: Duration(milliseconds: 400),
              child: Text(
                'enter_verification_code'.tr,
                style: TextStyles.semiBold14(
                  color: colors.lightTextColor.withValues(alpha: 0.7),
                ),
              ),
            ),

            Gaps.vGap10,

            FadeInUp(
              delay: Duration(milliseconds: 500),
              child: Center(
                child: Text(
                  widget.authParams.phoneNumber ?? '',
                  style: TextStyles.semiBold14(color: colors.lightTextColor),
                ),
              ),
            ),

            Gaps.vGap40,

            FadeInUp(
              delay: Duration(milliseconds: 600),
              child: PinCodeWidget(
                pinBoxWidth: 50.w,
                pinLength: 6,

                controller: codeController,
                focus: codeFocus,
                textSubmit: (_) => _onConfirmPressed(),
              ),
            ),

            Gaps.vGap50,

            isLoading
                ? const LoadingView()
                : FadeIn(
                    delay: Duration(milliseconds: 700),
                    child: MyDefaultButton(
                      color: colors.main,
                      btnText: 'confirm',
                      onPressed: () => _onConfirmPressed(),
                    ),
                  ),

            if (errorMessage != null) ...[
              Gaps.vGap10,
              Center(
                child: FadeInUp(
                  child: Text(
                    errorMessage,
                    style: TextStyles.medium14(color: Colors.red),
                  ),
                ),
              ),
            ],

            Gaps.vGap30,
            Gaps.vGap35,

            FadeInUp(
              delay: Duration(milliseconds: 800),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: timeController,
                    builder: (context, _) {
                      bool isTimerFinished = timeController.value == 0;

                      return GestureDetector(
                        onTap: (isTimerFinished)
                            ? () async {
                                final phone = await Constants.phoneParsing(
                                  phone: widget.authParams.phoneNumber,
                                  countryCode:
                                      "${widget.authParams.countryCode}",
                                  withCode: false,
                                );
                                if (phone != null) {
                                  if (!mounted) return;
                                  context.read<ResendOtpCubit>().resendOtp(
                                    AuthParams(
                                      countryCode:
                                          widget.authParams.countryCode,
                                      phoneNumber: phone,
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Text(
                          'resend_code'.tr,
                          style: TextStyles.medium14(
                            color: isTimerFinished
                                ? colors.main
                                : colors.main.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    },
                  ),

                  Gaps.hGap16,

                  AnimatedBuilder(
                    animation: timeController,
                    builder: (context, _) => Text(
                      timerString,
                      style: TextStyles.medium12(color: colors.main),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Center(child: CustomBackButton())),

      body: MultiBlocListener(
        listeners: [
          BlocListener<ResendOtpCubit, ResendOtpState>(
            listener: (context, state) {
              if (state is ResendOtpSuccess) {
                Constants.showSnakToast(
                  context: context,
                  type: 1,
                  message: state.response.message,
                );

                /// restart timer
                timeController.reverse(from: 1.0);
              }

              if (state is ResendOtpError) {
                Constants.showSnakToast(
                  context: context,
                  type: 3,
                  message: state.message,
                );
              }
            },
          ),

          BlocListener<VerifyCodeCubit, VerifyCodeState>(
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
                    context.read<BottomNavBarCubit>().changeCurrentScreen(
                      index: 0,
                    );

                    context.pushReplacementNamed(Routes.mainPageRoute);
                    return;
                }
              }

              if (state is VerifyCodeError) {
                Constants.showSnakToast(
                  context: context,
                  type: 3,
                  message: state.message,
                );
              }
            },
          ),
        ],

        child: BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
          builder: (context, state) => _buildOtpUI(
            isLoading: state is VerifyCodeIsLoading,
            errorMessage: state is VerifyCodeError ? state.message : null,
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/presentation/cubit/check_account_cubit/check_account_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Country _selectedCountry;
  String? firebaseToken;
  AuthParams? _pendingParams;

  @override
  void initState() {
    super.initState();
    getCountry();
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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void getCountry() {
    _selectedCountry = CountryParser.parsePhoneCode('20');
  }

  void _continueLoginFlow(AuthParams params) {
    if (Platform.isIOS) {
      context.read<VerifyCodeCubit>().verifyCode(params);
    } else {
      context.push(Routes.otpAuthRoute, extra: params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.main.withValues(alpha: 0.06),
                colors.secondary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: colors.whiteColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Back button
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Icon(
                            Icons.arrow_back,
                            color: colors.main,
                            size: 26,
                          ),
                        ),
                      ),

                      Image.asset("assets/images/logo2.png", height: 150.h),

                      Gaps.vGap16,

                      Text(
                        "welcome_back".tr,
                        style: TextStyles.semiBold18(),
                        textAlign: TextAlign.start,
                      ),

                      Text(
                        "login_subtitle".tr,
                        style: TextStyles.medium14(
                          color: colors.lightTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gaps.vGap20,

                      /// phone field
                      ElasticInLeft(
                        child: Row(
                          children: [
                            CountryCodeWidget(
                              country: _selectedCountry,
                              updateValue: (country) {
                                setState(() {
                                  _selectedCountry = country;
                                });
                              },
                            ),
                            Gaps.hGap8,
                            Expanded(
                              flex: 5,
                              child: MyTextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validatorType: ValidatorType.phone,
                                hintText: "phone".tr,
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: colors.main,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gaps.vGap30,

                      MultiBlocListener(
                        listeners: [
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

                                if (data.token != null &&
                                    data.token!.isNotEmpty) {
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
                                    context
                                        .read<BottomNavBarCubit>()
                                        .changeCurrentScreen(index: 0);

                                    context.pushReplacementNamed(
                                      Routes.mainPageRoute,
                                    );
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
                          BlocListener<CheckAccountCubit, CheckAccountState>(
                            listener: (context, state) {
                              if (state is CheckAccountLoading) {
                                Constants.showLoading(context);
                              } else if (state is CheckAccountSuccess) {
                                Constants.hideLoading(context);
                                if (state.exists) {
                                  final params = _pendingParams;
                                  if (params != null) {
                                    _continueLoginFlow(params);
                                  }
                                } else {
                                  Constants.showConfirmDialog(
                                    context: context,
                                    title: 'verify_confirm'.tr,

                                    content: state.message.isNotEmpty
                                        ? state.message
                                        : 'no_account'.tr,
                                    yesText: 'yes',
                                    noText: 'cancel',
                                  );
                                }
                              } else if (state is CheckAccountFailure) {
                                Constants.hideLoading(context);
                                Constants.showSnakToast(
                                  context: context,
                                  type: 3,
                                  message: state.message,
                                );
                              }
                            },
                          ),
                        ],
                        child:
                            BlocBuilder<CheckAccountCubit, CheckAccountState>(
                              builder: (context, checkState) {
                                final isChecking =
                                    checkState is CheckAccountLoading;
                                return FadeInDown(
                                  child: MyDefaultButton(
                                    btnText: 'send_code',
                                    isLoading: isChecking,
                                    onPressed: isChecking
                                        ? null
                                        : onSendCodePressed,
                                  ),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSendCodePressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final phone = await Constants.phoneParsing(
        phone: _phoneController.text,
        countryCode: _selectedCountry.countryCode,
        withCode: false,
      );

      if (phone != null) {
        final params = AuthParams(
          phoneNumber: phone,
          countryCode: '+${_selectedCountry.phoneCode}',
          userType: sessionCubit.state.userType,
          firebaseToken: firebaseToken,
        );
        if (!mounted) return;

        _pendingParams = params;

        if (sessionCubit.state.userType != UserType.patient) {
          context.read<CheckAccountCubit>().checkAccount(params);
          return;
        }

        _continueLoginFlow(params);
        return;
      }

      /// invalid phone
      if (phone == null) {
        if (!mounted) return;
        Constants.showSnakToast(
          context: context,
          type: 3,
          message: 'invalid_phone'.tr,
        );
        return;
      }
    }
  }
}

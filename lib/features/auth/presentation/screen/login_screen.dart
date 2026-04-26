// ignore_for_file: use_build_context_synchronously

import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
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

  bool isPatient = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
                      /// logo
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: colors.main,
                        child: Icon(
                          Icons.person,
                          color: colors.whiteColor,
                          size: 30,
                        ),
                      ),

                      Gaps.vGap16,

                      Text(
                        "Al-Hakim",
                        style: TextStyles.semiBold20(color: colors.main),
                      ),

                      Gaps.vGap16,

                      Text(
                        "welcome_back".tr,
                        style: TextStyles.semiBold18(),
                        textAlign: TextAlign.start,
                      ),

                      Gaps.vGap8,

                      Text(
                        "login_subtitle".tr,
                        style: TextStyles.medium14(
                          color: colors.lightTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gaps.vGap20,

                      /// patient / doctor switch
                      Container(
                        decoration: BoxDecoration(
                          color: colors.main.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isPatient = true),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: isPatient
                                        ? colors.whiteColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.r),
                                    border: isPatient
                                        ? Border.all(
                                            color: colors.main,
                                            width: 1.5,
                                          )
                                        : null,
                                    boxShadow: isPatient
                                        ? [
                                            BoxShadow(
                                              color: colors.main.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "patient".tr,
                                      style: TextStyles.medium14(
                                        color: isPatient
                                            ? colors.main
                                            : colors.lightTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isPatient = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: !isPatient
                                        ? colors.whiteColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.r),
                                    border: !isPatient
                                        ? Border.all(
                                            color: colors.main,
                                            width: 1.5,
                                          )
                                        : null,
                                    boxShadow: !isPatient
                                        ? [
                                            BoxShadow(
                                              color: colors.main.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "doctor".tr,
                                      style: TextStyles.medium14(
                                        color: !isPatient
                                            ? colors.main
                                            : colors.lightTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.vGap20,

                      /// phone field
                      MyTextFormField(
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

                      Gaps.vGap20,

                      /// button
                      BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginLoaded) {
                            final data = state.response.data as AuthEntity;

                            BlocProvider.of<SessionCubit>(
                              context,
                            ).loginSuccess(data);

                            context
                                .read<BottomNavBarCubit>()
                                .changeCurrentScreen(index: 0);

                            context.pushReplacementNamed(Routes.mainPageRoute);
                          } else if (state is LoginError) {
                            Constants.showSnakToast(
                              context: context,
                              type: 3,
                              message: state.message,
                            );
                          }
                        },
                        builder: (context, state) {
                          return MyDefaultButton(
                            btnText: "send_code",
                            isLoading: state is LoginIsLoading,
                            onPressed: () {
                              context.push(
                                Routes.otpAuthRoute,
                                extra: AuthParams(phone: _phoneController.text),
                              );
                            },
                            // onPressed: () async {
                            //   if (_formKey.currentState!.validate()) {
                            //     final phone = await Constants.phoneParsing(
                            //       phone: _phoneController.text,
                            //       withCode: false,
                            //     );

                            //     if (phone != null) {
                            //       final params = AuthParams(
                            //         phone: phone,
                            //         password: '',
                            //         fcmDeviceToken: '',
                            //       );

                            //       context.read<LoginCubit>().login(params);
                            //     }
                            //   }
                            // },
                          );
                        },
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
}

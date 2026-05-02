// ignore_for_file: deprecated_member_use, unused_field
import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/values/assets.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/core/utils/validator.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/back_button.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '../../../../core/utils/constants.dart';

class CompleteProfileRegisterScreen extends StatefulWidget {
  final AuthParams authParams;
  const CompleteProfileRegisterScreen({super.key, required this.authParams});

  @override
  State<CompleteProfileRegisterScreen> createState() =>
      _CompleteProfileRegisterScreenState();
}

class _CompleteProfileRegisterScreenState
    extends State<CompleteProfileRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController commercialNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode commercialFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final String _fullPhoneNumber = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    commercialNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    // --- DISPOSE FOCUS NODES HERE ---
    nameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    commercialFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordVisibilityCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: Center(child: CustomBackButton()),
          title: Text('complete_profile'.tr, style: TextStyles.bold16()),
          centerTitle: true,
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoaded) {
              // final data = state.response.data as AuthEntity;
              Constants.showSnakToast(
                context: context,
                type: 1,
                message: state.response.message ?? '',
              );
              // BlocProvider.of<SessionCubit>(context).loginSuccess(data);
              context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);
              context.pushReplacementNamed(Routes.mainPageRoute);
            } else if (state is RegisterError) {
              Constants.showSnakToast(
                context: context,
                message: state.message,
                type: 3,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeIn(
                      child: Center(
                        child: Image.asset(ImgAssets.logo, height: 100.h),
                      ),
                    ),
                    Gaps.vGap20,
                    ElasticInUp(
                      child: Text(
                        'complete_profile_subtitle'.tr,
                        style: TextStyles.medium16(
                          color: colors.lightTextColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Gaps.vGap20,
                    // 1. الاسم
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: MyTextFormField(
                        backgroundColor: colors.main.withValues(alpha: 0.1),
                        controller: nameController,
                        focusNode: nameFocus,
                        hintText: 'name'.tr,
                        labelText: 'name'.tr,
                        validatorType: ValidatorType.name,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: colors.main,
                        ),
                      ),
                    ),
                    Gaps.vGap16,

                    // 2. البريد الإلكتروني
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: MyTextFormField(
                        backgroundColor: colors.main.withValues(alpha: 0.1),
                        controller: emailController,
                        focusNode: emailFocus,
                        hintText: 'email'.tr,
                        labelText: 'email'.tr,
                        validatorType: ValidatorType.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colors.main,
                        ),
                      ),
                    ),

                    // Gaps.vGap16,

                    // // 3. رقم الهاتف (مع الـ Validation المحدث)
                    // FadeInDown(
                    //   duration: const Duration(milliseconds: 600),
                    //   child: CustomPhoneInput(
                    //     controller: phoneController,
                    //     focusNode: phoneFocus,
                    //     initialCountryCode: '966',
                    //     onFullPhoneChanged: (fullPhone) {
                    //       _fullPhoneNumber = fullPhone;
                    //     },
                    //   ),
                    // ),
                    Gaps.vGap16,

                    // 4. السجل التجاري
                    FadeInDown(
                      duration: const Duration(milliseconds: 700),
                      child: MyTextFormField(
                        backgroundColor: colors.main.withValues(alpha: 0.1),
                        controller: commercialNumberController,
                        focusNode: commercialFocus,
                        hintText: 'optional'.tr,
                        labelText: 'commerical_number'.tr,
                        keyboardType: TextInputType.number,
                        validatorType: null,
                        prefixIcon: Icon(
                          Icons.business_outlined,
                          color: colors.main,
                        ),
                      ),
                    ),
                    Gaps.vGap16,

                    // 5. كلمة المرور (Cubit Visibility)
                    BlocBuilder<
                      PasswordVisibilityCubit,
                      PasswordVisibilityState
                    >(
                      builder: (context, state) {
                        return FadeInDown(
                          duration: const Duration(milliseconds: 800),
                          child: MyTextFormField(
                            backgroundColor: colors.main.withValues(alpha: 0.1),
                            controller: passwordController,
                            focusNode: passwordFocus,
                            hintText: '********',
                            labelText: 'password'.tr,
                            obscureText: state.isPasswordObscure,
                            validatorType: ValidatorType.password,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: colors.main,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isPasswordObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colors.main,
                              ),
                              onPressed: () => context
                                  .read<PasswordVisibilityCubit>()
                                  .togglePasswordVisibility(),
                            ),
                          ),
                        );
                      },
                    ),
                    Gaps.vGap16,

                    // 6. تأكيد كلمة المرور (Cubit Visibility)
                    BlocBuilder<
                      PasswordVisibilityCubit,
                      PasswordVisibilityState
                    >(
                      builder: (context, state) {
                        return FadeInDown(
                          duration: const Duration(milliseconds: 900),
                          child: MyTextFormField(
                            backgroundColor: colors.main.withValues(alpha: 0.1),
                            controller: confirmPasswordController,
                            focusNode: confirmPasswordFocus,
                            hintText: '********',
                            labelText: 'confirmNewPassword'.tr,
                            obscureText: state.isConfirmObscure,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'error_valid_password_confirm'.tr;
                              }
                              return null;
                            },
                            prefixIcon: Icon(
                              Icons.lock_reset_outlined,
                              color: colors.main,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isConfirmObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colors.main,
                              ),
                              onPressed: () => context
                                  .read<PasswordVisibilityCubit>()
                                  .toggleConfirmVisibility(),
                            ),
                          ),
                        );
                      },
                    ),

                    Gaps.vGap40,

                    // زر الحفظ
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child:
                          (state is RegisterIsLoading &&
                              state.isLoading == true)
                          ? Center(child: CircularProgressIndicator())
                          : MyDefaultButton(
                              btnText: 'create_account_btn',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<RegisterCubit>(
                                    context,
                                  ).register(
                                    AuthParams(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: widget.authParams.phone,
                                      commercialNumber:
                                          commercialNumberController.text,
                                      password: passwordController.text,
                                      passwordConfirmation:
                                          confirmPasswordController.text,
                                      countryCode:
                                          widget.authParams.countryCode,
                                      fcmDeviceToken: '',
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                    Gaps.vGap20,
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

class PasswordVisibilityState {
  final bool isPasswordObscure;
  final bool isConfirmObscure;

  PasswordVisibilityState({
    required this.isPasswordObscure,
    required this.isConfirmObscure,
  });
}

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityState> {
  PasswordVisibilityCubit()
    : super(
        PasswordVisibilityState(
          isPasswordObscure: true,
          isConfirmObscure: true,
        ),
      );

  void togglePasswordVisibility() {
    emit(
      PasswordVisibilityState(
        isPasswordObscure: !state.isPasswordObscure,
        isConfirmObscure: state.isConfirmObscure,
      ),
    );
  }

  void toggleConfirmVisibility() {
    emit(
      PasswordVisibilityState(
        isPasswordObscure: state.isPasswordObscure,
        isConfirmObscure: !state.isConfirmObscure,
      ),
    );
  }
}

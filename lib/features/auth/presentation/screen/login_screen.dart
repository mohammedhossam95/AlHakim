import 'package:alhakim/config/locale/app_localizations.dart';
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
import 'package:alhakim/features/auth/domain/usecases/params/authenticate_params.dart';
import 'package:alhakim/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Country _selectedCountry;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryParser.parsePhoneCode('20');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthSuccess(AuthModel data, AuthenticateParams params) {
    if (data.token != null && data.token!.isNotEmpty) {
      secureStorage.saveAccessToken(data.token!);
    }
    sharedPreferences.saveAuth(data);

    context.read<SessionCubit>().loginSuccess(sessionCubit.state.userType);

    final isVerified = data.user?.isPhoneVerified == true;
    if (!isVerified) {
      context.push(
        Routes.otpAuthRoute,
        extra: AuthParams(
          phoneNumber: params.phoneNumber,
          countryCode: params.countryCode,
          userType: sessionCubit.state.userType,
        ),
      );
      return;
    }

    context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);
    context.go(Routes.mainPageRoute);
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = await Constants.phoneParsing(
      phone: _phoneController.text,
      countryCode: _selectedCountry.countryCode,
      withCode: false,
    );

    if (phone == null) {
      if (!mounted) return;
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: 'invalid_phone'.tr,
      );
      return;
    }

    if (!mounted) return;
    context.read<LoginCubit>().authenticate(
      AuthenticateParams(
        countryCode: '+${_selectedCountry.phoneCode}',
        phoneNumber: phone,
        password: _passwordController.text.trim(),
      ),
    );
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
            child: SingleChildScrollView(
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
                      Image.asset('assets/images/logo2.png', height: 150.h),
                      Gaps.vGap16,
                      Text('welcome_back'.tr, style: TextStyles.semiBold18()),
                      Text(
                        'login_subtitle'.tr,
                        style: TextStyles.medium14(
                          color: colors.lightTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.vGap20,
                      ElasticInLeft(
                        child: Row(
                          children: [
                            CountryCodeWidget(
                              country: _selectedCountry,
                              updateValue: (country) {
                                setState(() => _selectedCountry = country);
                              },
                            ),
                            Gaps.hGap8,
                            Expanded(
                              flex: 5,
                              child: MyTextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validatorType: ValidatorType.phone,
                                hintText: 'phone'.tr,
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
                      Gaps.vGap16,
                      MyTextFormField(
                        controller: _passwordController,
                        hintText: 'password'.tr,
                        obscureText: _obscurePassword,
                        validatorType: ValidatorType.password,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colors.main,
                          size: 16,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: colors.lightTextColor,
                          ),
                        ),
                      ),
                      Gaps.vGap24,
                      BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginLoaded) {
                            Constants.showSnakToast(
                              context: context,
                              type: 1,
                              message: state.response.message ?? '',
                            );
                            final data = state.response.data as AuthModel?;
                            if (data == null) return;
                            _handleAuthSuccess(data, state.params);
                          } else if (state is LoginError) {
                            Constants.showSnakToast(
                              context: context,
                              type: 3,
                              message: state.message,
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is LoginIsLoading;
                          return MyDefaultButton(
                            btnText: 'login',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _onLoginPressed,
                          );
                        },
                      ),
                      Gaps.vGap8,
                      if (sessionCubit.state.userType == UserType.patient) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              context.pushNamed(Routes.forgotPasswordRoute);
                            },
                            child: Text(
                              'forgot_password'.tr,
                              style: TextStyles.medium12(color: colors.main),
                            ),
                          ),
                        ),
                        Gaps.vGap8,
                        TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.registerRoute);
                          },
                          child: Text(
                            'create_new_account'.tr,
                            style: TextStyles.semiBold14(color: colors.main),
                          ),
                        ),
                      ],
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

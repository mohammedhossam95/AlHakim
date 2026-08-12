import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/split_date_picker.dart';
import 'package:alhakim/features/auth/domain/usecases/params/register_params.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();

  late Country _selectedCountry;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String firebaseToken = '';

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryParser.parsePhoneCode('20');
    getFirebaseToken();
  }

  void getFirebaseToken() async {
    FirebaseMessaging.instance
        .getToken()
        .then((devicefcmToken) {
          firebaseToken = devicefcmToken ?? '';
        })
        .catchError((e) {
          firebaseToken = 'error';
        });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
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
    context.read<RegisterCubit>().register(
      RegisterParams(
        countryCode: '+${_selectedCountry.phoneCode}',
        phoneNumber: phone,
        password: _passwordController.text.trim(),
        passwordConfirmation: _confirmPasswordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDateController.text.trim(),
        firebaseToken: firebaseToken,
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
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoaded) {
                Constants.showSnakToast(
                  context: context,
                  type: 1,
                  message: state.response.message ?? '',
                );
                context.pushReplacementNamed(
                  Routes.otpAuthRoute,
                  extra: state.otpParams,
                );
              } else if (state is RegisterError) {
                Constants.showSnakToast(
                  context: context,
                  type: 3,
                  message: state.message,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is RegisterIsLoading && state.isLoading;

              return SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        Image.asset('assets/images/logo2.png', height: 120.h),
                        Gaps.vGap12,
                        Text(
                          'create_account'.tr,
                          style: TextStyles.semiBold18(),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'enter_data_to_register'.tr,
                          style: TextStyles.medium14(
                            color: colors.lightTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gaps.vGap20,
                        Row(
                          children: [
                            Expanded(
                              child: MyTextFormField(
                                controller: _firstNameController,
                                hintText: 'enter_first_name'.tr,
                                validatorType: ValidatorType.standard,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: colors.main,
                                  size: 16,
                                ),
                              ),
                            ),
                            Gaps.hGap12,
                            Expanded(
                              child: MyTextFormField(
                                controller: _lastNameController,
                                hintText: 'enter_last_name'.tr,
                                validatorType: ValidatorType.standard,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: colors.main,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gaps.vGap12,
                        SplitDatePicker(
                          controller: _birthDateController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'select_birth_date'.tr;
                            }
                            return null;
                          },
                        ),
                        Gaps.vGap12,
                        Row(
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
                        Gaps.vGap12,
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
                        Gaps.vGap12,
                        MyTextFormField(
                          controller: _confirmPasswordController,
                          hintText: 'confirm_password'.tr,
                          obscureText: _obscureConfirmPassword,
                          validatorType: ValidatorType.password,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: colors.main,
                            size: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: colors.lightTextColor,
                            ),
                          ),
                        ),
                        Gaps.vGap24,
                        MyDefaultButton(
                          btnText: 'create_account_btn',
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _onRegisterPressed,
                        ),
                        Gaps.vGap8,
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            'already_have_account'.tr,
                            style: TextStyles.medium14(color: colors.main),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/domain/usecases/params/forgot_password_params.dart';
import 'package:alhakim/features/auth/presentation/cubit/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:alhakim/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryParser.parsePhoneCode('20');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
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
    context.read<ForgotPasswordCubit>().forgotPassword(
      ForgotPasswordParams(
        countryCode: '+${_selectedCountry.phoneCode}',
        phoneNumber: phone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.vGap10,
                  const AuthAppBar(showBackButton: true),
                  Gaps.vGap40,
                  Text('forgot_password'.tr, style: TextStyles.semiBold24()),
                  Gaps.vGap10,
                  Text(
                    'forgot_password_text'.tr,
                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),
                  Gaps.vGap30,
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
                  Gaps.vGap30,
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordSuccess) {
                        Constants.showSnakToast(
                          context: context,
                          type: 1,
                          message: state.response.message ?? '',
                        );

                        if (state.nextStep == 'reset_password') {
                          context.pushNamed(
                            Routes.resetPasswordRoute,
                            extra: state.resetParams,
                          );
                        }
                      } else if (state is ForgotPasswordError) {
                        Constants.showSnakToast(
                          context: context,
                          type: 3,
                          message: state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is ForgotPasswordLoading;
                      return MyDefaultButton(
                        btnText: 'send_code',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _onSubmit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

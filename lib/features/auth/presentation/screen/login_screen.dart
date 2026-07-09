import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
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

  // bool isPatient = true;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    getCountry();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void getCountry() {
    _selectedCountry = CountryParser.parsePhoneCode('20');
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
                          onTap: () => context.pop(), //Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: colors.main,
                            size: 26,
                          ),
                        ),
                      ),

                      /// logo
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: colors.main,
                        child: Icon(
                          Icons.medical_services_outlined,
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

                      FadeInDown(
                        child: MyDefaultButton(
                          btnText: "send_code",

                          onPressed: onSendCodePressed,
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
          countryCode: "+${_selectedCountry.phoneCode}",
          userType: sessionCubit.state.userType,
        );
        if (!mounted) return;
        context.push(Routes.otpAuthRoute, extra: params);
      }

      /// invalid phone
      if (phone == null) {
        if (!mounted) return;
        Constants.showSnakToast(
          context: context,
          type: 3,
          message: "invalid_phone".tr,
        );
        return;
      }
    }
  }
}

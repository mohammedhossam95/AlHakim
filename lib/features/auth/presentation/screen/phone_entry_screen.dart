import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:animate_do/animate_do.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/values/assets.dart';
import '../../../../core/widgets/gaps.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../injection_container.dart';
import '../cubit/register_cubit/register_cubit.dart';

class PhoneEntryScreen extends StatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryParser.parsePhoneCode('966');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterLoaded) {
                  Constants.showSnakToast(
                    context: context,
                    message: state.response.message,
                    type: 1,
                  );
                  context.pushNamed(Routes.otpAuthRoute, extra: state.params);
                } else if (state is RegisterError) {
                  Constants.showSnakToast(
                    context: context,
                    message: state.message,
                    type: 3,
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeIn(
                        child: Center(
                          child: Image.asset(ImgAssets.logo, height: 180.h),
                        ),
                      ),
                      Gaps.vGap50,
                      FadeInUp(
                        delay: Duration(milliseconds: 400),
                        child: Text(
                          'enter_phone'.tr,
                          style: TextStyles.bold16().copyWith(
                            color: colors.textColor,
                          ),
                        ),
                      ),
                      Gaps.vGap16,
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                        child: Text(
                          'phone_subtitle'.tr,
                          style: TextStyles.semiBold14()
                              .copyWith(
                                color: colors.lightTextColor.withValues(
                                  alpha: 0.6,
                                ),
                              )
                              .copyWith(height: 1.5),
                        ),
                      ),
                      Gaps.vGap30,
                      ElasticInLeft(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            // جزء حقل إدخال الرقم
                            Expanded(
                              flex: 5,
                              child: MyTextFormField(
                                backgroundColor: colors.main.withValues(
                                  alpha: 0.1,
                                ),
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                validatorType: ValidatorType.phone,
                                hintText: 'enter_phone'.tr,
                                labelText: 'enter_phone'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.vGap50,
                      FadeInUp(
                        delay: Duration(milliseconds: 600),
                        child: (state is RegisterIsLoading)
                            ? Center(child: CircularProgressIndicator())
                            : MyDefaultButton(
                                btnText: 'send_code_btn',
                                onPressed: _handleSendCode,
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String? phoneNum = await Constants.phoneParsing(
          phone: _phoneController.text,
          countryCode: _selectedCountry.countryCode,
          withCode: false,
        );

        if (phoneNum != null) {
          if (!mounted) return;
          BlocProvider.of<RegisterCubit>(context).register(
            AuthParams(
              phone: phoneNum,
              registerType: 'withPhone',
              countryCode: _selectedCountry.phoneCode,
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Constants.showSnakToast(
              type: 2,
              context: context,
              message: 'invalidPhoneText'.tr,
            ),
          );
        }
      } on PlatformException catch (e) {
        debugPrint(e.toString());
        if (!mounted) return;
        Constants.showSnakToast(
          type: 2,
          context: context,
          message: e.message ?? 'invalidPhoneText'.tr,
        );
      }
    }
  }
}

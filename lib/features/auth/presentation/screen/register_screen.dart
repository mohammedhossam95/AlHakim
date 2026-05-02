import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/injection_container.dart';
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

  final _nameController = TextEditingController();
  final _specialityController = TextEditingController();
  final _commercialController = TextEditingController();
  final _codeController = TextEditingController();
  String? selectedSpeciality;

  final List<String> specialities = [
    "باطنة",
    "أسنان",
    "جلدية",
    "عظام",
    "أطفال",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _specialityController.dispose();
    _commercialController.dispose();
    _codeController.dispose();
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [CustomBackButton()],
                  ),

                  // Gaps.vGap20,

                  /// icon
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: colors.whiteColor,
                    child: Icon(
                      Icons.medical_services,
                      color: colors.main,
                      size: 30,
                    ),
                  ),

                  Gaps.vGap16,

                  Text(
                    "create_doctor_account".tr,
                    style: TextStyles.semiBold18(),
                  ),

                  // Gaps.vGap8,

                  // Text(
                  //   "join_network".tr,
                  //   style: TextStyles.medium14(color: colors.lightTextColor),
                  // ),
                  Gaps.vGap20,

                  /// card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// image
                        Center(
                          child: Container(
                            height: 100.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.main.withValues(alpha: .3),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Icon(Icons.camera_alt, color: colors.main),
                          ),
                        ),

                        Gaps.vGap10,

                        Center(
                          child: Text(
                            "add_profile_image".tr,
                            style: TextStyles.medium14(color: colors.main),
                          ),
                        ),

                        Gaps.vGap20,

                        /// name
                        buildLabel("doctor_name".tr),
                        Gaps.vGap8,
                        MyTextFormField(
                          controller: _nameController,
                          hintText: "doctor_name_hint".tr,
                          prefixIcon: Icon(Icons.person, color: colors.main),
                        ),

                        Gaps.vGap16,

                        /// speciality
                        buildLabel("speciality".tr),
                        Gaps.vGap8,
                        DropdownButtonFormField<String>(
                          initialValue: selectedSpeciality,
                          isExpanded: true,

                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.medical_services,
                              color: colors.main,
                            ),
                            filled: true,
                            fillColor: colors.main.withValues(alpha: 0.05),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: colors.main),
                            ),
                          ),
                          hint: Text(
                            "speciality_hint".tr,
                            style: TextStyles.medium12(
                              color: colors.lightTextColor,
                            ),
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: colors.main,
                          ),
                          items: specialities
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: TextStyles.medium14()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedSpeciality = value);
                          },
                        ),

                        Gaps.vGap16,

                        /// commercial
                        buildLabel("commercial_number".tr),
                        Gaps.vGap8,
                        MyTextFormField(
                          controller: _commercialController,
                          hintText: "commercial_number_hint".tr,
                          prefixIcon: Icon(
                            Icons.business_center,
                            color: colors.main,
                          ),
                        ),

                        Gaps.vGap16,

                        /// code
                        buildLabel("represent_code".tr),
                        Gaps.vGap8,
                        MyTextFormField(
                          controller: _codeController,
                          hintText: "represent_code_hint".tr,
                          prefixIcon: Icon(Icons.numbers, color: colors.main),
                        ),

                        Gaps.vGap8,

                        Row(
                          children: [
                            Icon(Icons.info, color: colors.main, size: 18.sp),
                            Gaps.hGap8,
                            Text(
                              "represent_code_hint_text".tr,
                              style: TextStyles.medium10( 
                                color: colors.lightTextColor,
                              ),
                            ),
                          ],
                        ),

                        Gaps.vGap20,

                        /// button
                        BlocBuilder<RegisterCubit, RegisterState>(
                          builder: (context, state) {
                            return state is RegisterIsLoading
                                ? const LoadingView()
                                : MyDefaultButton(
                                    btnText: "complete_register",

                                    onPressed: () {
                                      context.push(Routes.mainPageRoute);
                                      // if (_formKey.currentState!.validate()) {
                                      //   final params = AuthParams(
                                      //     name: _nameController.text,
                                      //     commercialNumber:
                                      //         _commercialController.text,
                                      //     representCode: _codeController.text,
                                      //     userType: "doctor",
                                      //   );

                                      //   context.read<RegisterCubit>().register(
                                      //     params,
                                      //   );
                                      // }
                                    },
                                  );
                          },
                        ),

                        Gaps.vGap10,

                        Text(
                          "terms_hint".tr,
                          textAlign: TextAlign.center,
                          style: TextStyles.medium12(
                            color: colors.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gaps.vGap20,

                  /// bottom cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildBottomCard(
                          Icons.security,
                          "high_security".tr,
                          colors.success,
                        ),
                      ),
                      Gaps.hGap10,
                      Expanded(
                        child: _buildBottomCard(
                          Icons.analytics,
                          "smart_management".tr,
                          colors.main,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCard(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          Gaps.vGap8,
          Text(text, style: TextStyles.medium14()),
        ],
      ),
    );
  }
}

Widget buildLabel(String text) {
  return Text(text, style: TextStyles.medium14(color: colors.textColor));
}

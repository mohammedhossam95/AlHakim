// ignore_for_file: deprecated_member_use, unused_field
import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/assets.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/split_date_picker.dart';
import 'package:alhakim/features/auth/presentation/cubit/complete_profile_cubit/complete_profile_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';

class CompleteProfileRegisterScreen extends StatefulWidget {
  // final AuthParams authParams;
  const CompleteProfileRegisterScreen({super.key});

  @override
  State<CompleteProfileRegisterScreen> createState() =>
      _CompleteProfileRegisterScreenState();
}

class _CompleteProfileRegisterScreenState
    extends State<CompleteProfileRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final locationController = TextEditingController();

  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final birthDateFocus = FocusNode();
  final heightFocus = FocusNode();
  final weightFocus = FocusNode();
  final locationFocus = FocusNode();

  String? selectedBloodType;

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    heightController.dispose();
    weightController.dispose();
    locationController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    birthDateFocus.dispose();
    heightFocus.dispose();
    weightFocus.dispose();
    locationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('complete_profile'.tr, style: TextStyles.bold16()),
      ),
      body: BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileLoading) {
            Constants.showLoading(context);
          }

          if (state is CompleteProfileSuccess) {
            Constants.hideLoading(context);

            sharedPreferences.saveAuth(state.response.data!);
            context.read<SessionCubit>().loginSuccess(
              sessionCubit.state.userType,
            );
            Constants.showSnakToast(
              context: context,
              type: 1,
              message: state.response.message,
            );

            context.go(Routes.mainPageRoute);
          }

          if (state is CompleteProfileError) {
            Constants.hideLoading(context);

            Constants.showSnakToast(
              context: context,
              type: 3,
              message: state.message,
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
                  /// First Name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "first_name".tr,
                              style: TextStyles.semiBold14(),
                            ),
                            Gaps.vGap8,

                            MyTextFormField(
                              controller: firstNameController,
                              focusNode: firstNameFocus,
                              hintText: "enter_first_name".tr,

                              // validatorType: ValidatorType.name,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: colors.main,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.hGap16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Last Name
                            Text(
                              "last_name".tr,
                              style: TextStyles.semiBold14(),
                            ),

                            Gaps.vGap8,

                            MyTextFormField(
                              controller: lastNameController,
                              focusNode: lastNameFocus,
                              hintText: "enter_last_name".tr,
                              // validatorType: ValidatorType.name,
                              // backgroundColor: colors.main.withValues(alpha: .1),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: colors.main,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Gaps.vGap16,

                  /// Birth Date
                  Text("birth_date".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  SplitDatePicker(controller: birthDateController),

                  Gaps.vGap16,

                  /// Height
                  // Text("height".tr, style: TextStyles.semiBold14()),

                  // Gaps.vGap8,

                  // MyTextFormField(
                  //   controller: heightController,
                  //   focusNode: heightFocus,
                  //   hintText: "enter_height".tr,
                  //   keyboardType: TextInputType.number,
                  //   backgroundColor: colors.main.withValues(alpha: .1),
                  //   prefixIcon: Icon(Icons.height, color: colors.main),
                  // ),

                  // Gaps.vGap16,

                  /// Weight
                  // Text("weight".tr, style: TextStyles.semiBold14()),

                  // Gaps.vGap8,

                  // MyTextFormField(
                  //   controller: weightController,
                  //   focusNode: weightFocus,
                  //   hintText: "enter_weight".tr,
                  //   keyboardType: TextInputType.number,
                  //   backgroundColor: colors.main.withValues(alpha: .1),
                  //   prefixIcon: Icon(
                  //     Icons.monitor_weight_outlined,
                  //     color: colors.main,
                  //   ),
                  // ),

                  // Gaps.vGap16,

                  /// Blood Type
                  // Text("blood_type".tr),

                  // Gaps.vGap8,

                  // DropdownButtonFormField<String>(
                  //   value: selectedBloodType,
                  //   decoration: InputDecoration(
                  //     label: Text("select_blood_type".tr),
                  //     labelStyle: TextStyles.semiBold12(),
                  //     prefixIcon: Icon(
                  //       Icons.bloodtype_outlined,
                  //       color: colors.main,
                  //     ),
                  //     floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     filled: true,
                  //     fillColor: colors.main.withValues(alpha: .1),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(16.r),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   items: bloodTypes
                  //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedBloodType = value;
                  //     });
                  //   },
                  // ),

                  // Gaps.vGap16,

                  /// Location
                  // Text("location".tr, style: TextStyles.semiBold14()),

                  // Gaps.vGap8,

                  // MyTextFormField(
                  //   controller: locationController,
                  //   focusNode: locationFocus,
                  //   hintText: "enter_location".tr,
                  //   backgroundColor: colors.main.withValues(alpha: .1),
                  //   prefixIcon: Icon(
                  //     Icons.location_on_outlined,
                  //     color: colors.main,
                  //   ),
                  // ),
                  Gaps.vGap16,
                  PrivacyNoticeCard(),
                  Gaps.vGap40,

                  MyDefaultButton(
                    btnText: "save",

                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      // if (selectedBloodType == null) {
                      //   Constants.showSnakToast(
                      //     context: context,
                      //     type: 3,
                      //     message: "choose_blood_type".tr,
                      //   );
                      //   return;
                      // }

                      context.read<CompleteProfileCubit>().completeProfile(
                        params: CompleteProfileParams(
                          firstName: firstNameController.text,

                          lastName: lastNameController.text,

                          birthDate: birthDateController.text,

                          // tall: heightController.text,

                          // weight: weightController.text,

                          // bloodType: selectedBloodType,

                          // location: locationController.text,
                        ),
                      );
                    },
                  ),

                  Gaps.vGap20,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PrivacyNoticeCard extends StatelessWidget {
  final String title;
  final String body;

  const PrivacyNoticeCard({
    super.key,
    this.title = 'خصوصية بياناتك أولويتنا',
    this.body =
        'تشفّر بياناتك الشخصية بالكامل ولا يتم مشاركتها إلا مع الكادر الطبي المصرح له خلال المواعيد.',
  });

  // Palette pulled from the design.
  static const _cardBg = Color(0xFFE3F3EC);
  static const _iconBoxBg = Color(0xFFA9DCC8);
  static const _accentTeal = Color(0xFF2E8B7C);
  static const _bodyText = Color(0xFF8CA39C);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box (sits on the right in RTL because it's the first child).
          Container(
            width: 46,
            height: 46,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: _iconBoxBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(
              ImgAssets.privacyNoticeImage,
              color: _accentTeal,
              width: 24.w,
              height: 24.h,
            ),
          ),
          Gaps.hGap16,
          // Text column.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyles.semiBold14(color: _accentTeal),
                ),
                Gaps.vGap10,
                Text(
                  body,
                  textAlign: TextAlign.right,
                  style: TextStyles.regular12(color: _bodyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, unused_field
import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
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
                  Text("first_name".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: firstNameController,
                    focusNode: firstNameFocus,
                    hintText: "enter_first_name".tr,
                    // validatorType: ValidatorType.name,
                    backgroundColor: colors.main.withValues(alpha: .1),
                    prefixIcon: Icon(Icons.person_outline, color: colors.main),
                  ),

                  Gaps.vGap16,

                  /// Last Name
                  Text("last_name".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: lastNameController,
                    focusNode: lastNameFocus,
                    hintText: "enter_last_name".tr,
                    // validatorType: ValidatorType.name,
                    backgroundColor: colors.main.withValues(alpha: .1),
                    prefixIcon: Icon(Icons.person_outline, color: colors.main),
                  ),

                  Gaps.vGap16,

                  /// Birth Date
                  Text("birth_date".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: birthDateController,
                    focusNode: birthDateFocus,
                    readOnly: true,
                    hintText: "select_birth_date".tr,
                    backgroundColor: colors.main.withValues(alpha: .1),
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: colors.main,
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );

                      if (date != null) {
                        birthDateController.text =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),

                  Gaps.vGap16,

                  /// Height
                  Text("height".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: heightController,
                    focusNode: heightFocus,
                    hintText: "enter_height".tr,
                    keyboardType: TextInputType.number,
                    backgroundColor: colors.main.withValues(alpha: .1),
                    prefixIcon: Icon(Icons.height, color: colors.main),
                  ),

                  Gaps.vGap16,

                  /// Weight
                  Text("weight".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: weightController,
                    focusNode: weightFocus,
                    hintText: "enter_weight".tr,
                    keyboardType: TextInputType.number,
                    backgroundColor: colors.main.withValues(alpha: .1),
                    prefixIcon: Icon(
                      Icons.monitor_weight_outlined,
                      color: colors.main,
                    ),
                  ),

                  Gaps.vGap16,

                  /// Blood Type
                  Text("blood_type".tr),

                  Gaps.vGap8,

                  DropdownButtonFormField<String>(
                    value: selectedBloodType,
                    decoration: InputDecoration(
                      label: Text("select_blood_type".tr),
                      labelStyle: TextStyles.semiBold12(),
                      prefixIcon: Icon(
                        Icons.bloodtype_outlined,
                        color: colors.main,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: colors.main.withValues(alpha: .1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: bloodTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBloodType = value;
                      });
                    },
                  ),

                  Gaps.vGap16,

                  /// Location
                  Text("location".tr, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  MyTextFormField(
                    controller: locationController,
                    focusNode: locationFocus,
                    hintText: "enter_location".tr,
                    backgroundColor: colors.main.withValues(alpha: .1),
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: colors.main,
                    ),
                  ),

                  Gaps.vGap40,

                  MyDefaultButton(
                    btnText: "save",

                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (selectedBloodType == null) {
                        Constants.showSnakToast(
                          context: context,
                          type: 3,
                          message: "choose_blood_type".tr,
                        );
                        return;
                      }

                      context.read<CompleteProfileCubit>().completeProfile(
                        params: CompleteProfileParams(
                          firstName: firstNameController.text,

                          lastName: lastNameController.text,

                          birthDate: birthDateController.text,

                          tall: heightController.text,

                          weight: weightController.text,

                          bloodType: selectedBloodType,

                          location: locationController.text,
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

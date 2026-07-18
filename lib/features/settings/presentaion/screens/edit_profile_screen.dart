import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/split_date_picker.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/update_user_profile_cubit/update_user_profile_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final locationController = TextEditingController();
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final heightFocus = FocusNode();
  final weightFocus = FocusNode();
  final locationFocus = FocusNode();

  String? selectedBloodType;
  String? selectedGender;
  late UserEntity user;

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

  final List<Map<String, String>> genders = [
    {'value': 'male', 'labelKey': 'male'},
    {'value': 'female', 'labelKey': 'female'},
  ];

  @override
  void initState() {
    super.initState();
    user = sharedPreferences.getAuth()!.user!;
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    birthDateController.text = user.birthDate ?? '';
    heightController.text = user.tall ?? '';
    weightController.text = user.weight ?? '';
    locationController.text = user.location ?? '';
    selectedBloodType = user.bloodType;
    selectedGender = user.gender;
  }

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
    heightFocus.dispose();
    weightFocus.dispose();
    locationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('editMyProfile'.tr, style: TextStyles.bold16()),
      ),
      body: BlocListener<UpdateUserProfileCubit, UpdateUserProfileState>(
        listener: (context, state) async {
          if (state is UpdateUserProfileError) {
            Constants.showSnakToast(
              context: context,
              type: 3,
              message: state.message,
            );
          } else if (state is UpdateUserProfileLoaded) {
            Constants.showSnakToast(
              context: context,
              type: 1,
              message: "profile_updated_successfully".tr,
            );

            final updatedUser = state.response as UserEntity;

            final currentAuth = sharedPreferences.getAuth();

            if (currentAuth != null) {
              await sharedPreferences.saveAuth(
                AuthModel(
                  token: currentAuth.token,
                  doctor: currentAuth.doctor,
                  nextStep: currentAuth.nextStep,
                  user: UserModel(
                    id: updatedUser.id,
                    firstName: updatedUser.firstName,
                    lastName: updatedUser.lastName,
                    phoneNumber: updatedUser.phoneNumber,
                    countryCode: updatedUser.countryCode,
                    birthDate: updatedUser.birthDate,
                    isPhoneVerified: updatedUser.isPhoneVerified,
                    profilePhotoUrl: updatedUser.profilePhotoUrl,
                    referralCode: updatedUser.referralCode,
                    tall: updatedUser.tall,
                    weight: updatedUser.weight,
                    bloodType: updatedUser.bloodType,
                    gender: updatedUser.gender,
                    location: updatedUser.location,
                  ),
                ),
              );
              log(sharedPreferences.getAuth()?.user?.firstName ?? 'No user');
              log(sharedPreferences.getAuth()?.user?.location ?? 'No location');
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// First Name + Last Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("first_name".tr, style: TextStyles.semiBold14()),
                          Gaps.vGap8,
                          MyTextFormField(
                            controller: firstNameController,
                            focusNode: firstNameFocus,
                            hintText: "enter_first_name".tr,
                            validatorType: ValidatorType.standard,
                            backgroundColor: colors.main.withValues(alpha: .1),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: colors.main,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("last_name".tr, style: TextStyles.semiBold14()),
                          Gaps.vGap8,
                          MyTextFormField(
                            controller: lastNameController,
                            focusNode: lastNameFocus,
                            hintText: "enter_last_name".tr,
                            validatorType: ValidatorType.standard,
                            backgroundColor: colors.main.withValues(alpha: .1),
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

                /// Height + Weight
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("height".tr, style: TextStyles.semiBold14()),
                          Gaps.vGap8,
                          MyTextFormField(
                            controller: heightController,
                            focusNode: heightFocus,
                            hintText: "enter_height".tr,
                            keyboardType: TextInputType.number,
                            validatorType: ValidatorType.numbersOnly,
                            backgroundColor: colors.main.withValues(alpha: .1),
                            prefixIcon: Icon(Icons.height, color: colors.main),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("weight".tr, style: TextStyles.semiBold14()),
                          Gaps.vGap8,
                          MyTextFormField(
                            controller: weightController,
                            focusNode: weightFocus,
                            hintText: "enter_weight".tr,
                            keyboardType: TextInputType.number,
                            validatorType: ValidatorType.numbersOnly,
                            backgroundColor: colors.main.withValues(alpha: .1),
                            prefixIcon: Icon(
                              Icons.monitor_weight_outlined,
                              color: colors.main,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Gaps.vGap16,

                /// Gender + Blood Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("gender".tr, style: TextStyles.semiBold14()),
                          Gaps.vGap8,
                          DropdownButtonFormField<String>(
                            initialValue: selectedGender,
                            validator: (value) {
                              if (value == null) {
                                return "select_gender".tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              label: Text("select_gender".tr),
                              labelStyle: TextStyles.semiBold12(),
                              prefixIcon: Icon(
                                Icons.wc_outlined,
                                color: colors.main,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: colors.main.withValues(alpha: .1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: genders
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e['value'],
                                    child: Text(e['labelKey']!.tr),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Gaps.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("blood_type".tr, style: TextStyles.semiBold14()),
                          Gaps.vGap8,
                          DropdownButtonFormField<String>(
                            initialValue: selectedBloodType,
                            validator: (value) {
                              if (value == null) {
                                return "select_blood_type".tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              label: Text("select_blood_type".tr),
                              labelStyle: TextStyles.semiBold12(),
                              prefixIcon: Icon(
                                Icons.bloodtype_outlined,
                                color: colors.main,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              fillColor: colors.main.withValues(alpha: .1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: bloodTypes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedBloodType = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Gaps.vGap16,

                /// Location
                // Text("location".tr, style: TextStyles.semiBold14()),

                // Gaps.vGap8,

                // MyTextFormField(
                //   controller: locationController,
                //   focusNode: locationFocus,
                //   hintText: "enter_location".tr,
                //   validatorType: ValidatorType.standard,
                //   backgroundColor: colors.main.withValues(alpha: .1),
                //   prefixIcon: Icon(
                //     Icons.location_on_outlined,
                //     color: colors.main,
                //   ),
                // ),
                Gaps.vGap40,

                BlocBuilder<UpdateUserProfileCubit, UpdateUserProfileState>(
                  builder: (context, state) {
                    return state is UpdateUserProfileIsLoading
                        ? const LoadingView()
                        : MyDefaultButton(
                            btnText: "save",

                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              if (selectedGender == null) {
                                Constants.showSnakToast(
                                  context: context,
                                  type: 3,
                                  message: "select_gender".tr,
                                );
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

                              context
                                  .read<UpdateUserProfileCubit>()
                                  .updateUserProfile(
                                    CompleteProfileParams(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      birthDate: birthDateController.text,
                                      tall: heightController.text,
                                      weight: weightController.text,
                                      bloodType: selectedBloodType!,
                                      gender: selectedGender!,
                                      location: locationController.text,
                                    ),
                                  );
                            },
                          );
                  },
                ),

                Gaps.vGap20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

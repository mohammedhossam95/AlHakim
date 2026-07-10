import 'dart:io';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/presentation/cubit/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialties_cubit/get_specialties_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorScheduleModel {
  int? dayOfWeek;

  final startTimeController = TextEditingController();

  final endTimeController = TextEditingController();

  final slotDurationController = TextEditingController();

  DoctorScheduleModel();
}

class AddNewDoctorScreen extends StatefulWidget {
  final DoctorFormSource source;
  final int? medicalCenterId;

  const AddNewDoctorScreen({
    super.key,
    this.source = DoctorFormSource.delegate,
    this.medicalCenterId,
  });

  @override
  State<AddNewDoctorScreen> createState() => _AddNewDoctorScreenState();
}

class _AddNewDoctorScreenState extends State<AddNewDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<DoctorScheduleModel> schedules = [DoctorScheduleModel()];

  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();

  final _bioArController = TextEditingController();
  final _bioEnController = TextEditingController();

  final _professionalNumberController = TextEditingController();
  final _academicDegreeController = TextEditingController();

  // final _clinicPhoneController = TextEditingController();
  final _secretaryPhoneController = TextEditingController();

  final _minPatientsController = TextEditingController();
  final _priceController = TextEditingController();

  final _representativeCodeController = TextEditingController();

  final _nameArFocus = FocusNode();
  final _nameEnFocus = FocusNode();

  final _bioArFocus = FocusNode();
  final _bioEnFocus = FocusNode();

  final _professionalNumberFocus = FocusNode();
  final _academicDegreeFocus = FocusNode();

  final _clinicPhoneFocus = FocusNode();
  final _secretaryPhoneFocus = FocusNode();

  final _minPatientsFocus = FocusNode();
  final _priceFocus = FocusNode();

  final _representativeCodeFocus = FocusNode();
  bool hidePrice = false;

  SpecialtyEntity? selectedSpeciality;
  final List<Map<String, dynamic>> weekDays = [
    {"title": "الأحد", "value": 0},
    {"title": "الإثنين", "value": 1},
    {"title": "الثلاثاء", "value": 2},
    {"title": "الأربعاء", "value": 3},
    {"title": "الخميس", "value": 4},
    {"title": "الجمعة", "value": 5},
    {"title": "السبت", "value": 6},
  ];
  File? profileImage;
  File? licenseFile;
  Future<void> pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');

      final minute = picked.minute.toString().padLeft(2, '0');

      controller.text = "$hour:$minute";
    }
  }

  late Country _selectedCountry;
  void getCountry() {
    _selectedCountry = CountryParser.parsePhoneCode('20');
  }

  @override
  void initState() {
    super.initState();
    getCountry();
    context.read<GetSpecialtiesCubit>().getSpecialties();
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();

    _bioArController.dispose();
    _bioEnController.dispose();

    _professionalNumberController.dispose();
    _academicDegreeController.dispose();

    // _clinicPhoneController.dispose();
    _secretaryPhoneController.dispose();

    _minPatientsController.dispose();
    _priceController.dispose();

    _representativeCodeController.dispose();

    _nameArFocus.dispose();
    _nameEnFocus.dispose();

    _bioArFocus.dispose();
    _bioEnFocus.dispose();

    _professionalNumberFocus.dispose();
    _academicDegreeFocus.dispose();

    _clinicPhoneFocus.dispose();
    _secretaryPhoneFocus.dispose();

    _minPatientsFocus.dispose();
    _priceFocus.dispose();

    _representativeCodeFocus.dispose();

    super.dispose();
  }

  Future<void> pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        profileImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> pickLicenseFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        licenseFile = File(result.files.single.path!);
      });
    }
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final secretaryPhone = await Constants.phoneParsing(
        phone: _secretaryPhoneController.text,
        countryCode: _selectedCountry.countryCode,
        withCode: false,
      );
      // final clinicPhone = await Constants.phoneParsing(
      //   phone: _clinicPhoneController.text,
      //   countryCode: _selectedCountry.countryCode,
      //   withCode: false,
      // );

      if (!context.mounted) return;
      final isMedicalCenterSource =
          widget.source == DoctorFormSource.medicalCenter;
      if (!mounted) return;
      context.read<AddDoctorCubit>().addDoctor(
        AddDoctorParams(
          nameAr: _nameArController.text,
          nameEn: _nameEnController.text,
          bioAr: _bioArController.text,
          bioEn: _bioEnController.text,
          specialtyId: selectedSpeciality?.id,
          professionalRegistrationNumber: _professionalNumberController.text,
          academicDegree: _academicDegreeController.text,
          clinicPhone: secretaryPhone,
          secretaryPhone: secretaryPhone,
          minPatients: _minPatientsController.text,
          price: _priceController.text,
          representativeCode: isMedicalCenterSource
              ? null
              : _representativeCodeController.text,
          medicalCenterId: isMedicalCenterSource
              ? widget.medicalCenterId
              : null,
          profileImage: profileImage,
          license: licenseFile,
          schedules: schedules.map((e) {
            return {
              "day_of_week": e.dayOfWeek,

              "start_time": e.startTimeController.text,

              "end_time": e.endTimeController.text,

              "slot_duration": e.slotDurationController.text,
            };
          }).toList(),
          secretaryCountryCode: "+${_selectedCountry.phoneCode}",
          clinicCountryCode: "+${_selectedCountry.phoneCode}",
          hidePrice: hidePrice,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      appBar: AppBar(title: Text("add_doctor".tr)),

      body: BlocConsumer<AddDoctorCubit, AddDoctorState>(
        listener: (context, state) {
          if (state is AddDoctorSuccess) {
            Constants.showSnakToast(
              context: context,
              message: state.response.message,
              type: 1,
            );

            context.pop(true);
            // BlocProvider.of<GetDoctorsCubit>(context).getDoctors();
          }

          if (state is AddDoctorError) {
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

            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),

              child: Container(
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
                      child: GestureDetector(
                        onTap: pickProfileImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundColor: colors.main.withValues(
                                alpha: .08,
                              ),
                              backgroundImage: profileImage != null
                                  ? FileImage(profileImage!)
                                  : null,
                              child: profileImage == null
                                  ? Icon(
                                      Icons.person,
                                      size: 40.sp,
                                      color: colors.main,
                                    )
                                  : null,
                            ),

                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: colors.main,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: colors.whiteColor,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gaps.vGap10,

                    Center(
                      child: Text(
                        "upload_profile_image".tr,
                        style: TextStyles.medium14(color: colors.main),
                      ),
                    ),

                    Gaps.vGap24,

                    /// ar name
                    buildLabel("doctor_name".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _nameArController,
                      focusNode: _nameArFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        FocusScope.of(context).requestFocus(_nameEnFocus);
                      },
                      hintText: "enter_doctor_name".tr,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: colors.main,
                      ),
                    ),

                    Gaps.vGap16,

                    /// en name
                    buildLabel("doctor_name_en".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _nameEnController,
                      focusNode: _nameEnFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        FocusScope.of(context).requestFocus(_bioArFocus);
                      },
                      hintText: "enter_doctor_name_en".tr,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: colors.main,
                      ),
                    ),

                    Gaps.vGap16,

                    /// ar bio
                    buildLabel("doctor_bio".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _bioArController,
                      focusNode: _bioArFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        FocusScope.of(context).requestFocus(_bioEnFocus);
                      },
                      hintText: "enter_doctor_bio".tr,
                      prefixIcon: Icon(Icons.info_outline, color: colors.main),
                    ),

                    Gaps.vGap16,

                    /// en bio
                    buildLabel("doctor_bio_en".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _bioEnController,
                      focusNode: _bioEnFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_professionalNumberFocus);
                      },
                      hintText: "enter_doctor_bio_en".tr,
                      prefixIcon: Icon(Icons.translate, color: colors.main),
                    ),

                    Gaps.vGap16,

                    /// speciality
                    buildLabel("speciality".tr),
                    Gaps.vGap8,

                    BlocBuilder<GetSpecialtiesCubit, GetSpecialtiesState>(
                      builder: (context, state) {
                        if (state is GetSpecialtiesLoading) {
                          return SizedBox(
                            height: 55.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is GetSpecialtiesSuccess) {
                          final specialties =
                              state.response.data as List<SpecialtyEntity>;

                          return DropdownButtonFormField<SpecialtyEntity>(
                            initialValue:
                                specialties.contains(selectedSpeciality)
                                ? selectedSpeciality
                                : null,
                            isExpanded: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.medical_services_outlined,
                                color: colors.main,
                              ),
                              filled: true,
                              fillColor: colors.main.withValues(alpha: .05),
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
                              "choose_speciality".tr,
                              style: TextStyles.medium14(
                                color: colors.lightTextColor,
                              ),
                            ),
                            items: specialties
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name ?? '',
                                      style: TextStyles.medium14(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSpeciality = value;
                              });
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),

                    Gaps.vGap16,

                    /// professional number
                    buildLabel("professional_registration_number".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _professionalNumberController,
                      focusNode: _professionalNumberFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_academicDegreeFocus);
                      },
                      keyboardType: TextInputType.number,
                      hintText: "enter_professional_registration_number".tr,
                      prefixIcon: Icon(
                        Icons.workspace_premium_outlined,
                        color: colors.main,
                      ),
                    ),

                    Gaps.vGap16,

                    /// academic degree
                    buildLabel("academic_degree".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _academicDegreeController,
                      focusNode: _academicDegreeFocus,
                      textInputAction: TextInputAction.next,

                      hintText: "enter_academic_degree".tr,
                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color: colors.main,
                      ),
                    ),

                    // /// clinic phone
                    // buildLabel("clinic_phone".tr),
                    // Gaps.vGap8,

                    // Row(
                    //   children: [
                    //     CountryCodeWidget(
                    //       country: _selectedCountry,
                    //       updateValue: (country) {
                    //         setState(() {
                    //           _selectedCountry = country;
                    //         });
                    //       },
                    //     ),
                    //     Gaps.hGap8,
                    //     Expanded(
                    //       flex: 5,
                    //       child: MyTextFormField(
                    //         controller: _clinicPhoneController,
                    //         focusNode: _clinicPhoneFocus,
                    //         textInputAction: TextInputAction.next,
                    //         onSubmit: (_) {
                    //           FocusScope.of(
                    //             context,
                    //           ).requestFocus(_secretaryPhoneFocus);
                    //         },
                    //         keyboardType: TextInputType.phone,
                    //         hintText: "enter_clinic_phone".tr,
                    //         prefixIcon: Icon(
                    //           Icons.local_hospital_outlined,
                    //           color: colors.main,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // Gaps.vGap16,
                    if (widget.source == DoctorFormSource.delegate) ...[
                      Gaps.vGap16,

                      /// secretary phone
                      buildLabel("clinic_phone".tr),
                      Gaps.vGap8,

                      Row(
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
                              controller: _secretaryPhoneController,
                              focusNode: _secretaryPhoneFocus,
                              textInputAction: TextInputAction.next,
                              onSubmit: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_minPatientsFocus);
                              },
                              keyboardType: TextInputType.phone,
                              hintText: "enter_secretary_phone".tr,
                              prefixIcon: Icon(
                                Icons.support_agent_outlined,
                                color: colors.main,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    Gaps.vGap16,

                    /// min patients
                    buildLabel("min_patients".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _minPatientsController,
                      focusNode: _minPatientsFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      keyboardType: TextInputType.number,
                      hintText: "enter_min_patients".tr,
                      prefixIcon: Icon(
                        Icons.groups_outlined,
                        color: colors.main,
                      ),
                    ),

                    Gaps.vGap16,

                    /// price
                    buildLabel("price".tr),
                    Gaps.vGap8,

                    MyTextFormField(
                      controller: _priceController,
                      focusNode: _priceFocus,
                      textInputAction: TextInputAction.next,
                      onSubmit: (_) {
                        if (widget.source == DoctorFormSource.delegate) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_representativeCodeFocus);
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      hintText: "enter_price".tr,
                      prefixIcon: Icon(
                        Icons.payments_outlined,
                        color: colors.main,
                      ),
                    ),

                    Gaps.vGap8,

                    /// description
                    // buildLabel("hide_price_to_patients".tr),
                    // Gaps.vGap8,
                    Row(
                      children: [
                        Checkbox(
                          activeColor: colors.main,
                          value: hidePrice,
                          onChanged: (value) {
                            setState(() {
                              hidePrice = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "hide_price_to_patients_desc".tr,
                            style: TextStyles.medium14(),
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap16,

                    if (widget.source == DoctorFormSource.delegate) ...[
                      /// representative code
                      buildLabel("representative_code".tr),
                      Gaps.vGap8,

                      MyTextFormField(
                        controller: _representativeCodeController,
                        focusNode: _representativeCodeFocus,
                        textInputAction: TextInputAction.done,
                        hintText: "enter_representative_code".tr,
                        prefixIcon: Icon(
                          Icons.confirmation_number_outlined,
                          color: colors.main,
                        ),
                      ),

                      Gaps.vGap24,
                    ],

                    /// schedules
                    buildLabel("working_hours".tr),

                    Gaps.vGap12,

                    ListView.separated(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: schedules.length,

                      separatorBuilder: (_, _) => Gaps.vGap16,

                      itemBuilder: (context, index) {
                        final item = schedules[index];

                        return Container(
                          padding: EdgeInsets.all(16.w),

                          decoration: BoxDecoration(
                            color: colors.main.withValues(alpha: .04),

                            borderRadius: BorderRadius.circular(18.r),
                          ),

                          child: Column(
                            children: [
                              /// top
                              Row(
                                children: [
                                  if (schedules.length > 1)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          schedules.removeAt(index);
                                        });
                                      },

                                      child: Container(
                                        padding: EdgeInsets.all(8.w),

                                        decoration: BoxDecoration(
                                          color: colors.errorColor.withValues(
                                            alpha: .1,
                                          ),

                                          shape: BoxShape.circle,
                                        ),

                                        child: Icon(
                                          Icons.delete_outline,

                                          color: colors.errorColor,

                                          size: 20.sp,
                                        ),
                                      ),
                                    ),

                                  if (schedules.length > 1) Gaps.hGap8,

                                  Text(
                                    "${"schedule".tr} ${index + 1}",

                                    style: TextStyles.semiBold16(),
                                  ),
                                ],
                              ),

                              Gaps.vGap16,

                              /// day
                              DropdownButtonFormField<int>(
                                initialValue: item.dayOfWeek,

                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: colors.main,
                                  ),
                                  filled: true,
                                  fillColor: colors.main.withValues(
                                    alpha: 0.05,
                                  ),
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
                                  "choose_day".tr,
                                  style: TextStyles.medium14(),
                                ),

                                items: weekDays
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: e['value'],

                                        child: Text(e['title']),
                                      ),
                                    )
                                    .toList(),

                                onChanged: (value) {
                                  item.dayOfWeek = value;

                                  setState(() {});
                                },
                              ),

                              Gaps.vGap16,
                              Row(
                                children: [
                                  /// start time
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        pickTime(item.startTimeController);
                                      },

                                      child: AbsorbPointer(
                                        child: MyTextFormField(
                                          controller: item.startTimeController,

                                          hintText: "start_time".tr,

                                          prefixIcon: Icon(
                                            Icons.access_time,

                                            color: colors.main,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Gaps.vGap16,

                                  /// end time
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        pickTime(item.endTimeController);
                                      },

                                      child: AbsorbPointer(
                                        child: MyTextFormField(
                                          controller: item.endTimeController,

                                          hintText: "end_time".tr,

                                          prefixIcon: Icon(
                                            Icons.timer_off_outlined,

                                            color: colors.main,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gaps.vGap16,

                              /// slot duration
                              MyTextFormField(
                                controller: item.slotDurationController,

                                keyboardType: TextInputType.number,

                                hintText: "slot_duration".tr,

                                prefixIcon: Icon(
                                  Icons.timelapse_outlined,

                                  color: colors.main,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Gaps.vGap10,

                    /// add new schedule
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          schedules.add(DoctorScheduleModel());
                        });
                      },

                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.symmetric(vertical: 14.h),

                        decoration: BoxDecoration(
                          color: colors.main.withValues(alpha: .08),

                          borderRadius: BorderRadius.circular(18.r),

                          border: Border.all(
                            color: colors.main.withValues(alpha: .2),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.add_circle_outline, color: colors.main),

                            Gaps.hGap8,

                            Text(
                              "add_new_schedule".tr,

                              style: TextStyles.semiBold14(color: colors.main),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gaps.vGap20,

                    /// license
                    buildLabel("upload_license".tr),
                    Gaps.vGap10,

                    GestureDetector(
                      onTap: pickLicenseFile,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.main.withValues(alpha: .05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: colors.main.withValues(alpha: .15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.upload_file, color: colors.main),
                            Gaps.hGap10,
                            Expanded(
                              child: Text(
                                licenseFile != null
                                    ? licenseFile!.path.split('/').last
                                    : "choose_license_file".tr,
                                style: TextStyles.medium14(
                                  color: licenseFile != null
                                      ? colors.textColor
                                      : colors.lightTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gaps.vGap30,

                    /// button
                    state is AddDoctorLoading
                        ? const LoadingView()
                        : MyDefaultButton(
                            btnText: "add_doctor",
                            onPressed: submit,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(text, style: TextStyles.semiBold14());
  }
}

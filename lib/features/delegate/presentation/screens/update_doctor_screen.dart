// ignore_for_file: use_build_context_synchronously

import 'dart:io'; 

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/update_doctor_cubit/update_doctor_cubit.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialties_cubit/get_specialties_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorScheduleModel {
  int? dayOfWeek;

  final startTimeController = TextEditingController();

  final endTimeController = TextEditingController();

  final slotDurationController = TextEditingController();

  DoctorScheduleModel();
}

class UpdateDoctorScreen extends StatefulWidget {
  final DoctorEntity doctor;

  const UpdateDoctorScreen({super.key, required this.doctor});

  @override
  State<UpdateDoctorScreen> createState() => _UpdateDoctorScreenState();
}

class _UpdateDoctorScreenState extends State<UpdateDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<DoctorScheduleModel> schedules = [];

  final List<Map<String, dynamic>> weekDays = [
    {"title": "الأحد", "value": 0},
    {"title": "الإثنين", "value": 1},
    {"title": "الثلاثاء", "value": 2},
    {"title": "الأربعاء", "value": 3},
    {"title": "الخميس", "value": 4},
    {"title": "الجمعة", "value": 5},
    {"title": "السبت", "value": 6},
  ];

  /// Controllers
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();

  final _bioArController = TextEditingController();
  final _bioEnController = TextEditingController();

  final _professionalNumberController = TextEditingController();

  final _academicDegreeController = TextEditingController();

  // final _clinicPhoneController = TextEditingController();

  final _secretaryPhoneController = TextEditingController();
  final _whatsappNumberController = TextEditingController();

  final _minPatientsController = TextEditingController();

  final _priceController = TextEditingController();
  final _consultationPriceController = TextEditingController();

  final _representativeCodeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  /// Focus Nodes
  final _nameArFocus = FocusNode();
  final _nameEnFocus = FocusNode();

  final _bioArFocus = FocusNode();
  final _bioEnFocus = FocusNode();

  final _professionalNumberFocus = FocusNode();

  final _academicDegreeFocus = FocusNode();

  // final _clinicPhoneFocus = FocusNode();

  final _secretaryPhoneFocus = FocusNode();
  final _whatsappNumberFocus = FocusNode();

  final _minPatientsFocus = FocusNode();

  final _priceFocus = FocusNode();
  final _consultationPriceFocus = FocusNode();

  final _representativeCodeFocus = FocusNode();

  SpecialtyEntity? selectedSpeciality;
  LatLng? selectedLocation;
  String? selectedCity;
  String? selectedDistrict;
  String? selectedStreet;
  String? existingLicenseName;
  final bool _isLoadingLocation = false;

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

  bool hidePrice = false;
  bool hideConsultationPrice = false;

  String? _fileNameFromUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final segments = Uri.tryParse(url)?.pathSegments;
    if (segments != null && segments.isNotEmpty) {
      return Uri.decodeComponent(segments.last);
    }
    return url.split('/').last;
  }

  String _buildAddressFromLocation() {
    final location = widget.doctor.location;
    final parts = [
      location?.street,
      location?.district,
      location?.city,
    ].whereType<String>().where((e) => e.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  void _prefillSpecialty(List<SpecialtyEntity> specialties) {
    if (selectedSpeciality != null) return;
    final specialtyId = widget.doctor.specialty?.id;
    if (specialtyId == null) return;
    SpecialtyEntity? matched;
    for (final item in specialties) {
      if (item.id == specialtyId) {
        matched = item;
        break;
      }
    }
    if (matched == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || selectedSpeciality != null) return;
      setState(() => selectedSpeciality = matched);
    });
  }

  @override
  void initState() {
    super.initState();
    getCountry();
    context.read<GetSpecialtiesCubit>().getSpecialties();

    _nameArController.text = widget.doctor.name?.ar?.toString() ?? '';
    _nameEnController.text = widget.doctor.name?.en?.toString() ?? '';
    _bioArController.text = widget.doctor.bio?.ar?.toString() ?? '';
    _bioEnController.text = widget.doctor.bio?.en?.toString() ?? '';
    _professionalNumberController.text =
        widget.doctor.professionalRegistrationNumber ?? '';
    _academicDegreeController.text = widget.doctor.academicDegree ?? '';
    _secretaryPhoneController.text = widget.doctor.secretaryPhone ?? '';
    _whatsappNumberController.text = widget.doctor.whatsappNumber ?? '';
    _minPatientsController.text = widget.doctor.minPatients ?? '';
    _priceController.text = widget.doctor.price ?? '';
    _consultationPriceController.text = widget.doctor.consultationPrice ?? '';
    hidePrice = widget.doctor.priceHidden ?? false;
    hideConsultationPrice = widget.doctor.consultationPriceHidden ?? false;
    _representativeCodeController.text = widget.doctor.representativeCode ?? '';
    existingLicenseName = _fileNameFromUrl(widget.doctor.license);

    if (widget.doctor.secretaryCountryCode != null &&
        widget.doctor.secretaryCountryCode!.isNotEmpty) {
      try {
        _selectedCountry = CountryParser.parsePhoneCode(
          widget.doctor.secretaryCountryCode!.replaceAll('+', ''),
        );
      } catch (_) {}
    }

    if (widget.doctor.whatsappCountryCode != null &&
        widget.doctor.whatsappCountryCode!.isNotEmpty) {
      try {
        _whatsappCountry = CountryParser.parsePhoneCode(
          widget.doctor.whatsappCountryCode!.replaceAll('+', ''),
        );
      } catch (_) {}
    }

    selectedCity = widget.doctor.location?.city;
    selectedDistrict = widget.doctor.location?.district;
    selectedStreet = widget.doctor.location?.street;

    final lat = double.tryParse(
      widget.doctor.latitude ?? widget.doctor.location?.latitude ?? '',
    );
    final lng = double.tryParse(
      widget.doctor.longitude ?? widget.doctor.location?.longitude ?? '',
    );
    if (lat != null && lng != null) {
      selectedLocation = LatLng(lat, lng);
    }

    final address = _buildAddressFromLocation();
    if (address.isNotEmpty) {
      _locationController.text = address;
    } else if (selectedLocation != null) {
      _locationController.text =
          '${selectedLocation!.latitude}, ${selectedLocation!.longitude}';
    }

    if (widget.doctor.schedules != null &&
        widget.doctor.schedules!.isNotEmpty) {
      for (final schedule in widget.doctor.schedules!) {
        final item = DoctorScheduleModel();
        item.dayOfWeek = schedule.dayOfWeek;
        item.startTimeController.text = schedule.startTime ?? '';
        item.endTimeController.text = schedule.endTime ?? '';
        item.slotDurationController.text =
            schedule.slotDuration?.toString() ?? '';
        schedules.add(item);
      }
    } else {
      schedules.add(DoctorScheduleModel());
    }
  }

  late Country _selectedCountry;
  late Country _whatsappCountry;
  void getCountry() {
    _selectedCountry = CountryParser.parsePhoneCode('20');
    _whatsappCountry = CountryParser.parsePhoneCode('20');
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
    _whatsappNumberController.dispose();

    _minPatientsController.dispose();
    _priceController.dispose();
    _consultationPriceController.dispose();
    _representativeCodeController.dispose();
    _locationController.dispose();

    _nameArFocus.dispose();
    _nameEnFocus.dispose();
    _bioArFocus.dispose();
    _bioEnFocus.dispose();
    _professionalNumberFocus.dispose();
    _academicDegreeFocus.dispose();
    _secretaryPhoneFocus.dispose();
    _whatsappNumberFocus.dispose();
    _minPatientsFocus.dispose();
    _priceFocus.dispose();
    _consultationPriceFocus.dispose();
    _representativeCodeFocus.dispose();

    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result =
        await context.pushNamed(
              Routes.myMapViewRoute,
              extra: {
                'location': selectedLocation ?? LatLng(30.0444, 31.2357),
                'onChanged': (LatLng pos) {},
              },
            )
            as Map<String, dynamic>?;
    if (result == null || !mounted) return;

    final LatLng location = result['location'] as LatLng;
    final String address = result['address'] as String? ?? '';
    selectedLocation = location;
    selectedCity = result['city'] as String?;
    selectedDistrict = result['district'] as String?;
    selectedStreet = result['street'] as String?;
    _locationController.text = address.isNotEmpty
        ? address
        : '${location.latitude}, ${location.longitude}';
    setState(() {});
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

    String? whatsappNumber;
    String? whatsappCountryCode;
    if (_whatsappNumberController.text.isNotEmpty) {
      whatsappNumber = await Constants.phoneParsing(
        phone: _whatsappNumberController.text,
        countryCode: _whatsappCountry.countryCode,
        withCode: false,
      );
      whatsappCountryCode = "+${_whatsappCountry.phoneCode}";
    }

    if (!context.mounted) return;
    context.read<UpdateDoctorCubit>().updateDoctor(
      params: AddDoctorParams(
        id: widget.doctor.id,

        nameAr: _nameArController.text,
        nameEn: _nameEnController.text,

        bioAr: _bioArController.text,
        bioEn: _bioEnController.text,

        specialtyId: selectedSpeciality?.id,

        professionalRegistrationNumber: _professionalNumberController.text,

        academicDegree: _academicDegreeController.text,

        clinicPhone: secretaryPhone,

        secretaryPhone: secretaryPhone,

        whatsappNumber: whatsappNumber,
        whatsappCountryCode: whatsappCountryCode,
        latitude: selectedLocation?.latitude.toString(),
        longitude: selectedLocation?.longitude.toString(),
        city: selectedCity,
        district: selectedDistrict,
        street: selectedStreet,
        minPatients: _minPatientsController.text,
        price: _priceController.text,
        consultationPrice: _consultationPriceController.text,
        hidePrice: hidePrice,
        hideConsultationPrice: hideConsultationPrice,
        representativeCode: _representativeCodeController.text,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      appBar: AppBar(title: Text("update_doctor".tr)),

      body: BlocConsumer<UpdateDoctorCubit, UpdateDoctorState>(
        listener: (context, state) {
          if (state is UpdateDoctorSuccess) {
            Constants.showSnakToast(
              context: context,
              message: state.response.message,
              type: 1,
            );

            context.pop(true);
          }

          if (state is UpdateDoctorError) {
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
                                  : widget.doctor.profileImage != null
                                  ? NetworkImage(
                                      widget.doctor.profileImage ?? '',
                                    )
                                  : null,

                              child:
                                  profileImage == null &&
                                      widget.doctor.profileImage == null
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
                        FocusScope.of(context).requestFocus(_bioArFocus);
                      },
                      hintText: "enter_doctor_name".tr,
                      prefixIcon: Icon(
                        Icons.person_outline,
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
                        FocusScope.of(context).requestFocus(_nameEnFocus);
                      },
                      maxLines: 3,
                      hintText: "enter_doctor_bio".tr,
                      prefixIcon: Icon(Icons.info_outline, color: colors.main),
                    ),

                    Gaps.vGap16,

                    /// en name
                    buildLabel("doctor_name_en".tr),
                    Gaps.vGap8,
                    MyTextFormField(
                      controller: _nameEnController,
                      focusNode: _nameEnFocus,
                      textInputAction: TextInputAction.next,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      onSubmit: (_) {
                        FocusScope.of(context).requestFocus(_bioEnFocus);
                      },
                      hintText: "enter_doctor_name_en".tr,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: colors.main,
                      ),
                    ),

                    Gaps.vGap16,

                    /// en bio
                    buildLabel("doctor_bio_en".tr),
                    Gaps.vGap8,
                    MyTextFormField(
                      controller: _bioEnController,
                      focusNode: _bioEnFocus,
                      textInputAction: TextInputAction.next,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      onSubmit: (_) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_professionalNumberFocus);
                      },
                      maxLines: 3,
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
                          _prefillSpecialty(specialties);

                          return DropdownButtonFormField<SpecialtyEntity>(
                            key: ValueKey(selectedSpeciality?.id ?? 'specialty'),
                            initialValue: selectedSpeciality,
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

                      // onSubmit: (_) {
                      //   FocusScope.of(context).requestFocus();
                      // },
                      hintText: "enter_academic_degree".tr,

                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color: colors.main,
                      ),
                    ),

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
                              ).requestFocus(_whatsappNumberFocus);
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

                    Gaps.vGap16,

                    /// whatsapp phone
                    buildLabel("whatsapp_number".tr),

                    Gaps.vGap8,

                    Row(
                      children: [
                        CountryCodeWidget(
                          country: _whatsappCountry,
                          updateValue: (country) {
                            setState(() {
                              _whatsappCountry = country;
                            });
                          },
                        ),
                        Gaps.hGap8,
                        Expanded(
                          flex: 5,
                          child: MyTextFormField(
                            controller: _whatsappNumberController,

                            focusNode: _whatsappNumberFocus,

                            textInputAction: TextInputAction.next,

                            onSubmit: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_minPatientsFocus);
                            },

                            keyboardType: TextInputType.phone,

                            hintText: "enter_whatsapp_number".tr,

                            prefixIcon: Icon(Icons.phone, color: colors.main),
                          ),
                        ),
                      ],
                    ),

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

                    /// price & consultation price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel("price".tr),
                              Gaps.vGap8,
                              MyTextFormField(
                                controller: _priceController,
                                focusNode: _priceFocus,
                                textInputAction: TextInputAction.next,
                                onSubmit: (_) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_consultationPriceFocus);
                                },
                                keyboardType: TextInputType.number,
                                hintText: "enter_price".tr,
                                prefixIcon: Icon(
                                  Icons.payments_outlined,
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
                              buildLabel("consultation_price".tr),
                              Gaps.vGap8,
                              MyTextFormField(
                                controller: _consultationPriceController,
                                focusNode: _consultationPriceFocus,
                                textInputAction: TextInputAction.next,
                                onSubmit: (_) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_representativeCodeFocus);
                                },
                                keyboardType: TextInputType.number,
                                hintText: "enter_consultation_price".tr,
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  color: colors.main,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap8,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
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
                        ),
                        Gaps.hGap12,
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: colors.main,
                                value: hideConsultationPrice,
                                onChanged: (value) {
                                  setState(() {
                                    hideConsultationPrice = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  "hide_consultation_price_to_patients_desc".tr,
                                  style: TextStyles.medium14(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap16,

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
                                    : (existingLicenseName ??
                                          "choose_license_file".tr),
                                style: TextStyles.medium14(
                                  color:
                                      licenseFile != null ||
                                          existingLicenseName != null
                                      ? colors.textColor
                                      : colors.lightTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gaps.vGap20,

                    /// location
                    buildLabel("location".tr),
                    Gaps.vGap10,
                    MyTextFormField(
                      controller: _locationController,
                      backgroundColor: colors.whiteColor,
                      onTap: _pickLocation,
                      hintText: _isLoadingLocation
                          ? 'Getting location...'
                          : 'select_location'.tr,
                      readOnly: true,
                      prefixIcon: _isLoadingLocation
                          ? Padding(
                              padding: EdgeInsets.all(12.r),
                              child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: _pickLocation,
                              icon: Icon(Icons.location_on_outlined),
                            ),
                    ),

                    Gaps.vGap20,

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
                                  Expanded(
                                    child:
                                        /// start time
                                        GestureDetector(
                                          onTap: () {
                                            pickTime(item.startTimeController);
                                          },

                                          child: AbsorbPointer(
                                            child: MyTextFormField(
                                              controller:
                                                  item.startTimeController,

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

                    Gaps.vGap30,

                    /// button
                    state is UpdateDoctorLoading
                        ? const LoadingView()
                        : MyDefaultButton(
                            btnText: "update_doctor",
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

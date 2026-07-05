// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/delegate/domain/entities/medical_center_entity.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:alhakim/features/delegate/presentation/cubit/update_medical_center_cubit/update_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/widgets/medical_center_form_section.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpdateMedicalCenterScreen extends StatefulWidget {
  final MedicalCenterEntity medicalCenter;

  const UpdateMedicalCenterScreen({super.key, required this.medicalCenter});

  @override
  State<UpdateMedicalCenterScreen> createState() =>
      _UpdateMedicalCenterScreenState();
}

class _UpdateMedicalCenterScreenState extends State<UpdateMedicalCenterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  late Country _selectedCountry;
  File? logoFile;
  File? coverFile;
  File? licenseFile;

  @override
  void initState() {
    super.initState();
    final countryCode =
        widget.medicalCenter.countryCode?.replaceAll('+', '') ?? '20';
    _selectedCountry = CountryParser.parsePhoneCode(countryCode);

    _nameController.text = widget.medicalCenter.name ?? '';
    _descriptionController.text = widget.medicalCenter.description ?? '';
    _addressController.text = widget.medicalCenter.address ?? '';
    _phoneController.text = widget.medicalCenter.phone ?? '';
    _emailController.text = widget.medicalCenter.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nameFocus.dispose();
    _descriptionFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage(void Function(File) setter) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() => setter(File(result.files.single.path!)));
    }
  }

  Future<void> _pickLicense() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => licenseFile = File(result.files.single.path!));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = await Constants.phoneParsing(
      phone: _phoneController.text,
      countryCode: _selectedCountry.countryCode,
      withCode: false,
    );

    if (!context.mounted) return;

    context.read<UpdateMedicalCenterCubit>().updateMedicalCenter(
          params: AddMedicalCenterParams(
            id: widget.medicalCenter.id.toString(),
            name: _nameController.text,
            description: _descriptionController.text,
            address: _addressController.text,
            countryCode: '+${_selectedCountry.phoneCode}',
            phone: phone,
            email: _emailController.text,
            logo: logoFile,
            cover: coverFile,
            license: licenseFile,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text('update_medical_center'.tr)),
      body: BlocConsumer<UpdateMedicalCenterCubit, UpdateMedicalCenterState>(
        listener: (context, state) {
          if (state is UpdateMedicalCenterSuccess) {
            Constants.showSnakToast(
              context: context,
              message: state.response.message,
              type: 1,
            );
            context.pop(true);
          }
          if (state is UpdateMedicalCenterError) {
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
                  children: [
                    MedicalCenterFormSection(
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      addressController: _addressController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      nameFocus: _nameFocus,
                      descriptionFocus: _descriptionFocus,
                      addressFocus: _addressFocus,
                      phoneFocus: _phoneFocus,
                      emailFocus: _emailFocus,
                      selectedCountry: _selectedCountry,
                      onCountryChanged: (country) {
                        setState(() => _selectedCountry = country);
                      },
                      logoFile: logoFile,
                      coverFile: coverFile,
                      licenseFile: licenseFile,
                      existingLogo: widget.medicalCenter.logo,
                      existingCover: widget.medicalCenter.cover,
                      onPickLogo: () => _pickImage((f) => logoFile = f),
                      onPickCover: () => _pickImage((f) => coverFile = f),
                      onPickLicense: _pickLicense,
                    ),
                    Gaps.vGap30,
                    state is UpdateMedicalCenterLoading
                        ? const LoadingView()
                        : MyDefaultButton(
                            btnText: 'update',
                            onPressed: _submit,
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
}

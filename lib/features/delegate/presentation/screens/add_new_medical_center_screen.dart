// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:alhakim/features/delegate/presentation/cubit/add_medical_center_cubit/add_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/widgets/medical_center_form_section.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddNewMedicalCenterScreen extends StatefulWidget {
  const AddNewMedicalCenterScreen({super.key});

  @override
  State<AddNewMedicalCenterScreen> createState() =>
      _AddNewMedicalCenterScreenState();
}

class _AddNewMedicalCenterScreenState extends State<AddNewMedicalCenterScreen> {
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
    _selectedCountry = CountryParser.parsePhoneCode('20');
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

    context.read<AddMedicalCenterCubit>().addMedicalCenter(
          AddMedicalCenterParams(
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
      appBar: AppBar(title: Text('add_medical_center'.tr)),
      body: BlocConsumer<AddMedicalCenterCubit, AddMedicalCenterState>(
        listener: (context, state) {
          if (state is AddMedicalCenterSuccess) {
            Constants.showSnakToast(
              context: context,
              message: state.response.message,
              type: 1,
            );
            context.pop(true);
          }
          if (state is AddMedicalCenterError) {
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
                      onPickLogo: () => _pickImage((f) => logoFile = f),
                      onPickCover: () => _pickImage((f) => coverFile = f),
                      onPickLicense: _pickLicense,
                    ),
                    Gaps.vGap30,
                    state is AddMedicalCenterLoading
                        ? const LoadingView()
                        : MyDefaultButton(
                            btnText: 'add_medical_center',
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

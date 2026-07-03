// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalCenterFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final FocusNode nameFocus;
  final FocusNode descriptionFocus;
  final FocusNode addressFocus;
  final FocusNode phoneFocus;
  final FocusNode emailFocus;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final File? logoFile;
  final File? coverFile;
  final File? licenseFile;
  final String? existingLogo;
  final String? existingCover;
  final VoidCallback onPickLogo;
  final VoidCallback onPickCover;
  final VoidCallback onPickLicense;

  const MedicalCenterFormSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.addressController,
    required this.phoneController,
    required this.emailController,
    required this.nameFocus,
    required this.descriptionFocus,
    required this.addressFocus,
    required this.phoneFocus,
    required this.emailFocus,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.logoFile,
    required this.coverFile,
    required this.licenseFile,
    this.existingLogo,
    this.existingCover,
    required this.onPickLogo,
    required this.onPickCover,
    required this.onPickLicense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('upload_cover'.tr),
        Gaps.vGap8,
        GestureDetector(
          onTap: onPickCover,
          child: Container(
            width: double.infinity,
            height: 130.h,
            decoration: BoxDecoration(
              color: colors.main.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(16.r),
              image: coverFile != null
                  ? DecorationImage(
                      image: FileImage(coverFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: coverFile == null
                ? existingCover != null && existingCover!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: DiffImage(
                          image: existingCover,
                          width: double.infinity,
                          height: 130.h,
                          fitType: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              color: colors.main, size: 32.sp),
                          Gaps.vGap8,
                          Text(
                            'choose_cover_image'.tr,
                            style: TextStyles.medium14(color: colors.main),
                          ),
                        ],
                      )
                : null,
          ),
        ),
        Gaps.vGap24,
        Center(
          child: GestureDetector(
            onTap: onPickLogo,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: colors.main.withValues(alpha: .08),
                  backgroundImage:
                      logoFile != null ? FileImage(logoFile!) : null,
                  child: logoFile == null
                      ? existingLogo != null && existingLogo!.isNotEmpty
                          ? ClipOval(
                              child: DiffImage(
                                image: existingLogo,
                                width: 100.w,
                                height: 100.h,
                                isCircle: true,
                              ),
                            )
                          : Icon(Icons.local_hospital_outlined,
                              size: 40.sp, color: colors.main)
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: colors.main,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt,
                      color: colors.whiteColor, size: 18.sp),
                ),
              ],
            ),
          ),
        ),
        Gaps.vGap10,
        Center(
          child: Text(
            'upload_logo'.tr,
            style: TextStyles.medium14(color: colors.main),
          ),
        ),
        Gaps.vGap24,
        _buildLabel('center_name'.tr),
        Gaps.vGap8,
        MyTextFormField(
          controller: nameController,
          focusNode: nameFocus,
          textInputAction: TextInputAction.next,
          onSubmit: (_) =>
              FocusScope.of(context).requestFocus(descriptionFocus),
          hintText: 'enter_center_name'.tr,
          prefixIcon: Icon(Icons.local_hospital_outlined, color: colors.main),
        ),
        Gaps.vGap16,
        _buildLabel('center_description'.tr),
        Gaps.vGap8,
        MyTextFormField(
          controller: descriptionController,
          focusNode: descriptionFocus,
          textInputAction: TextInputAction.next,
          onSubmit: (_) => FocusScope.of(context).requestFocus(addressFocus),
          maxLines: 3,
          hintText: 'enter_center_description'.tr,
          prefixIcon: Icon(Icons.info_outline, color: colors.main),
        ),
        Gaps.vGap16,
        _buildLabel('address'.tr),
        Gaps.vGap8,
        MyTextFormField(
          controller: addressController,
          focusNode: addressFocus,
          textInputAction: TextInputAction.next,
          onSubmit: (_) => FocusScope.of(context).requestFocus(phoneFocus),
          hintText: 'enter_address'.tr,
          prefixIcon: Icon(Icons.location_on_outlined, color: colors.main),
        ),
        Gaps.vGap16,
        _buildLabel('phone'.tr),
        Gaps.vGap8,
        Row(
          children: [
            CountryCodeWidget(
              country: selectedCountry,
              updateValue: onCountryChanged,
            ),
            Gaps.hGap8,
            Expanded(
              flex: 5,
              child: MyTextFormField(
                controller: phoneController,
                focusNode: phoneFocus,
                textInputAction: TextInputAction.next,
                onSubmit: (_) =>
                    FocusScope.of(context).requestFocus(emailFocus),
                keyboardType: TextInputType.phone,
                hintText: 'enter_phone'.tr,
                prefixIcon: Icon(Icons.phone_outlined, color: colors.main),
              ),
            ),
          ],
        ),
        Gaps.vGap16,
        _buildLabel('email'.tr),
        Gaps.vGap8,
        MyTextFormField(
          controller: emailController,
          focusNode: emailFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          hintText: 'enter_email'.tr,
          prefixIcon: Icon(Icons.email_outlined, color: colors.main),
        ),
        Gaps.vGap24,
        _buildLabel('upload_license'.tr),
        Gaps.vGap10,
        GestureDetector(
          onTap: onPickLicense,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: colors.main.withValues(alpha: .05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colors.main.withValues(alpha: .15)),
            ),
            child: Row(
              children: [
                Icon(Icons.upload_file, color: colors.main),
                Gaps.hGap10,
                Expanded(
                  child: Text(
                    licenseFile != null
                        ? licenseFile!.path.split('/').last
                        : 'choose_license_file'.tr,
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
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyles.semiBold14());
  }
}

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/back_button.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/widgets/user_type_card_widget.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChooseUserTypeScreen extends StatefulWidget {
  const ChooseUserTypeScreen({super.key});

  @override
  State<ChooseUserTypeScreen> createState() => _ChooseUserTypeScreenState();
}

class _ChooseUserTypeScreenState extends State<ChooseUserTypeScreen> {
  late UserType _selectedUserType;

  @override
  void initState() {
    super.initState();
    final currentType = sessionCubit.state.userType;
    _selectedUserType = currentType == UserType.doctor
        ? UserType.doctor
        : UserType.patient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Gaps.vGap8,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: context.canPop()
                    ? const CustomBackButton()
                    : SizedBox(height: 32.h, width: 32.w),
              ),
              Gaps.vGap16,
              // ElasticIn(
              //   duration: const Duration(milliseconds: 1000),
              //   child: Image.asset(
              //     'assets/images/alhakim_icon.png',
              //     width: 130,
              //   ).fadeIn(duration: const Duration(milliseconds: 1400)),
              // ),
              ElasticIn(
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  'assets/images/alhakim_icon.png',
                  width: 120,
                ).fadeIn(duration: const Duration(milliseconds: 1400)),
              ),
              const SizedBox(height: 24),

              // 2. Alhakim الإنجليزي
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 600),
                child: Image.asset('assets/images/alhakim_en.png', width: 120),
              ),
              const SizedBox(height: 8),

              // // 3. الحكيم بالعربي
              // FadeInUp(
              //   delay: const Duration(milliseconds: 1000),
              //   duration: const Duration(milliseconds: 600),
              //   child: Image.asset('assets/images/alhakim_ar.png', width: 220),
              // ),
              Gaps.vGap24,
              _EmergencyBanner(
                onTap: () =>
                    context.push(Routes.emergencyCategoriesScreenRoute),
              ),
              Gaps.vGap24,
              Text(
                'choose_account_type'.tr,
                textAlign: TextAlign.center,
                style: TextStyles.semiBold18(color: colors.textColor),
              ),
              Gaps.vGap8,
              Text(
                'choose_account_type_description'.tr,
                textAlign: TextAlign.center,
                style: TextStyles.medium14(color: colors.lightTextColor),
              ),
              Gaps.vGap20,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: UserTypeCardWidget(
                      title: 'patient_account'.tr,
                      description: 'patient_account_description'.tr,
                      userType: UserType.patient,
                      icon: Icons.person_outline_rounded,
                      isSelected: _selectedUserType == UserType.patient,
                      onTap: () {
                        setState(() {
                          _selectedUserType = UserType.patient;
                        });
                      },
                    ),
                  ),
                  Gaps.hGap8,
                  Expanded(
                    child: UserTypeCardWidget(
                      title: 'doctor_account'.tr,
                      description: 'doctor_account_description'.tr,
                      userType: UserType.doctor,
                      icon: Icons.medical_services_outlined,
                      isSelected: _selectedUserType == UserType.doctor,
                      onTap: () {
                        setState(() {
                          _selectedUserType = UserType.doctor;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Gaps.vGap24,
              MyDefaultButton(
                btnText: 'continue',
                onPressed: () {
                  context.pushNamed(
                    Routes.loginScreenRoute,
                    extra: _selectedUserType,
                  );
                },
              ),
              Gaps.vGap32,
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _EmergencyBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.local_hospital_rounded,
                color: colors.errorColor,
                size: 24.sp,
              ),
            ),
            Gaps.hGap10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'emergency_banner_title'.tr,
                    style: TextStyles.medium14(color: colors.errorColor),
                  ),
                  Gaps.vGap4,
                  Text(
                    'emergency_banner_subtitle'.tr,
                    style: TextStyles.medium12(
                      color: colors.errorColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              appLocalizations.isEnLocale
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              color: colors.errorColor,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}

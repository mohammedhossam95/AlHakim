import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/svg_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class DoctorListItem extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorListItem({super.key, required this.doctor});

  String get _doctorDisplayName => appLocalizations.isArLocale
      ? doctor.name?.ar ?? ''
      : doctor.name?.en ?? '';

  String get _contactPhone {
    final countryCode =
        doctor.secretaryCountryCode ??
        doctor.medicalCenter?.countryCode ??
        '20';
    final phone = doctor.secretaryPhone ?? doctor.medicalCenter?.phone ?? '';
    return '$countryCode$phone';
  }

  (double, double)? get _mapCoordinates {
    final candidates = <(String?, String?)>[
      (doctor.latitude, doctor.longitude),
      (doctor.location?.latitude, doctor.location?.longitude),
      (doctor.medicalCenter?.latitude, doctor.medicalCenter?.longitude),
    ];

    for (final pair in candidates) {
      final lat = double.tryParse(pair.$1 ?? '');
      final lng = double.tryParse(pair.$2 ?? '');
      if (lat != null && lng != null) {
        return (lat, lng);
      }
    }
    return null;
  }

  Future<void> _openMaps() async {
    final coords = _mapCoordinates;
    if (coords == null) return;
    await Constants.openGoogleMaps(lat: coords.$1, lng: coords.$2);
  }

  Future<void> _openWhatsApp() async {
    await Constants.openWhatsApp(_contactPhone);
  }

  Future<void> _callDoctor() async {
    await Constants.makePhoneCall(_contactPhone);
  }

  Future<void> _shareDoctor() async {
    final specialty = doctor.specialty?.name ?? '';
    final shareText = specialty.isEmpty
        ? _doctorDisplayName
        : '$_doctorDisplayName - $specialty';
    if (shareText.trim().isEmpty) return;
    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colors.lightTextColor.withValues(alpha: .2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colors.lightTextColor.withValues(alpha: .1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  DiffImage(
                    image: doctor.profileImage,
                    width: 70.w,
                    height: 70.w,
                    userName: _doctorDisplayName,
                    fitType: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  if (doctor.isActive == true)
                    Positioned(
                      left: appLocalizations.isArLocale ? -5 : null,
                      right: appLocalizations.isArLocale ? null : -5,
                      bottom: -5,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: colors.whiteColor,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Gaps.hGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(_doctorDisplayName, style: TextStyles.semiBold18()),
                    Text(
                      doctor.specialty?.name ?? '',
                      style: TextStyles.medium14(color: colors.main),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (doctor.bio != null) ...[
            Gaps.vGap8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.medical_services_rounded,
                  size: 16.sp,
                  color: colors.main,
                ),
                Gaps.hGap8,
                Expanded(
                  child: Text(
                    appLocalizations.isArLocale
                        ? doctor.bio?.ar ?? ''
                        : doctor.bio?.en ?? '',
                    maxLines: 2,
                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),
                ),
              ],
            ),
          ],
          if (doctor.location?.city != null) ...[
            Gaps.vGap8,
            Row(
              children: [
                Icon(Icons.location_on, size: 16.sp, color: colors.main),
                Gaps.hGap4,
                Expanded(
                  child: Text(
                    doctor.location?.city ?? '',
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                ),
              ],
            ),
          ],
          if (doctor.priceHidden == false && doctor.price != '0.00') ...[
            Gaps.vGap4,
            Text(
              '${'examination_price'.tr} ${doctor.price ?? ''} ${'egp'.tr}',
              style: TextStyles.medium14(color: colors.main),
            ),
          ],
          if (doctor.consultationPriceHidden == false &&
              doctor.consultationPrice != '0.00') ...[
            Gaps.vGap4,
            Text(
              '${'consultation_price_text'.tr} ${doctor.consultationPrice ?? ''} ${'egp'.tr}',
              style: TextStyles.medium14(color: colors.main),
            ),
          ],
          if (doctor.medicalCenter != null) ...[
            Gaps.vGap12,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.main.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DiffImage(
                    image: doctor.medicalCenter?.logo ?? '',
                    width: 30.w,
                    height: 30.w,
                    isCircle: true,
                    fitType: BoxFit.cover,
                    userName: doctor.medicalCenter?.name ?? '',
                  ),
                  Gaps.hGap8,
                  Text(
                    doctor.medicalCenter?.name ?? '',
                    style: TextStyles.medium14(color: colors.main),
                  ),
                ],
              ),
            ),
          ],
          Gaps.vGap12,
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: colors.lightTextColor.withValues(alpha: .05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _DoctorActionButton(
                    svgAsset: SvgAssets.location,
                    label: 'location'.tr,
                    onTap: _openMaps,
                  ),
                ),
                Expanded(
                  child: _DoctorActionButton(
                    svgAsset: SvgAssets.whatsappIcon,
                    label: 'whatsapp'.tr,
                    onTap: _openWhatsApp,
                  ),
                ),
                Expanded(
                  child: _DoctorActionButton(
                    svgAsset: SvgAssets.callIcon,
                    label: 'call'.tr,
                    onTap: _callDoctor,
                  ),
                ),
                Expanded(
                  child: _DoctorActionButton(
                    svgAsset: SvgAssets.shareApp,
                    label: 'share'.tr,
                    onTap: _shareDoctor,
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap12,
          MyDefaultButton(
            onPressed: () {
              if (sessionCubit.state.status != SessionStatus.authenticated) {
                Constants.showLoginWarningDialog(
                  context,
                  onOkPressed: () {
                    context.go(Routes.chooseUserTypeScreenRoute);
                  },
                );
                return;
              }
              context.push(Routes.bookingScreenRoute, extra: doctor);
            },
            btnText: 'book_now',
          ),
        ],
      ),
    );
  }
}

class _DoctorActionButton extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback onTap;

  const _DoctorActionButton({
    required this.svgAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 22.w,
              height: 22.w,
              colorFilter: ColorFilter.mode(colors.main, BlendMode.srcIn),
            ),
            Gaps.vGap4,
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

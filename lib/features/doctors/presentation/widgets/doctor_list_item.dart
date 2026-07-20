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
import 'package:go_router/go_router.dart';

class DoctorListItem extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorListItem({super.key, required this.doctor});

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
                    userName: appLocalizations.isArLocale
                        ? doctor.name?.ar ?? ''
                        : doctor.name?.en ?? '',
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
                    Text(
                      appLocalizations.isArLocale
                          ? doctor.name?.ar ?? ''
                          : doctor.name?.en ?? '',
                      style: TextStyles.semiBold18(),
                    ),
                    Text(
                      doctor.specialty?.name ?? '',
                      style: TextStyles.medium14(color: colors.main),
                    ),
                    if (doctor.bio != null)
                      Text(
                        appLocalizations.isArLocale
                            ? doctor.bio?.ar ?? ''
                            : doctor.bio?.en ?? '',
                        maxLines: 2,
                        style: TextStyles.medium14(
                          color: colors.lightTextColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.vGap4,
          if (doctor.location?.city != null)
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: colors.lightTextColor),
                Gaps.hGap4,
                Expanded(
                  child: Text(
                    doctor.location?.city ?? '',
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                ),
              ],
            ),

          if (doctor.priceHidden == false && doctor.price != "0.00")
            Text(
              "${"examination_price".tr} ${doctor.price ?? ''} ${"egp".tr}",
              style: TextStyles.medium14(color: colors.main),
            ),

          if (doctor.consultationPriceHidden == false &&
              doctor.consultationPrice != "0.00")
            Text(
              "${"consultation_price_text".tr} ${doctor.consultationPrice ?? ''} ${"egp".tr}",
              style: TextStyles.medium14(color: colors.main),
            ),
          Gaps.vGap16,
          if (doctor.medicalCenters != null &&
              doctor.medicalCenters!.isNotEmpty) ...[
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
                    image: doctor.medicalCenters?.first.logo ?? '',
                    width: 30.w,
                    height: 30.w,
                    isCircle: true,
                    fitType: BoxFit.cover,
                    userName: doctor.medicalCenters?.first.name ?? '',
                  ),
                  Gaps.hGap8,
                  Text(
                    doctor.medicalCenters?.first.name ?? '',
                    style: TextStyles.medium14(color: colors.main),
                  ),
                ],
              ),
            ),
          ],
          Gaps.vGap16,
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
            btnText: "book_now",
          ),
          Gaps.vGap20,
          MyDefaultButton(
            withDottedBorder: false,
            color: colors.whiteColor,
            borderColor: colors.main,
            textColor: colors.main,
            onPressed: () {
              Constants.makePhoneCall(
                "${doctor.secretaryCountryCode ?? doctor.medicalCenters?.first.countryCode ?? "20"}${doctor.secretaryPhone ?? doctor.medicalCenters?.first.phone ?? ""}",
              );
            },
            localeText: true,
            svgAsset: SvgAssets.callIcon,
            btnText:
                "${doctor.secretaryCountryCode ?? doctor.medicalCenters?.first.countryCode ?? "20"}${doctor.secretaryPhone ?? doctor.medicalCenters?.first.phone ?? ""}",
          ),
          Gaps.vGap10,
        ],
      ),
    );
  }
}

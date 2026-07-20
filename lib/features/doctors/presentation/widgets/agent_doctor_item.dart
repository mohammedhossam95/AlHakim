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

class AgentDoctorItem extends StatelessWidget {
  final DoctorEntity doctor;

  const AgentDoctorItem({super.key, required this.doctor});

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
            color: colors.lightTextColor.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(color: colors.lightTextColor.withValues(alpha: .1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DiffImage(
            image: doctor.profileImage,
            width: 100.w,
            height: 100.w,
            isCircle: true,
            fitType: BoxFit.cover,
          ),

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
          if (doctor.bio != null)
            Text(
              appLocalizations.isArLocale
                  ? doctor.bio?.ar ?? ''
                  : doctor.bio?.en ?? '',
              style: TextStyles.medium14(color: colors.lightTextColor),
            ),
          if (doctor.priceHidden == false)
            Text(
              "${doctor.price ?? ''} ج.م / كشف",
              style: TextStyles.semiBold16(color: colors.main),
            ),

          Gaps.vGap16,
          MyDefaultButton(
            withDottedBorder: false,
            color: colors.secondary,
            borderColor: colors.secondary,
            textColor: colors.subTextColor,
            localeText: true,
            rightIcon: true,
            iconData: Icons.call,
            btnText:
                "${doctor.secretaryCountryCode ?? doctor.medicalCenters?.first.countryCode ?? "20"}${doctor.secretaryPhone ?? doctor.medicalCenters?.first.phone ?? ""}",
            onPressed: () {
              Constants.makePhoneCall(
                "${doctor.secretaryCountryCode ?? doctor.medicalCenters?.first.countryCode ?? "20"}${doctor.secretaryPhone ?? doctor.medicalCenters?.first.phone ?? ""}",
              );
            },
          ),
          Gaps.vGap10,
          MyDefaultButton(
            withDottedBorder: false,
            svgAsset: SvgAssets.calendar,
            rightIcon: true,

            btnText: "book_now",
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
          ),

          Gaps.vGap10,
        ],
      ),
    );
  }
}

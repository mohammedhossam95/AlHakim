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
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: DiffImage(
                  image: doctor.profileImage,
                  width: 70.w,
                  height: 70.w,
                  isCircle: false,
                  radius: 12.r,
                  fitType: BoxFit.fill,
                ),
              ),
              Gaps.hGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.isArLocale
                          ? doctor.name?.ar ?? ''
                          : doctor.name?.en ?? '',
                      style: TextStyles.semiBold18(),
                    ),
                    Gaps.vGap8,
                    Text(
                      doctor.specialty?.name ?? '',
                      style: TextStyles.medium14(color: colors.main),
                    ),
                    Gaps.vGap4,
                    if (doctor.location?.city != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: colors.lightTextColor,
                          ),
                          Gaps.hGap4,
                          Expanded(
                            child: Text(
                              doctor.location?.city ?? '',
                              style: TextStyles.medium12(
                                color: colors.lightTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: doctor.isActive == true
                      ? colors.secondary.withValues(alpha: .2)
                      : colors.errorColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      doctor.isActive == true ? Icons.verified : Icons.close,
                      size: 16,
                      color: doctor.isActive == true
                          ? colors.secondary
                          : colors.errorColor,
                    ),
                    Gaps.hGap4,
                    Text(
                      doctor.isActive == true ? "موثق" : "غير مفعل",
                      style: TextStyles.medium12(
                        color: doctor.isActive == true
                            ? colors.secondary
                            : colors.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.vGap4,
          if (doctor.bio != null)
            Text(
              appLocalizations.isArLocale
                  ? doctor.bio?.ar ?? ''
                  : doctor.bio?.en ?? '',
              style: TextStyles.medium14(color: colors.lightTextColor),
            ),
          Gaps.vGap12,
          if (doctor.priceHidden == false)
            Row(
              children: [
                Text(
                  "${doctor.price ?? ''} ج.م / كشف",
                  style: TextStyles.semiBold16(color: colors.main),
                ),
              ],
            ),
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
                "${doctor.secretaryCountryCode ?? "20"}${doctor.secretaryPhone}",
              );
            },
            localeText: true,
            svgAsset: SvgAssets.callIcon,
            btnText:
                "${doctor.secretaryCountryCode ?? "20"}${doctor.secretaryPhone}",
          ),
          Gaps.vGap10,
        ],
      ),
    );
  }
}

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/gif_manager.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AppoinmentSuccessScreen extends StatelessWidget {
  final DoctorEntity? doctor;
  final String appointmentDate;

  const AppoinmentSuccessScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              /// Success Icon
              Lottie.asset(GifAssets.success, height: 200.h),

              // Gaps.vGap24,
              Text(
                "booking_confirmed".tr,
                style: TextStyles.bold24(color: colors.main),
                textAlign: TextAlign.center,
              ),

              Gaps.vGap12,

              Text(
                "booking_confirmed_desc".tr,
                style: TextStyles.medium14(color: colors.lightTextColor),
                textAlign: TextAlign.center,
              ),

              Gaps.vGap32,

              /// Appointment Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: colors.whiteColor,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        DiffImage(
                          image: doctor?.profileImage ?? '',
                          width: 64.w,
                          height: 64.w,
                          borderRadius: BorderRadius.circular(32.r),
                        ),

                        Gaps.hGap12,

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.isArLocale
                                    ? doctor?.name?.ar ?? ''
                                    : doctor?.name?.en ?? '',
                                style: TextStyles.semiBold18(),
                                textAlign: TextAlign.start,
                              ),

                              Gaps.vGap4,

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.main.withValues(alpha: .08),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  doctor?.specialty?.name ?? '',

                                  style: TextStyles.medium12(
                                    color: colors.main,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap20,

                    _InfoTile(
                      icon: Icons.calendar_month_outlined,
                      title: "appointment_date".tr,
                      value: DateFormat(
                        'EEEE, d MMM yyyy',

                        appLocalizations.locale?.languageCode,
                      ).format(DateTime.parse(appointmentDate)),
                    ),
                    if (doctor?.location?.city != null) ...[
                      Gaps.vGap12,

                      _InfoTile(
                        icon: Icons.location_on_outlined,
                        title: "clinic".tr,
                        value: doctor?.location?.city ?? '',
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.vGap30,
              // const Spacer(),
              Column(
                children: [
                  // MyDefaultButton(
                  //   btnText: "go_to_appointments",
                  //   onPressed: () {
                  //     context.read<BottomNavBarCubit>().changeCurrentScreen(
                  //       index: 1,
                  //     );
                  //     context.pushReplacement(Routes.mainPageRoute);
                  //   },
                  //   color: colors.backGround,
                  //   textColor: colors.main,
                  //   textStyle: TextStyles.semiBold16(),
                  //   borderColor: colors.main,
                  // ),

                  // Gaps.vGap16,
                  MyDefaultButton(
                    btnText: "go_to_home",
                    color: colors.main,
                    borderColor: colors.main,
                    onPressed: () {
                      context.pushReplacement(Routes.mainPageRoute);
                    },
                  ),
                ],
              ),

              Gaps.vGap20,
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.backGround,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: colors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.main, size: 22.sp),
          ),

          Gaps.hGap12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.medium14(color: colors.lightTextColor),
                ),

                Gaps.vGap8,

                Text(
                  value,
                  style: TextStyles.semiBold16(),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

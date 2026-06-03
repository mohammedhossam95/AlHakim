import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_home_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/close_clinic_today_cubit/close_clinic_today_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_home_cubit/get_doctor_home_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggle_clinic_cubit/toggle_clinic_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ClinicHomeScreen extends StatefulWidget {
  const ClinicHomeScreen({super.key});

  @override
  State<ClinicHomeScreen> createState() => _ClinicHomeScreenState();
}

class _ClinicHomeScreenState extends State<ClinicHomeScreen> {
  @override
  void initState() {
    super.initState();

    log("token ${sharedPreferences.getAuth()?.token ?? ''}");

    log("id ${sharedPreferences.getAuth()?.doctor?.id.toString() ?? ''}");
    log(
      "schedule ${sharedPreferences.getAuth()?.doctor?.schedules.toString() ?? ''}",
    );

    context.read<GetDoctorHomeCubit>().getDoctorHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      appBar: AppBar(
        title: Text("clinic_dashboard".tr),
        automaticallyImplyLeading: false,
      ),

      body: BlocBuilder<GetDoctorHomeCubit, GetDoctorHomeState>(
        builder: (context, state) {
          if (state is GetDoctorHomeLoading) {
            return _buildShimmer();
          }

          if (state is GetDoctorHomeError) {
            return Center(child: Text(state.message));
          }

          DoctorHomeEntity? home;

          if (state is GetDoctorHomeSuccess) {
            home = state.response.data as DoctorHomeEntity;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),

            child: Column(
              children: [
                /// clinic status
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(20.w),

                  decoration: BoxDecoration(
                    color: colors.whiteColor,

                    borderRadius: BorderRadius.circular(24.r),
                  ),

                  child: Column(
                    children: [
                      Text(
                        "clinic_current_status".tr,

                        style: TextStyles.medium18(
                          color: colors.lightTextColor,
                        ),
                      ),

                      Gaps.vGap10,

                      Text(
                        home?.doctorClosedToday == true
                            ? "cancelled_today".tr
                            : home?.isClinicOpen == true
                            ? "open".tr
                            : "closed".tr,

                        style: TextStyles.bold22(
                          color: home?.doctorClosedToday == true
                              ? colors.errorColor
                              : home?.isClinicOpen == true
                              ? colors.main
                              : colors.lightTextColor,
                        ),
                      ),

                      Gaps.vGap20,
                      if (home?.doctorClosedToday == false)
                        /// toggle clinic
                        BlocListener<ToggleClinicCubit, ToggleClinicState>(
                          listener: (context, toggleState) {
                            if (toggleState is ToggleClinicLoading) {
                              Constants.showLoading(context);
                            } else if (toggleState is ToggleClinicError) {
                              Constants.hideLoading(context);

                              Constants.showSnakToast(
                                context: context,
                                type: 3,
                                message: toggleState.message,
                              );
                            } else if (toggleState is ToggleClinicSuccess) {
                              Constants.hideLoading(context);
                              Constants.showSnakToast(
                                context: context,
                                type: 1,
                                message: toggleState.response.message,
                              );

                              context
                                  .read<GetDoctorHomeCubit>()
                                  .getDoctorHome();
                            }
                          },
                          child: MyDefaultButton(
                            btnText: home?.isClinicOpen == true
                                ? "close_clinic"
                                : "open_clinic",

                            borderRadius: 30,

                            height: 54.h,

                            svgAsset: null,

                            color: home?.isClinicOpen == true
                                ? colors.errorColor
                                : colors.main,
                            onPressed: () async {
                              Constants.showConfirmDialog(
                                context: context,
                                title: home?.isClinicOpen == true
                                    ? "close_clinic".tr
                                    : "open_clinic".tr,
                                content: home?.isClinicOpen == true
                                    ? "close_clinic_desc".tr
                                    : "open_clinic_desc".tr,
                                onYesPressed: () async {
                                  if (!context.mounted) return;
                                  context
                                      .read<ToggleClinicCubit>()
                                      .toggleClinic(
                                        doctorId:
                                            sharedPreferences
                                                .getAuth()
                                                ?.doctor
                                                ?.id ??
                                            '',
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      if (home?.doctorClosedToday == false) Gaps.vGap16,

                      /// close today
                      if (home?.doctorClosedToday != true)
                        BlocListener<
                          CloseClinicTodayCubit,
                          CloseClinicTodayState
                        >(
                          listener: (context, state) {
                            if (state is CloseClinicTodayLoading) {
                              Constants.showLoading(context);
                            } else if (state is CloseClinicTodayError) {
                              Constants.hideLoading(context);
                              Constants.showSnakToast(
                                context: context,
                                type: 3,
                                message: state.message,
                              );
                            } else if (state is CloseClinicTodaySuccess) {
                              Constants.hideLoading(context);
                              Constants.showSnakToast(
                                context: context,
                                type: 1,
                                message: state.response.message ?? '',
                              );

                              context
                                  .read<GetDoctorHomeCubit>()
                                  .getDoctorHome();
                            }
                          },

                          child: MyDefaultButton(
                            btnText: "close_clinic_today",

                            borderRadius: 30,

                            height: 54.h,

                            color: colors.whiteColor,

                            textColor: colors.errorColor,

                            borderColor: colors.errorColor,
                            onPressed: () async {
                              Constants.showConfirmDialog(
                                context: context,
                                title: "cancle_clinic".tr,
                                content: "cancle_clinic_desc".tr,
                                onYesPressed: () async {
                                  if (!context.mounted) return;
                                  context
                                      .read<CloseClinicTodayCubit>()
                                      .closeClinicToday(
                                        doctorId:
                                            sharedPreferences
                                                .getAuth()
                                                ?.doctor
                                                ?.id ??
                                            '',
                                      );
                                },
                              );
                            },
                          ),
                        ),

                      if (home?.doctorClosedToday != true) Gaps.vGap16,

                      /// reschedule
                      MyDefaultButton(
                        btnText: "reschedule_clinic",

                        borderRadius: 30,

                        height: 54.h,

                        color: colors.whiteColor,

                        textColor: colors.textColor,

                        borderColor: colors.main,

                        onPressed: () {
                          context.push(
                            Routes.rescheduleAppointmentsScreenRoute,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Gaps.vGap24,

                /// stats
                DoctorStatCard(
                  title: "today_appointments".tr,

                  value: home?.statistics?.todayAppointmentsCount ?? '0',

                  subtitle: "appointment".tr,

                  icon: Icons.calendar_month_outlined,

                  color: colors.main,
                ),

                Gaps.vGap16,

                DoctorStatCard(
                  title: "arrived_patients".tr,

                  value: home?.statistics?.todayArrivedCount ?? '0',

                  subtitle: "patient".tr,

                  icon: Icons.groups_2_outlined,

                  color: colors.secondary,
                ),

                Gaps.vGap16,

                DoctorStatCard(
                  title: "entered_patients".tr,

                  value: home?.statistics?.todayEnteredCount ?? '0',

                  subtitle: "patient".tr,

                  icon: Icons.fact_check_outlined,

                  color: Colors.deepOrange,
                ),

                Gaps.vGap16,

                DoctorStatCard(
                  title: "upcoming_appointments".tr,

                  value: home?.statistics?.upcomingAppointmentsCount ?? '0',

                  subtitle: "appointment".tr,

                  icon: Icons.watch_later_outlined,

                  color: Colors.indigo,
                ),

                Gaps.vGap20,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,

      highlightColor: Colors.grey[100]!,

      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),

        child: Column(
          children: [
            Container(
              height: 320.h,

              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(24.r),
              ),
            ),

            Gaps.vGap24,

            ...List.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),

                child: Container(
                  height: 110.h,

                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(22.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorStatCard extends StatelessWidget {
  final String title;

  final String value;

  final String subtitle;

  final IconData icon;

  final Color color;

  const DoctorStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(18.w),

      decoration: BoxDecoration(
        color: colors.whiteColor,

        borderRadius: BorderRadius.circular(22.r),
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),

            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),

              borderRadius: BorderRadius.circular(18.r),
            ),

            child: Icon(icon, color: color, size: 30.sp),
          ),

          Gaps.hGap16,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: TextStyles.medium18(color: colors.main)),

                Gaps.vGap12,

                Row(
                  children: [
                    Text(
                      value,

                      style: TextStyles.bold20(color: colors.textColor),
                    ),

                    Gaps.hGap8,

                    Text(
                      subtitle,

                      style: TextStyles.medium16(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

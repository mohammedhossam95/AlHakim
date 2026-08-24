import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/appointments/presentation/cubt/export_appointments_cubit/export_appointments_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_home_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/close_clinic_today_cubit/close_clinic_today_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_home_cubit/get_doctor_home_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggle_clinic_cubit/toggle_clinic_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class ClinicHomeScreen extends StatefulWidget {
  const ClinicHomeScreen({super.key});

  @override
  State<ClinicHomeScreen> createState() => _ClinicHomeScreenState();
}

class _ClinicHomeScreenState extends State<ClinicHomeScreen> {
  DoctorHomeEntity? home;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      getDoctorHome();
    });
  }

  Future<void> getDoctorHome() async {
    log("getDoctorHome");
    final doctorId = _activeDoctorId(context);
    if (doctorId == null || doctorId.isEmpty) return;
    context.read<GetDoctorHomeCubit>().getDoctorHome(doctorId);
  }

  String? _activeDoctorId(BuildContext context) {
    final sessionState = context.read<SessionCubit>().state;

    if (sessionState.doctorAccountMode == DoctorAccountMode.singleDoctor) {
      final auth = sharedPreferences.getAuth();
      return auth?.doctor?.id;
    }

    return sessionState.activeDoctorId;
  }

  Future<void> _onExportPressed() async {
    final confirmed = await Constants.showConfirmDialog(
      context: context,
      title: 'confirm_export_data'.tr,
      content: 'confirm_export_data_message'.tr,
      yesText: 'yes',
      noText: 'no',
    );

    if (confirmed != true || !mounted) return;

    context.read<ExportAppointmentsCubit>().exportAppointments();
  }

  // final today = DateTime.now().weekday;
  final today = DateTime.now().weekday % 7;
  @override
  Widget build(BuildContext context) {
    final sessionState = context.watch<SessionCubit>().state;
    final displayDoctor =
        sessionState.selectedDoctor ?? sharedPreferences.getAuth()?.doctor;

    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        title: Row(
          children: [
            if (displayDoctor?.profileImage != null) ...[
              DiffImage(
                image: displayDoctor?.profileImage ?? '',

                height: 40.h,

                width: 40.w,
              ),
              Gaps.hGap12,
            ],
            Expanded(
              child: Text("${"welcome".tr} ${displayDoctor?.name?.ar ?? ''}"),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          if (sessionState.isMedicalCenterDoctorAccount &&
              sessionState.activeDoctorId != null)
            IconButton(
              tooltip: 'doctors'.tr,
              onPressed: () {
                context.read<SessionCubit>().clearSelectedDoctor();
                context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);
              },
              icon: const Icon(Icons.swap_horiz),
            ),
        ],
      ),

      body: MultiBlocListener(
        listeners: [
          BlocListener<ExportAppointmentsCubit, ExportAppointmentsState>(
            listener: (context, state) async {
              if (state is ExportAppointmentsLoading) {
                Constants.showLoading(context);
              } else if (state is ExportAppointmentsSuccess) {
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  type: 1,
                  message: 'export_data_success'.tr,
                );
                await SharePlus.instance.share(
                  ShareParams(files: [XFile(state.filePath)]),
                );
              } else if (state is ExportAppointmentsError) {
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  type: 3,
                  message: state.message,
                );
              }
            },
          ),
        ],
        child: BlocConsumer<GetDoctorHomeCubit, GetDoctorHomeState>(
        listener: (context, state) {
          if (state is GetDoctorHomeSuccess) {
            home = state.response.data as DoctorHomeEntity;
          }
        },
        builder: (context, state) {
          if (state is GetDoctorHomeLoading) {
            return _buildShimmer();
          }

          if (state is GetDoctorHomeError) {
            return Center(child: Text(state.message));
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
                      if (home?.doctor?.schedules?.any(
                            (schedule) => schedule.dayOfWeek == today,
                          ) ==
                          true) ...[
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

                                getDoctorHome();
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
                                    final doctorId = _activeDoctorId(context);
                                    if (doctorId == null || doctorId.isEmpty) {
                                      return;
                                    }
                                    context
                                        .read<ToggleClinicCubit>()
                                        .toggleClinic(doctorId: doctorId);
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

                                getDoctorHome();
                              }
                            },

                            child: MyDefaultButton(
                              btnText: "close_clinic_today",
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
                                    final doctorId = _activeDoctorId(context);
                                    if (doctorId == null || doctorId.isEmpty) {
                                      return;
                                    }
                                    context
                                        .read<CloseClinicTodayCubit>()
                                        .closeClinicToday(doctorId: doctorId);
                                  },
                                );
                              },
                            ),
                          ),
                      ] else ...[
                        Text(
                          "doctor_closed_today".tr,
                          style: TextStyles.bold22(
                            color: colors.lightTextColor,
                          ),
                        ),
                        Gaps.vGap16,
                      ],
                      if (home?.doctorClosedToday != true) Gaps.vGap16,

                      /// reschedule
                      MyDefaultButton(
                        btnText: "reschedule_clinic",
                        borderRadius: 30,
                        color: colors.whiteColor,
                        textColor: colors.textColor,
                        borderColor: colors.main,
                        onPressed: () {
                          context.push(
                            Routes.rescheduleAppointmentsScreenRoute,
                          );
                        },
                      ),
                      Gaps.vGap16,
                      MyDefaultButton(
                        btnText: "export_data",
                        borderRadius: 30,
                        color: colors.whiteColor,
                        textColor: colors.textColor,
                        borderColor: colors.main,
                        onPressed: _onExportPressed,
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
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(22.r),
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
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

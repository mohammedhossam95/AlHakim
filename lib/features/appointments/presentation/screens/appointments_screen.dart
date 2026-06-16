import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/appointments/presentation/cubt/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_appointments/get_appointments_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetAppointmentsCubit>().getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        backgroundColor: colors.backGround,

        appBar: AppBar(
          title: Text("appointments".tr),

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),

            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

              decoration: BoxDecoration(
                color: colors.whiteColor,

                borderRadius: BorderRadius.circular(30.r),
              ),

              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,

                indicator: BoxDecoration(
                  color: colors.main,

                  borderRadius: BorderRadius.circular(30.r),
                ),

                labelColor: colors.whiteColor,

                unselectedLabelColor: colors.textColor,

                tabs: [
                  Tab(text: "upcoming".tr),

                  Tab(text: "previous".tr),
                ],
              ),
            ),
          ),
        ),

        body: BlocListener<CancelAppointmentCubit, CancelAppointmentState>(
          listener: (context, state) {
            if (state is CancelAppointmentLoading) {
              Constants.showLoading(context);
            } else if (state is CancelAppointmentSuccess) {
              Constants.hideLoading(context);
              Constants.showSnakToast(
                message: state.response.message ?? '',
                context: context,
                type: 1,
              );
              context.read<GetAppointmentsCubit>().getAppointments();
            } else if (state is CancelAppointmentError) {
              Constants.hideLoading(context);
              Constants.showSnakToast(
                message: state.message,
                context: context,
                type: 3,
              );
            }
          },
          child: BlocBuilder<GetAppointmentsCubit, GetAppointmentsState>(
            builder: (context, state) {
              if (state is GetAppointmentsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetAppointmentsError) {
                return Center(
                  child: ErrorText(
                    text: state.message,
                    width: 300,
                    // onRetry: () =>
                    //     context.read<GetAppointmentsCubit>().getAppointments(),
                  ),
                );
              }

              List<AppointmentEntity> appointments = [];

              if (state is GetAppointmentsSuccess) {
                appointments = state.response.data as List<AppointmentEntity>;
              }

              final upcoming = appointments
                  .where((e) => e.status == "confirmed")
                  .toList();

              final previous = appointments
                  .where((e) => e.status != "confirmed")
                  .toList();

              return TabBarView(
                children: [
                  _AppointmentsList(data: upcoming),

                  _AppointmentsList(data: previous),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final List<AppointmentEntity> data;

  const _AppointmentsList({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text("no_appointments".tr, style: TextStyles.medium14()),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),

      itemCount: data.length,

      separatorBuilder: (_, _) => Gaps.vGap12,

      itemBuilder: (context, index) {
        return _AppointmentCard(data[index]);
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentEntity item;

  const _AppointmentCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),

      decoration: BoxDecoration(
        color: colors.whiteColor,

        borderRadius: BorderRadius.circular(16.r),
      ),

      child: Column(
        children: [
          Row(
            children: [
              DiffImage(
                image: item.doctor?.profileImage ?? '',

                width: 50.w,

                height: 50.h,
                isCircle: true,
              ),

              Gaps.hGap10,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.doctor?.name ?? '',

                      style: TextStyles.semiBold16(),
                    ),

                    Gaps.vGap8,

                    Text(
                      item.doctor?.specialty?.name ?? '',

                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),

                decoration: BoxDecoration(
                  color: item.status == "confirmed"
                      ? colors.success.withValues(alpha: .2)
                      : colors.error.withValues(alpha: .2),

                  borderRadius: BorderRadius.circular(20.r),
                ),

                child: Text(
                  item.status == "confirmed" ? "حجز مؤكد" : "ملغي",

                  style: TextStyles.medium12(
                    color: item.status == "confirmed"
                        ? colors.success
                        : colors.error,
                  ),
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  title: "date".tr,

                  value: item.appointmentDate ?? '',

                  icon: Icons.calendar_today,
                ),
              ),

              Gaps.hGap10,
              Expanded(
                child: _InfoBox(
                  title: "الحالة",

                  value: item.status == "confirmed" ? "حجز مؤكد" : "ملغاة",

                  icon: Icons.access_time,
                ),
              ),
            ],
          ),

          Gaps.vGap16,
          item.status == "confirmed"
              ? Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.push(Routes.followUpQueueScreenRoute,
                            extra: item,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),

                          decoration: BoxDecoration(
                            color: colors.main.withValues(alpha: 1),

                            borderRadius: BorderRadius.circular(10.r),
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            "follow_up_appointment".tr,

                            style: TextStyles.medium14(
                              color: colors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.hGap10,

                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Constants.showConfirmDialog(
                            context: context,
                            title: "cancel_appointment".tr,
                            content: "cancel_appointment_desc".tr,
                            onYesPressed: () async {
                              if (!context.mounted) return;
                              context
                                  .read<CancelAppointmentCubit>()
                                  .cancelAppointment(
                                    appointmentId: item.id.toString(),
                                  );
                            },
                          );
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),

                          decoration: BoxDecoration(
                            color: colors.errorColor.withValues(alpha: .1),

                            borderRadius: BorderRadius.circular(10.r),
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            "cancel_appointment".tr,

                            style: TextStyles.medium14(
                              color: colors.errorColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),

      decoration: BoxDecoration(
        color: colors.lightBackGroundColor,

        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.main),

          Gaps.hGap8,

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: TextStyles.medium10()),

              Gaps.vGap8,

              Text(value, style: TextStyles.medium12()),
            ],
          ),
        ],
      ),
    );
  }
}

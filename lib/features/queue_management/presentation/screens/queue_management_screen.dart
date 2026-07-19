import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/queue_management/domain/entities/queue_management_entity.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/get_queue_management_cubit/get_queue_management_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/notify_examination_cubit/notify_examination_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/update_queue_status_cubit/update_queue_status_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class QueueManagementScreen extends StatefulWidget {
  const QueueManagementScreen({super.key});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen> {
  String? _activeDoctorId(BuildContext context) {
    return context.read<SessionCubit>().state.activeDoctorId;
  }

  void _loadQueue(BuildContext context) {
    final doctorId = _activeDoctorId(context);
    if (doctorId == null || doctorId.isEmpty) return;
    context.read<GetQueueManagementCubit>().getQueueManagement(
      doctorId: doctorId,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadQueue(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat(
      'EEEE، d MMMM',
      appLocalizations.isArLocale ? 'ar' : 'en',
    ).format(DateTime.now());

    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateQueueStatusCubit, UpdateQueueStatusState>(
          listener: (context, state) {
            if (state is UpdateQueueStatusLoading) {
              Constants.showLoading(context);
            }
            if (state is UpdateQueueStatusSuccess) {
              Constants.hideLoading(context);
              _loadQueue(context);
              Constants.showSnakToast(
                context: context,
                type: 1,
                message: state.response.message,
              );
            } else if (state is UpdateQueueStatusError) {
              Constants.hideLoading(context);
              Constants.showSnakToast(
                context: context,
                type: 3,
                message: state.message,
              );
            }
          },
        ),
        BlocListener<NotifyExaminationCubit, NotifyExaminationState>(
          listener: (context, state) {
            if (state is NotifyExaminationSuccess) {
              Constants.showSnakToast(
                context: context,
                type: 1,
                message: state.response.message,
              );
            } else if (state is NotifyExaminationError) {
              Constants.showSnakToast(
                context: context,
                type: 3,
                message: state.message,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.backGround,

        floatingActionButton: FloatingActionButton(
          backgroundColor: colors.main,

          onPressed: () async {
            final result = await context.push(Routes.quickBookingScreenRoute);

            if (result == true) {
              if (!context.mounted) return;
              _loadQueue(context);
            }
          },

          child: Icon(Icons.add, color: colors.whiteColor),
        ),

        appBar: AppBar(title: Text("queue_management".tr)),

        body: BlocBuilder<GetQueueManagementCubit, GetQueueManagementState>(
          builder: (context, state) {
            if (state is GetQueueManagementLoading) {
              return _buildShimmer();
            }

            if (state is GetQueueManagementError) {
              return Center(child: Text(state.message));
            }

            List<QueueManagementEntity> queue = [];

            if (state is GetQueueManagementSuccess) {
              queue = state.response.data as List<QueueManagementEntity>;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// date
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,

                      vertical: 18.h,
                    ),

                    decoration: BoxDecoration(
                      color: colors.main.withValues(alpha: .08),

                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.calendar_today, color: colors.main),

                        Gaps.hGap10,

                        Text(
                          today,

                          style: TextStyles.medium16(color: colors.main),
                        ),
                      ],
                    ),
                  ),

                  Gaps.vGap24,

                  Row(
                    children: [
                      Expanded(
                        child: QueueStatCard(
                          title: "waiting_patients".tr,

                          value: queue.length.toString(),

                          icon: Icons.groups_2_outlined,

                          color: colors.main,
                        ),
                      ),

                      Gaps.hGap12,

                      Expanded(
                        child: QueueStatCard(
                          title: "current_role".tr,

                          value: queue
                              .where((e) => e.isCurrent == true)
                              .length
                              .toString(),

                          icon: Icons.timer_outlined,

                          color: colors.secondary,
                        ),
                      ),
                    ],
                  ),

                  Gaps.vGap20,

                  /// section title
                  Row(
                    children: [
                      Container(
                        width: 4.w,

                        height: 24.h,

                        decoration: BoxDecoration(
                          color: colors.main,

                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),

                      Gaps.hGap8,

                      Text("upcoming_roles".tr, style: TextStyles.semiBold16()),

                      const Spacer(),

                      Text(
                        queue.length.toString(),

                        style: TextStyles.medium14(color: colors.main),
                      ),
                    ],
                  ),

                  Gaps.vGap20,

                  if (queue.isEmpty)
                    SizedBox(
                      height: 400.h,
                      width: 400,
                      child: Center(
                        child: ErrorText(width: 300, text: "noData".tr),
                      ),
                    ),

                  if (queue.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: queue.length,

                      separatorBuilder: (_, _) => Gaps.vGap16,

                      itemBuilder: (context, index) {
                        return QueuePatientCard(item: queue[index]);
                      },
                    ),

                  Gaps.vGap60,
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
              height: 80.h,

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(18.r),
              ),
            ),

            Gaps.vGap24,

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120.h,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                ),

                Gaps.hGap12,

                Expanded(
                  child: Container(
                    height: 120.h,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                ),
              ],
            ),

            Gaps.vGap20,

            ...List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),

                child: Container(
                  height: 220.h,

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

class QueueStatCard extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  final Color color;

  const QueueStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),

      decoration: BoxDecoration(
        color: colors.whiteColor,

        borderRadius: BorderRadius.circular(22.r),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: EdgeInsets.all(12.w),

            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),

              borderRadius: BorderRadius.circular(14.r),
            ),

            child: Icon(icon, color: color),
          ),

          Gaps.vGap12,

          Text(title, style: TextStyles.medium16()),

          Gaps.vGap8,

          Text(value, style: TextStyles.bold22(color: color)),
        ],
      ),
    );
  }
}

class QueuePatientCard extends StatelessWidget {
  final QueueManagementEntity item;

  const QueuePatientCard({super.key, required this.item});

  Color getStatusColor(String status) {
    switch (status) {
      case "arrived":
        return colors.secondary;

      case "entered":
        return Colors.deepOrange;

      case "completed":
        return Colors.green;

      case "rescheduled":
        return Colors.indigo;

      default:
        return colors.lightTextColor;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case "arrived":
        return "arrived".tr;

      case "entered":
        return "enterd".tr;

      case "completed":
        return "completed".tr;

      case "rescheduled":
        return "rescheduled".tr;

      default:
        return "waiting_arrival".tr;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "arrived":
        return Icons.check_circle_outline;

      case "enterd":
        return Icons.local_hospital_outlined;

      case "completed":
        return Icons.task_alt_outlined;

      case "rescheduled":
        return Icons.event_repeat_outlined;

      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = item.isCurrent == true;

    final status = item.status ?? "waiting";

    final statusColor = getStatusColor(status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),

      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: isCurrent
            ? colors.main.withValues(alpha: .08)
            : colors.whiteColor,

        borderRadius: BorderRadius.circular(22.r),

        border: isCurrent ? Border.all(color: colors.main, width: 1.5) : null,
      ),

      child: Column(
        children: [
          if (isCurrent) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: colors.main,
                borderRadius: BorderRadius.circular(14.r),
              ),

              child: Text(
                "current_role".tr,
                textAlign: TextAlign.center,
                style: TextStyles.semiBold14(color: colors.whiteColor),
              ),
            ),
            Gaps.vGap16,
          ],
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

                decoration: BoxDecoration(
                  color: colors.main.withValues(alpha: .1),

                  borderRadius: BorderRadius.circular(18.r),
                ),

                child: Column(
                  children: [
                    Text(
                      "role".tr,
                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),
                    Gaps.vGap4,
                    Text(
                      item.queuePosition ?? '',
                      style: TextStyles.bold20(color: colors.main),
                    ),
                  ],
                ),
              ),

              Gaps.hGap12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.patient?.kinship == null
                          ? item.patient?.fullPatientName ?? ''
                          : item.patient?.fullName ?? '',
                      style: TextStyles.semiBold18(),
                    ),

                    Gaps.vGap8,

                    InkWell(
                      onTap: () {
                        final isPatient = item.patient?.kinship == null;
                        final countryCode = isPatient
                            ? item.patient?.countryCode ?? ''
                            : item.bookedBy?.countryCode ?? '';
                        final phoneNumber = isPatient
                            ? item.patient?.phoneNumber ?? ''
                            : item.bookedBy?.phoneNumber ?? '';
                        if (phoneNumber.isEmpty) return;
                        Constants.makePhoneCall('$countryCode$phoneNumber');
                      },
                      child: Text(
                        item.patient?.kinship == null
                            ? "${item.patient?.countryCode ?? ''}${item.patient?.phoneNumber ?? ''}"
                            : "${item.bookedBy?.countryCode ?? ''}${item.bookedBy?.phoneNumber ?? ''}",
                        style: TextStyles.medium12(
                          color: colors.lightTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gaps.hGap10,

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),

                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .12),

                  borderRadius: BorderRadius.circular(16.r),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(
                      getStatusIcon(status),

                      size: 16.sp,

                      color: statusColor,
                    ),

                    Gaps.hGap6,

                    Text(
                      getStatusText(status),

                      style: TextStyles.medium12(color: statusColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          if (item.patient?.kinship != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.main.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16.sp,
                    color: colors.lightTextColor,
                  ),
                  Gaps.hGap10,
                  Text(
                    item.bookedBy?.fullPatientName ?? '',
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                  Spacer(),
                  Text(
                    item.patient?.kinship?.label ?? '',
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),
          ],
          Gaps.vGap20,
          Gaps.line,
          Gaps.vGap20,
          Row(
            children: [
              Expanded(
                child: QueueActionButton(
                  icon: Icons.call,

                  color: colors.main,

                  onTap: () {
                    final isPatient = item.patient?.kinship == null;
                    final countryCode = isPatient
                        ? item.patient?.countryCode ?? ''
                        : item.bookedBy?.countryCode ?? '';
                    final phoneNumber = isPatient
                        ? item.patient?.phoneNumber ?? ''
                        : item.bookedBy?.phoneNumber ?? '';
                    if (phoneNumber.isEmpty) return;
                    Constants.makePhoneCall('$countryCode$phoneNumber');
                  },
                ),
              ),

              Gaps.hGap12,
              Expanded(
                child:
                    BlocBuilder<NotifyExaminationCubit, NotifyExaminationState>(
                      builder: (context, state) {
                        final appointmentId = (item.id ?? 0).toString();
                        final isLoading =
                            state is NotifyExaminationLoading &&
                            state.appointmentId == appointmentId;

                        return QueueActionButton(
                          icon: Icons.notification_important_outlined,
                          color: colors.main,
                          isSelected: true,
                          isLoading: isLoading,
                          onTap: () {
                            if (isLoading) return;
                            context
                                .read<NotifyExaminationCubit>()
                                .notifyExamination(
                                  appointmentId: appointmentId,
                                );
                          },
                        );
                      },
                    ),
              ),
              Gaps.hGap12,

              Expanded(
                child: PopupMenuButton<String>(
                  onSelected: (value) async {
                    final doctorId = context
                        .read<SessionCubit>()
                        .state
                        .activeDoctorId;
                    if (doctorId == null || doctorId.isEmpty) return;

                    await context
                        .read<UpdateQueueStatusCubit>()
                        .updateQueueStatus(
                          doctorId: doctorId,

                          appointmentId: item.id ?? 0,

                          status: value,
                        );
                    if (!context.mounted) return;
                    final activeDoctorId = context
                        .read<SessionCubit>()
                        .state
                        .activeDoctorId;
                    if (activeDoctorId == null || activeDoctorId.isEmpty) {
                      return;
                    }
                    context.read<GetQueueManagementCubit>().getQueueManagement(
                      doctorId: activeDoctorId,
                    );
                  },

                  color: colors.whiteColor,

                  elevation: 5,

                  offset: const Offset(0, 50),

                  initialValue: status,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),

                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "arrived",

                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,

                            color: colors.secondary,
                          ),

                          Gaps.hGap10,

                          Text("arrived".tr),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: "entered",

                      child: Row(
                        children: [
                          Icon(
                            Icons.local_hospital_outlined,

                            color: Colors.deepOrange,
                          ),

                          Gaps.hGap10,

                          Text("enterd".tr),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: "completed",

                      child: Row(
                        children: [
                          Icon(Icons.task_alt_outlined, color: Colors.green),

                          Gaps.hGap10,

                          Text("completed".tr),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: "rescheduled",

                      child: Row(
                        children: [
                          Icon(
                            Icons.event_repeat_outlined,

                            color: Colors.indigo,
                          ),

                          Gaps.hGap10,

                          Text("rescheduled".tr),
                        ],
                      ),
                    ),
                  ],

                  child: Container(
                    height: 52.h,

                    decoration: BoxDecoration(
                      color: colors.backGround,

                      borderRadius: BorderRadius.circular(16.r),
                    ),

                    child: Icon(
                      Icons.more_horiz_rounded,

                      color: colors.lightTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// rescheduled , arrived , entered , completed

class QueueActionButton extends StatelessWidget {
  final IconData icon;

  final Color color;

  final bool isSelected;

  final bool isLoading;

  final VoidCallback onTap;

  const QueueActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSelected = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,

      child: Container(
        height: 52.h,

        decoration: BoxDecoration(
          color: isSelected
              ? colors.main.withValues(alpha: .08)
              : colors.backGround,

          borderRadius: BorderRadius.circular(16.r),
        ),

        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Icon(icon, color: color),
        ),
      ),
    );
  }
}

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/notifications_icon_button.dart';
import 'package:alhakim/core/widgets/shimmer/appointments_list_shimmer.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/appointments/presentation/cubt/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_appointments/get_appointments_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/update_queue_status_cubit/update_queue_status_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  static const _upcomingStatuses = {
    'confirmed',
    'arrived',
    'entered',
    'rescheduled',
    'pending_reschedule',
  };

  static const _previousStatuses = {'completed', 'cancelled'};

  /// Patient appointments tab index in [MainPage].
  static const _appointmentsTabIndex = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchAppointments();
    });
  }

  void _fetchAppointments({bool showLoading = true}) {
    final sessionState = context.read<SessionCubit>().state;
    if (sessionState.status != SessionStatus.authenticated) return;
    context.read<GetAppointmentsCubit>().getAppointments(
      showLoading: showLoading,
    );
  }

  Future<void> _onRefresh() {
    return context.read<GetAppointmentsCubit>().getAppointments(
      showLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomNavBarCubit, BottomNavBarState>(
      listenWhen: (previous, current) =>
          current.index == _appointmentsTabIndex &&
          previous.tapId != current.tapId,
      listener: (context, state) {
        _fetchAppointments();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: colors.backGround,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'appointments'.tr,
                          style: TextStyles.semiBold18(),
                        ),
                      ),
                      const NotificationsIconButton(),
                    ],
                  ),
                ),
                Container(
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
                      Tab(text: 'upcoming'.tr),
                      Tab(text: 'previous'.tr),
                    ],
                  ),
                ),
                Expanded(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<
                        CancelAppointmentCubit,
                        CancelAppointmentState
                      >(
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
                            context
                                .read<GetAppointmentsCubit>()
                                .getAppointments();
                          } else if (state is CancelAppointmentError) {
                            Constants.hideLoading(context);
                            Constants.showSnakToast(
                              message: state.message,
                              context: context,
                              type: 3,
                            );
                          }
                        },
                      ),
                      BlocListener<
                        UpdateQueueStatusCubit,
                        UpdateQueueStatusState
                      >(
                        listener: (context, state) {
                          if (state is UpdateQueueStatusLoading) {
                            Constants.showLoading(context);
                          } else if (state is UpdateQueueStatusSuccess) {
                            Constants.hideLoading(context);
                            Constants.showSnakToast(
                              message: state.response.message ?? '',
                              context: context,
                              type: 1,
                            );
                            context
                                .read<GetAppointmentsCubit>()
                                .getAppointments();
                          } else if (state is UpdateQueueStatusError) {
                            Constants.hideLoading(context);
                            Constants.showSnakToast(
                              message: state.message,
                              context: context,
                              type: 3,
                            );
                          }
                        },
                      ),
                    ],
                    child:
                        BlocBuilder<GetAppointmentsCubit, GetAppointmentsState>(
                          builder: (context, state) {
                            if (state is GetAppointmentsLoading) {
                              return const AppointmentsListShimmer();
                            }

                            if (state is GetAppointmentsError) {
                              return RefreshIndicator(
                                color: colors.main,
                                onRefresh: _onRefresh,
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(height: 120.h),
                                    ErrorText(text: state.message, width: 300),
                                  ],
                                ),
                              );
                            }

                            List<AppointmentEntity> appointments = [];

                            if (state is GetAppointmentsSuccess) {
                              appointments =
                                  state.response.data
                                      as List<AppointmentEntity>;
                            }

                            final upcoming = appointments
                                .where(
                                  (e) => _upcomingStatuses.contains(
                                    e.status?.toLowerCase().trim(),
                                  ),
                                )
                                .toList();

                            final previous = appointments
                                .where(
                                  (e) => _previousStatuses.contains(
                                    e.status?.toLowerCase().trim(),
                                  ),
                                )
                                .toList();

                            return TabBarView(
                              children: [
                                _AppointmentsList(
                                  data: upcoming,
                                  isUpcoming: true,
                                  onRefresh: _onRefresh,
                                ),
                                _AppointmentsList(
                                  data: previous,
                                  isUpcoming: false,
                                  onRefresh: _onRefresh,
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final List<AppointmentEntity> data;
  final bool isUpcoming;
  final Future<void> Function() onRefresh;

  const _AppointmentsList({
    required this.data,
    required this.isUpcoming,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: colors.main,
      onRefresh: onRefresh,
      child: data.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 120.h),
                Center(
                  child: Text(
                    'no_appointments'.tr,
                    style: TextStyles.medium14(),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              itemCount: data.length,
              separatorBuilder: (_, _) => Gaps.vGap12,
              itemBuilder: (context, index) {
                return _AppointmentCard(
                  item: data[index],
                  isUpcoming: isUpcoming,
                );
              },
            ),
    );
  }
}

class _AppointmentStatusStyle {
  final String label;
  final Color color;

  const _AppointmentStatusStyle({required this.label, required this.color});

  static _AppointmentStatusStyle of(String? status) {
    switch (status?.toLowerCase().trim()) {
      case 'confirmed':
        return _AppointmentStatusStyle(
          label: 'confirmed'.tr,
          color: colors.success,
        );
      case 'arrived':
        return _AppointmentStatusStyle(label: 'arrived'.tr, color: colors.main);
      case 'entered':
        return _AppointmentStatusStyle(
          label: 'entered'.tr,
          color: colors.subTextColor,
        );
      case 'rescheduled':
        return _AppointmentStatusStyle(
          label: 'rescheduled'.tr,
          color: colors.review,
        );
      case 'pending_reschedule':
        return _AppointmentStatusStyle(
          label: 'pending_reschedule'.tr,
          color: const Color(0xFF6C5CE7),
        );
      case 'completed':
        return _AppointmentStatusStyle(
          label: 'completed'.tr,
          color: colors.success,
        );
      case 'cancelled':
        return _AppointmentStatusStyle(
          label: 'cancelled'.tr,
          color: colors.errorColor,
        );
      default:
        return _AppointmentStatusStyle(
          label: status?.tr ?? status ?? '',
          color: colors.lightTextColor,
        );
    }
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentEntity item;
  final bool isUpcoming;

  const _AppointmentCard({required this.item, required this.isUpcoming});

  String? get _status => item.status?.toLowerCase().trim();

  bool get _isPendingReschedule => _status == 'pending_reschedule';

  bool get _canCancel {
    return _status == 'confirmed' ||
        _status == 'rescheduled' ||
        _status == 'pending_reschedule';
  }

  bool get _canFollowUp {
    return _status == 'confirmed' ||
        _status == 'arrived' ||
        _status == 'entered' ||
        _status == 'rescheduled';
  }

  bool get _canConfirmReschedule => _isPendingReschedule;

  void _confirmReschedule(BuildContext context) {
    Constants.showConfirmDialog(
      context: context,
      title: 'confirm_reschedule'.tr,
      content: 'confirm_reschedule_desc'.tr,
      onYesPressed: () async {
        if (!context.mounted) return;

        final doctorId = item.doctor?.id;
        final appointmentId = item.id;
        if (doctorId == null || doctorId.isEmpty || appointmentId == null) {
          Constants.showSnakToast(
            context: context,
            message: 'error_occurred'.tr,
            type: 3,
          );
          return;
        }

        context.read<UpdateQueueStatusCubit>().updateQueueStatus(
          doctorId: doctorId,
          appointmentId: appointmentId,
          status: 'confirmed',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _AppointmentStatusStyle.of(item.status);
    final showPrimaryAction = _canFollowUp || _canConfirmReschedule;

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
                userName: appLocalizations.isArLocale
                    ? item.doctor?.name?.ar ?? ''
                    : item.doctor?.name?.en ?? '',
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
                      appLocalizations.isArLocale
                          ? item.doctor?.name?.ar ?? ''
                          : item.doctor?.name?.en ?? '',
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
                  color: statusStyle.color.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusStyle.label,
                  style: TextStyles.medium12(color: statusStyle.color),
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  title: DateFormat(
                    'EEEE',
                    appLocalizations.locale?.languageCode,
                  ).format(DateTime.parse(item.appointmentDate ?? '')),
                  value: DateFormat(
                    'd MMM yyyy',
                    appLocalizations.locale?.languageCode,
                  ).format(DateTime.parse(item.appointmentDate ?? '')),
                  icon: Icons.calendar_month_rounded,
                ),
              ),
              Gaps.hGap10,
              Expanded(
                child: _InfoBox(
                  title: 'appointment_type'.tr,
                  value:
                      item.appointmentTypeText ??
                      item.appointmentType?.name ??
                      '',
                  icon: Icons.info_outline,
                  valueColor: colors.textColor,
                ),
              ),
            ],
          ),
          if (isUpcoming && (showPrimaryAction || _canCancel)) ...[
            Gaps.vGap16,
            Row(
              children: [
                if (_canConfirmReschedule)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _confirmReschedule(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'confirm_reschedule'.tr,
                          style: TextStyles.medium14(color: colors.whiteColor),
                        ),
                      ),
                    ),
                  )
                else if (_canFollowUp)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final appointmentId = item.id;
                        if (appointmentId == null) return;

                        context.pushNamed(
                          Routes.followUpQueueScreenRoute,
                          pathParameters: {'appointmentId': '$appointmentId'},
                          extra: item,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: colors.main,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'follow_up_appointment'.tr,
                          style: TextStyles.medium14(color: colors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                if (showPrimaryAction && _canCancel) Gaps.hGap10,
                if (_canCancel)
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Constants.showConfirmDialog(
                          context: context,
                          title: 'cancel_appointment'.tr,
                          content: 'cancel_appointment_desc'.tr,
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
                          'cancel_appointment'.tr,
                          style: TextStyles.medium14(color: colors.errorColor),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.medium12()),
                Gaps.vGap2,
                Text(
                  value,
                  style: TextStyles.medium12(color: valueColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

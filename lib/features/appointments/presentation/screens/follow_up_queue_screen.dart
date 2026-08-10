import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/shimmer/follow_up_queue_shimmer.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/appointments/domain/entities/queue_status_entity.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_queue_status/get_queue_status_cubit.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/widgets/doctor_list_item.dart';
import 'package:alhakim/features/home/presentation/widgets/slider_part.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowUpQueueScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const FollowUpQueueScreen({super.key, required this.appointment});

  @override
  State<FollowUpQueueScreen> createState() => _FollowUpQueueScreenState();
}

class _FollowUpQueueScreenState extends State<FollowUpQueueScreen> {
  @override
  void initState() {
    super.initState();
    _fetchQueueStatus();
  }

  Future<void> _fetchQueueStatus() async {
    final id = widget.appointment.id?.toString();
    if (id == null) return;
    await context.read<GetQueueStatusCubit>().getQueueStatus(appointmentId: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text('follow_up_appointment'.tr)),
      body: BlocBuilder<GetQueueStatusCubit, GetQueueStatusState>(
        builder: (context, state) {
          if (state is GetQueueStatusLoading) {
            return const FollowUpQueueShimmer();
          }

          if (state is GetQueueStatusError) {
            return Center(
              child: ErrorText(
                text: state.message,
                width: 300,
                onRetry: _fetchQueueStatus,
              ),
            );
          }

          if (state is GetQueueStatusSuccess) {
            final queueStatus = state.response.data as QueueStatusEntity?;

            if (queueStatus == null) {
              return Center(
                child: ErrorText(
                  text: state.response.message ?? '',
                  width: 300,
                  onRetry: _fetchQueueStatus,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _fetchQueueStatus,
              child: _FollowUpQueueBody(
                appointment: widget.appointment,
                queueStatus: queueStatus,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _FollowUpQueueBody extends StatelessWidget {
  final AppointmentEntity appointment;
  final QueueStatusEntity queueStatus;

  const _FollowUpQueueBody({
    required this.appointment,
    required this.queueStatus,
  });

  bool get _clinicOpen => queueStatus.clinicOpen == true;

  String get _doctorName => appLocalizations.isArLocale
      ? appointment.doctor?.name?.ar ?? ''
      : appointment.doctor?.name?.en ?? '';

  @override
  Widget build(BuildContext context) {
    if (!_clinicOpen) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        children: [
          _OffersSliderSection(ads: queueStatus.ads ?? []),
          Gaps.vGap24,
          const _ClinicNotStartedAlert(),
        ],
      );
    }

    final queueData = _QueueUiData.from(
      appointment: appointment,
      queueStatus: queueStatus,
    );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      children: [
        _OffersSliderSection(ads: queueStatus.ads ?? []),
        Gaps.vGap16,

        // _AppointmentReferenceRow(
        //   statusLabel: queueData.statusLabel,
        //   statusColor: queueData.statusColor,
        //   appointmentNumber: queueData.appointmentNumber,
        // ),
        // Gaps.vGap16,
        _ClinicStartedBanner(doctorName: _doctorName),
        Gaps.vGap16,
        _QueueInfoRow(
          yourNumber: queueData.yourNumber,
          currentNumber: queueData.currentNumber,
        ),

        Gaps.vGap16,
        _EstimatedWaitCard(minutes: queueStatus.estimatedWaitMinutes ?? 0),
        Gaps.vGap16,
        DoctorListItem(
          doctor: appointment.doctor ?? DoctorEntity(),
          followUpView: true,
        ),
        Gaps.vGap24,
      ],
    );
  }
}

class _QueueUiData {
  final String currentNumber;
  final String yourNumber;
  final String appointmentNumber;
  final String statusLabel;
  final Color statusColor;

  const _QueueUiData({
    required this.currentNumber,
    required this.yourNumber,
    required this.appointmentNumber,
    required this.statusLabel,
    required this.statusColor,
  });

  factory _QueueUiData.from({
    required AppointmentEntity appointment,
    required QueueStatusEntity queueStatus,
  }) {
    final statusStyle = _AppointmentStatusStyle.of(appointment.status);

    return _QueueUiData(
      currentNumber: _QueueFormatter.formatNumber(
        queueStatus.currentQueueNumber,
      ),
      yourNumber: _QueueFormatter.formatNumber(queueStatus.yourQueueNumber),
      appointmentNumber: '#${appointment.id ?? '--'}',
      statusLabel: statusStyle.label,
      statusColor: statusStyle.color,
    );
  }
}

class _QueueFormatter {
  static String formatNumber(String? value) {
    if (value == null || value.isEmpty) return '--';
    final number = int.tryParse(value);
    if (number == null) return value;
    return number.toString().padLeft(2, '0');
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

class _ClinicNotStartedAlert extends StatelessWidget {
  const _ClinicNotStartedAlert();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors.textColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Gaps.vGap16,
          Icon(Icons.schedule_rounded, color: colors.error, size: 56.sp),
          Gaps.vGap16,
          Text(
            'clinic_not_started_title'.tr,
            style: TextStyles.semiBold18(color: colors.textColor),
            textAlign: TextAlign.center,
          ),
          Gaps.vGap12,
          Text(
            'clinic_not_started_message'.tr,
            style: TextStyles.regular14(color: colors.lightTextColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OffersSliderSection extends StatelessWidget {
  final List<Ad> ads;
  const _OffersSliderSection({required this.ads});

  @override
  Widget build(BuildContext context) {
    return SliderPart(list: ads);
  }
}

class _ClinicStartedBanner extends StatelessWidget {
  final String doctorName;

  const _ClinicStartedBanner({required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: colors.success,
              shape: BoxShape.circle,
            ),
          ),
          Gaps.hGap12,
          Expanded(
            child: Text(
              'doctor_started_examination'.tr,
              style: TextStyles.medium14(color: colors.success),
            ),
          ),
        ],
      ),
    );
  }
}

// class _AppointmentReferenceRow extends StatelessWidget {
//   final String statusLabel;
//   final Color statusColor;
//   final String appointmentNumber;

//   const _AppointmentReferenceRow({
//     required this.statusLabel,
//     required this.statusColor,
//     required this.appointmentNumber,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'appointment_number'.tr,
//               style: TextStyles.medium12(color: colors.lightTextColor),
//             ),
//             Gaps.vGap4,
//             Text(
//               appointmentNumber,
//               style: TextStyles.semiBold18(color: colors.main),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//           decoration: BoxDecoration(
//             color: statusColor.withValues(alpha: 0.15),
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Text(
//             statusLabel,
//             style: TextStyles.medium12(color: statusColor),
//           ),
//         ),
//       ],
//     );
//   }
// }

class _CurrentQueueCard extends StatelessWidget {
  final String currentNumber;

  const _CurrentQueueCard({required this.currentNumber});

  bool get _hasActiveNumber {
    final value = currentNumber.trim();
    if (value.isEmpty || value == '--') return false;
    return int.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'current_status'.tr,
            style: TextStyles.medium14(color: colors.lightTextColor),
            textAlign: TextAlign.center,
          ),
          Gaps.vGap8,
          Text(currentNumber, style: TextStyles.semiBold40(color: colors.main)),
          if (_hasActiveNumber) ...[
            Gaps.vGap8,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: colors.main.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'under_examination'.tr,
                    style: TextStyles.medium12(color: colors.main),
                  ),
                  Gaps.hGap8,
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: colors.main,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QueueInfoRow extends StatelessWidget {
  final String yourNumber;
  final String currentNumber;

  const _QueueInfoRow({required this.yourNumber, required this.currentNumber});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.main,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'your_queue_number'.tr,
                    style: TextStyles.medium12(color: colors.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.vGap8,
                  Text(
                    yourNumber,
                    style: TextStyles.semiBold40(color: colors.whiteColor),
                  ),
                ],
              ),
            ),
          ),
          Gaps.hGap12,
          Expanded(child: _CurrentQueueCard(currentNumber: currentNumber)),
        ],
      ),
    );
  }
}

class _EstimatedWaitCard extends StatelessWidget {
  final int minutes;

  const _EstimatedWaitCard({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colors.main.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.access_time_rounded, color: colors.main),
          ),
          Gaps.hGap12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'expected_waiting_time'.tr,
                style: TextStyles.medium12(color: colors.lightTextColor),
              ),
              Gaps.vGap4,
              Text(
                'minutes_count'.trParams({'count': minutes.toString()}),
                style: TextStyles.semiBold16(color: colors.textColor),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_left, color: colors.lightTextColor, size: 22.sp),
        ],
      ),
    );
  }
}

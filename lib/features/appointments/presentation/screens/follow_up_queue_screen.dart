import 'dart:async';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/shimmer/follow_up_queue_shimmer.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/appointments/domain/entities/queue_status_entity.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_queue_status/get_queue_status_cubit.dart';
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
              onRefresh: () async {
                await _fetchQueueStatus();
              },
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

  String _formatQueueNumber(String? value) {
    if (value == null || value.isEmpty) return '--';
    final number = int.tryParse(value);
    if (number == null) return value;
    return number.toString().padLeft(2, '0');
  }

  int _parseQueueNumber(String? value) {
    return int.tryParse(value ?? '') ?? 0;
  }

  // String _arabicOrdinal(int number) {
  //   const ordinals = {
  //     1: 'الأول',
  //     2: 'الثاني',
  //     3: 'الثالث',
  //     4: 'الرابع',
  //     5: 'الخامس',
  //     6: 'السادس',
  //     7: 'السابع',
  //     8: 'الثامن',
  //     9: 'التاسع',
  //     10: 'العاشر',
  //   };
  //   return ordinals[number] ?? number.toString();
  // }

  String _positionText() {
    final position = (queueStatus.patientsAhead ?? 0) + 1;
    return 'position_ordinal'.trParams({
      // 'ordinal': _arabicOrdinal(position),
      'number': position.toString(),
    });
  }

  double _progressValue() {
    final current = _parseQueueNumber(queueStatus.currentQueueNumber);
    final goal = _parseQueueNumber(queueStatus.yourQueueNumber);
    if (goal <= 0) return 0;
    return (current / goal).clamp(0.0, 1.0);
  }

  Future<void> _callClinic() async {
    final phone = appointment.doctor?.clinicPhone;
    if (phone == null || phone.isEmpty) return;
    await Constants.makePhoneCall("${"20"}$phone");
  }

  @override
  Widget build(BuildContext context) {
    final currentNumber = _formatQueueNumber(queueStatus.currentQueueNumber);
    final yourNumber = _formatQueueNumber(queueStatus.yourQueueNumber);
    final examinedCurrent = _parseQueueNumber(queueStatus.currentQueueNumber);
    final examinedTotal = _parseQueueNumber(queueStatus.yourQueueNumber);
    final estimatedMinutes = queueStatus.estimatedWaitMinutes ?? 0;
    final showAlert = queueStatus.clinicStarted == true;
    final showSoonBanner =
        queueStatus.isCurrent == true || (queueStatus.patientsAhead ?? 0) <= 3;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showAlert) ...[
            _LiveAlertBanner(
              doctorName: appLocalizations.isArLocale
                  ? appointment.doctor?.name?.ar ?? ''
                  : appointment.doctor?.name?.en ?? '',
            ),
            Gaps.vGap16,
          ],
          _QueueStatusCard(
            currentNumber: currentNumber,
            yourNumber: yourNumber,
            positionText: _positionText(),
            showSoonBanner: showSoonBanner,
          ),
          Gaps.vGap16,
          _TurnProgressSection(
            examinedCurrent: examinedCurrent,
            examinedTotal: examinedTotal,
            progressValue: _progressValue(),
            yourNumber: yourNumber,
          ),
          Gaps.vGap16,
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.hourglass_bottom_rounded,
                  iconColor: colors.main,
                  label: 'estimated_time'.tr,
                  value: 'minutes_count'.trParams({
                    'count': estimatedMinutes.toString(),
                  }),
                  valueColor: colors.main,
                ),
              ),
              Gaps.hGap12,
              Expanded(
                child: _InfoCard(
                  icon: Icons.medical_services_outlined,
                  iconColor: colors.secondary,
                  label: 'your_follow_up_doctor'.tr,
                  value: appLocalizations.isArLocale
                      ? appointment.doctor?.name?.ar ?? ''
                      : appointment.doctor?.name?.en ?? '',
                  valueColor: colors.textColor,
                ),
              ),
            ],
          ),
          Gaps.vGap24,
          GestureDetector(
            onTap: _callClinic,
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: colors.main,
                borderRadius: BorderRadius.circular(30.r),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, color: colors.whiteColor, size: 20.sp),
                  Gaps.hGap8,
                  Text(
                    'call_clinic'.tr,
                    style: TextStyles.semiBold16(color: colors.whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveAlertBanner extends StatelessWidget {
  final String doctorName;

  const _LiveAlertBanner({required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(color: colors.secondary, width: 4.w),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: colors.secondary,
            size: 24.sp,
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'live_alert'.tr,
                  style: TextStyles.semiBold16(color: colors.secondary),
                ),
                Gaps.vGap4,
                Text(
                  'doctor_started_examination'.trParams({'doctor': doctorName}),
                  style: TextStyles.regular14(color: colors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueStatusCard extends StatelessWidget {
  final String currentNumber;
  final String yourNumber;
  final String positionText;
  final bool showSoonBanner;

  const _QueueStatusCard({
    required this.currentNumber,
    required this.yourNumber,
    required this.positionText,
    required this.showSoonBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
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
          Text(
            'current_status'.tr,
            style: TextStyles.medium14(color: colors.lightTextColor),
          ),
          Gaps.vGap8,
          Text(currentNumber, style: TextStyles.semiBold40(color: colors.main)),
          Gaps.vGap4,
          Text(
            'current_clinic_turn'.tr,
            style: TextStyles.medium14(color: colors.lightTextColor),
          ),
          Gaps.vGap16,
          Divider(color: colors.lightBackGroundColor, height: 1),
          Gaps.vGap16,
          Row(
            children: [
              Expanded(
                child: _QueueInfoColumn(
                  label: 'your_queue_number'.tr,
                  value: yourNumber,
                  valueColor: colors.secondary,
                ),
              ),
              Container(
                width: 1,
                height: 48.h,
                color: colors.lightBackGroundColor,
              ),
              Expanded(
                child: _QueueInfoColumn(
                  label: 'your_position_in_list'.tr,
                  value: positionText,
                  valueColor: colors.textColor,
                ),
              ),
            ],
          ),
          if (showSoonBanner) ...[
            Gaps.vGap16,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: colors.main.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: colors.main,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gaps.hGap8,
                  Flexible(
                    child: Text(
                      'please_be_at_clinic_soon'.tr,
                      style: TextStyles.medium14(color: colors.main),
                      textAlign: TextAlign.center,
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

class _QueueInfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _QueueInfoColumn({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyles.medium12(color: colors.lightTextColor),
          textAlign: TextAlign.center,
        ),
        Gaps.vGap8,
        Text(
          value,
          style: TextStyles.semiBold18(color: valueColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TurnProgressSection extends StatelessWidget {
  final int examinedCurrent;
  final int examinedTotal;
  final double progressValue;
  final String yourNumber;

  const _TurnProgressSection({
    required this.examinedCurrent,
    required this.examinedTotal,
    required this.progressValue,
    required this.yourNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('turn_progress'.tr, style: TextStyles.semiBold16()),
            Text(
              'examined_count'.trParams({
                'current': examinedCurrent.toString(),
                'total': examinedTotal.toString(),
              }),
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
          ],
        ),
        Gaps.vGap12,
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 10.h,
            backgroundColor: colors.lightBackGroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(colors.main),
          ),
        ),
        Gaps.vGap8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '01',
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
            Text(
              'the_beginning'.tr,
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
            Text(
              'your_goal'.trParams({'number': yourNumber}),
              style: TextStyles.semiBold14(color: colors.secondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28.sp),
          Gaps.vGap10,
          Text(
            label,
            style: TextStyles.medium12(color: colors.lightTextColor),
            textAlign: TextAlign.center,
          ),
          Gaps.vGap8,
          Text(
            value,
            style: TextStyles.semiBold16(color: valueColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

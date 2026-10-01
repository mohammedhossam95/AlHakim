import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/booking/domain/entities/schedule.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Shows the selected booking day and the clinic's working hours on it.
class SelectedBookingDateCard extends StatelessWidget {
  final AvailableBookingDate booking;

  const SelectedBookingDateCard({super.key, required this.booking});

  /// "14:30:00" -> "02:30 مساء". Returns "--" for a missing or bad value
  /// instead of throwing.
  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) : null;
    if (hour == null || minute == null) return '--';

    final date = DateTime(2025, 1, 1, hour, minute);

    final formattedHour = DateFormat('hh:mm', 'en').format(date);

    final period = date.hour >= 12
        ? (appLocalizations.isArLocale ? 'مساء' : 'PM')
        : (appLocalizations.isArLocale ? 'صباحاً' : 'AM');

    return "$formattedHour $period";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.main.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(20.r),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colors.main.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_month_rounded, color: colors.main),
              ),
              Gaps.hGap16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "selected_date".tr,
                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),
                    Gaps.vGap8,
                    Text(
                      DateFormat(
                        'EEEE, d MMM yyyy',
                        appLocalizations.locale?.languageCode,
                      ).format(booking.date),
                      style: TextStyles.medium14(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),

                decoration: BoxDecoration(
                  color: colors.secondary.withValues(alpha: .12),

                  shape: BoxShape.circle,
                ),

                child: Icon(Icons.access_time, color: colors.secondary),
              ),

              Gaps.hGap16,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "available_time".tr,

                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),

                    Gaps.vGap8,

                    Text(
                      "from_to_time".trParams({
                        "start": _formatTime(booking.schedule.startTime ?? ''),

                        "end": _formatTime(booking.schedule.endTime ?? ''),
                      }),

                      style: TextStyles.medium14(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/booking/domain/entities/schedule.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Horizontal list of the doctor's available days, with disabled days
/// (full or exceptions) greyed out and not tappable.
class BookingDatesSelector extends StatelessWidget {
  final List<AvailableBookingDate> dates;
  final int? selectedIndex;
  final bool Function(AvailableBookingDate booking) isDisabled;
  final ValueChanged<int> onSelected;

  const BookingDatesSelector({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.isDisabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dates.length, (index) {
          final bookingDate = dates[index];
          final date = bookingDate.date;
          final disabled = isDisabled(bookingDate);
          final isSelected = selectedIndex == index && !disabled;
          final isLast = index == dates.length - 1;

          final backgroundColor = disabled
              ? colors.lightTextColor.withValues(alpha: 0.08)
              : isSelected
              ? colors.main
              : colors.whiteColor;
          final borderColor = disabled
              ? colors.lightTextColor.withValues(alpha: 0.15)
              : isSelected
              ? colors.main
              : colors.main.withValues(alpha: .08);
          final primaryTextColor = disabled
              ? colors.lightTextColor.withValues(alpha: 0.45)
              : isSelected
              ? colors.whiteColor
              : colors.textColor;
          final secondaryTextColor = disabled
              ? colors.lightTextColor.withValues(alpha: 0.4)
              : isSelected
              ? colors.whiteColor
              : colors.lightTextColor;

          return Padding(
            padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 12.w),
            child: GestureDetector(
              onTap: disabled ? null : () => onSelected(index),
              child: Opacity(
                opacity: disabled ? 0.55 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat(
                          'EEE',
                          appLocalizations.locale?.languageCode,
                        ).format(date),
                        style: TextStyles.medium14(color: secondaryTextColor),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.vGap4,
                      Text(
                        '${date.day}',
                        style: TextStyles.semiBold24(color: primaryTextColor),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.vGap4,
                      Text(
                        DateFormat(
                          'MMM',
                          appLocalizations.locale?.languageCode,
                        ).format(date),
                        style: TextStyles.medium12(color: secondaryTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

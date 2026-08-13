import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentDaysNumberBottomSheet extends StatefulWidget {
  final int maxDays;

  const AppointmentDaysNumberBottomSheet({super.key, required this.maxDays});

  @override
  State<AppointmentDaysNumberBottomSheet> createState() =>
      _AppointmentDaysNumberBottomSheetState();
}

class _AppointmentDaysNumberBottomSheetState
    extends State<AppointmentDaysNumberBottomSheet> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = 1;
  }

  void _increment() {
    if (_count < widget.maxDays) {
      setState(() => _count++);
    }
  }

  void _decrement() {
    if (_count > 1) {
      setState(() => _count--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.backGround,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.lightTextColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            Gaps.vGap16,
            Text('appointment_days_number'.tr, style: TextStyles.semiBold18()),
            Gaps.vGap4,
            Text(
              'appointment_days_number_desc'.trParams({
                'max': widget.maxDays.toString(),
              }),
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
            Gaps.vGap24,
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.main,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _count > 1 ? _decrement : null,
                      icon: Icon(
                        Icons.remove,
                        color: colors.whiteColor.withValues(
                          alpha: _count > 1 ? 1 : 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48.w,
                      child: Text(
                        widget.maxDays > 1 ? '$_count' : '1',
                        textAlign: TextAlign.center,
                        style: TextStyles.semiBold18(color: colors.whiteColor),
                      ),
                    ),
                    IconButton(
                      onPressed: _count < widget.maxDays ? _increment : null,
                      icon: Icon(
                        Icons.add,
                        color: colors.whiteColor.withValues(
                          alpha: _count < widget.maxDays ? 1 : 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gaps.vGap24,
            MyDefaultButton(
              btnText: 'confirm',
              onPressed: () => Navigator.of(context).pop(_count),
            ),
          ],
        ),
      ),
    );
  }
}

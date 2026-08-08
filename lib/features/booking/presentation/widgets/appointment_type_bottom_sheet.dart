import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentTypeBottomSheet extends StatelessWidget {
  final List<AppointmentTypeEntity> appointmentTypes;

  const AppointmentTypeBottomSheet({super.key, required this.appointmentTypes});

  @override
  Widget build(BuildContext context) {
    final types = appointmentTypes.where((e) => e.id > 0).toList();

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
            Text('select_appointment_type'.tr, style: TextStyles.semiBold18()),
            Gaps.vGap4,
            Text(
              'select_appointment_type_desc'.tr,
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
            Gaps.vGap16,
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 360.h),
              child: types.isEmpty
                  ? SizedBox(
                      height: 160.h,
                      child: Center(
                        child: Text(
                          'no_appointment_types'.tr,
                          style: TextStyles.medium14(
                            color: colors.lightTextColor,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: types.length,
                      separatorBuilder: (_, _) => Gaps.vGap10,
                      itemBuilder: (context, index) {
                        final type = types[index];
                        return InkWell(
                          onTap: () => Navigator.of(context).pop(type),
                          borderRadius: BorderRadius.circular(14.r),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.whiteColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: colors.main.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    type.name,
                                    style: TextStyles.semiBold14(),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colors.main,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

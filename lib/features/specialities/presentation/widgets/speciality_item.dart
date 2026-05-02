import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialityItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const SpecialityItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item['color'].withValues(alpha: .2),
            ),
            child: Icon(item['icon'], color: item['color'], size: 26),
          ),
          Gaps.vGap12,
          Text(item['title'], style: TextStyles.medium16()),
          Gaps.vGap4,
          Text(
            "${item['count']} ${"doctors".tr}",
            style: TextStyles.medium12(color: colors.lightTextColor),
          ),
        ],
      ),
    );
  }
}

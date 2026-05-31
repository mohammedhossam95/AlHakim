import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialityItem extends StatelessWidget {
  final SpecialtyEntity item;

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
          DiffImage(
            image: item.icon,
            height: 75.h,
            width: 75.w,
            isCircle: true,
          ),
          Gaps.vGap12,
          Text(
            item.name ?? '',
            style: TextStyles.medium16(),
            textAlign: TextAlign.center,
          ),
          Gaps.vGap4,
          Text(
            "${item.doctorsCount} ${"doctors".tr}",
            style: TextStyles.medium12(color: colors.lightTextColor),
          ),
        ],
      ),
    );
  }
}

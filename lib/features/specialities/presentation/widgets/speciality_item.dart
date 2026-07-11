import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SpecialityItem extends StatelessWidget {
  final SpecialtyEntity item;

  const SpecialityItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.doctorsListScreenRoute, extra: item);
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Constants.getBackgroundColorBySlug(item.slug ?? ''),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(16.r),
                child: DiffImage(
                  image: item.icon,
                  isCircle: true,
                  fitType: BoxFit.scaleDown,
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
            Gaps.vGap8,
            AutoSizeText(
              item.name ?? '',
              style: TextStyles.medium14(),
              maxLines: 2,
              minFontSize: 12.sp,
              maxFontSize: 14.sp,
              textAlign: TextAlign.center,
            ),
            Gaps.vGap4,
            Text(
              "${item.doctorsCount} ${"doctors".tr}",
              style: TextStyles.medium12(color: colors.lightTextColor),
            ),
            Gaps.vGap8,
            MyDefaultButton(
              height: 28.h,
              borderRadius: 8.r,
              withDottedBorder: false,
              textStyle: TextStyles.medium12(color: colors.whiteColor),
              onPressed: () {
                context.pushNamed(Routes.doctorsListScreenRoute, extra: item);
              },
              btnText: "book_now",
            ),
          ],
        ),
      ),
    );
  }
}

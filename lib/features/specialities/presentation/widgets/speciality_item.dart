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
    // Cap the system font scale inside the card so large accessibility
    // fonts on small screens can't push the content past the card height.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.2,
      child: InkWell(
        onTap: () {
          _openDoctorsList(context);
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Grow up to 90 but shrink to the available space so the
                    // texts and button below never overflow.
                    final size = [
                      90.r,
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ].reduce((a, b) => a < b ? a : b);
                    // Sit at the bottom so the circle hugs the name and any
                    // spare space goes above it.
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: Constants.getBackgroundColorBySlug(
                            item.slug ?? '',
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(size * 0.18),
                        child: DiffImage(
                          image: item.icon,
                          isCircle: true,
                          fitType: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gaps.vGap4,
              AutoSizeText(
                item.name ?? '',
                style: TextStyles.medium14(),
                maxLines: 2,
                minFontSize: 12.sp,
                maxFontSize: 14.sp,
                textAlign: TextAlign.center,
              ),
              Gaps.vGap4,
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${item.doctorsCount ?? 0} ${_doctorsLabel()}",
                  style: TextStyles.medium12(color: colors.lightTextColor),
                  maxLines: 1,
                ),
              ),
              Gaps.vGap8,
              MyDefaultButton(
                height: 28.h,
                borderRadius: 8.r,
                withDottedBorder: false,
                textStyle: TextStyles.medium12(color: colors.whiteColor),
                onPressed: () {
                  _openDoctorsList(context);
                },
                btnText: "book_now",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Arabic always uses "طبيب"; English pluralizes based on the count.
  String _doctorsLabel() {
    if (appLocalizations.isArLocale || item.doctorsCount == 1) {
      return "doctor".tr;
    }
    return "doctors".tr;
  }

  void _openDoctorsList(BuildContext context) {
    final specialtyId = item.id;
    if (specialtyId == null) return;

    context.pushNamed(
      Routes.doctorsListScreenRoute,
      pathParameters: {'specialtyId': '$specialtyId'},
      queryParameters: {if ((item.name ?? '').isNotEmpty) 'name': item.name!},
      extra: item,
    );
  }
}

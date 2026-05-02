import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/specialities/presentation/widgets/speciality_item.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SpecialitiesScreen extends StatelessWidget {
  const SpecialitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final specialities = [
      {
        "title": "الأطفال",
        "icon": Icons.child_care,
        "color": colors.secondary,
        "count": 24,
      },
      {
        "title": "القلب",
        "icon": Icons.favorite,
        "color": colors.errorColor,
        "count": 12,
      },
      {
        "title": "العظام",
        "icon": Icons.accessibility,
        "color": colors.secondary,
        "count": 15,
      },
      {
        "title": "العيون",
        "icon": Icons.visibility,
        "color": colors.main,
        "count": 8,
      },
      {
        "title": "الأسنان",
        "icon": Icons.medical_services,
        "color": colors.main,
        "count": 20,
      },
      {
        "title": "الجلدية",
        "icon": Icons.spa,
        "color": colors.secondary,
        "count": 18,
      },
    ];
    return Scaffold(
      backgroundColor: colors.backGround,
      // appBar: AppBar(
      //   title: Text("specialities".tr),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              ///  search
              _SearchField(),

              Gaps.vGap16,

              /// banner
              _BannerCard(),

              Gaps.vGap16,

              /// header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("all_specialities".tr, style: TextStyles.semiBold16()),
                  Text(
                    "see_all".tr,
                    style: TextStyles.medium14(color: colors.main),
                  ),
                ],
              ),

              Gaps.vGap16,

              /// grid
              Expanded(
                child: GridView.builder(
                  itemCount: specialities.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = specialities[index];
                    return InkWell(
                      onTap: () {
                        context.push(Routes.doctorsListScreenRoute);
                      },
                      child: SpecialityItem(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyTextFormField(
      hintText: "search_speciality".tr,
      prefixIcon: Icon(Icons.search, color: colors.main),

      textInputAction: TextInputAction.search,
      controller: TextEditingController(),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colors.main,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 icon (top right)
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colors.whiteColor.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  color: colors.whiteColor,
                  size: 18.sp,
                ),
              ),
              Gaps.hGap6,

              /// 🧠 title
              Text(
                "ai_engine_title".tr,
                style: TextStyles.semiBold18(color: colors.whiteColor),
              ),
            ],
          ),

          Gaps.vGap8,

          Gaps.vGap8,

          /// 📝 desc
          Text(
            "ai_engine_desc".tr,
            style: TextStyles.medium14(
              color: colors.whiteColor.withValues(alpha: .85),
            ),
          ),

          Gaps.vGap20,

          /// 🔘 button
          Align(
            alignment: Alignment.centerRight,
            child: MyDefaultButton(
              onPressed: () {},
              btnText: "start_diagnosis",
              color: colors.whiteColor,
              textColor: colors.main,
              width: ScreenUtil().screenWidth * .45,
            ),
          ),
        ],
      ),
    );
  }
}

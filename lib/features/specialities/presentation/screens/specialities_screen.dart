import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(
        title: Text("specialities".tr),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// 🔍 search
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
                  "view_all".tr,
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
                  return _SpecialityItem(item);
                },
              ),
            ),

            Gaps.vGap12,

            /// bottom card
            _BottomCard(),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "search_speciality".tr,
        hintStyle: TextStyles.medium14(color: colors.lightTextColor),
        prefixIcon: Icon(Icons.search, color: colors.main),
        filled: true,
        fillColor: colors.whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(colors: [colors.main, colors.secondary]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "special_care".tr,
            style: TextStyles.semiBold18(color: colors.whiteColor),
          ),
          Gaps.vGap8,
          Text(
            "special_care_desc".tr,
            style: TextStyles.medium12(color: colors.whiteColor),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "book_now".tr,
                style: TextStyles.medium14(color: colors.main),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialityItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _SpecialityItem(this.item);

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

class _BottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.verified, color: colors.secondary),
          ),
          Gaps.hGap12,
          Text("quick_consult".tr, style: TextStyles.medium14()),
          Gaps.hGap40,
          Expanded(
            child: MyDefaultButton(onPressed: () {}, btnText: "book_now"),
          ),
        ],
      ),
    );
  }
}

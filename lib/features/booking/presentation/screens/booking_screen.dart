import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      
      appBar: AppBar(title: Text("booking".tr), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// 👨‍⚕️ doctor card
            _DoctorCard(),

            Gaps.vGap20,

            /// title
            Text("who_is_booking".tr, style: TextStyles.semiBold18()),

            Gaps.vGap8,

            Text(
              "booking_desc".tr,
              style: TextStyles.medium14(color: colors.lightTextColor),
              textAlign: TextAlign.center,
            ),

            Gaps.vGap20,

            /// options
            _OptionItem(
              index: 0,
              selectedIndex: selectedIndex,
              title: "myself".tr,
              desc: "myself_desc".tr,
              icon: Icons.person,
              onTap: () => setState(() => selectedIndex = 0),
            ),

            Gaps.vGap12,

            _OptionItem(
              index: 1,
              selectedIndex: selectedIndex,
              title: "family_member".tr,
              desc: "family_member_desc".tr,
              icon: Icons.groups,
              onTap: () => setState(() => selectedIndex = 1),
            ),

            Gaps.vGap12,

            _OptionItem(
              index: 2,
              selectedIndex: selectedIndex,
              title: "other_person".tr,
              desc: "other_person_desc".tr,
              icon: Icons.person_add,
              onTap: () => setState(() => selectedIndex = 2),
            ),
            Gaps.vGap30,

            /// 🔘 confirm button
            MyDefaultButton(
              btnText: "confirm_booking",
              borderRadius: 30,
              height: 50,
              onPressed: () async {
                if (selectedIndex == 1) {
                  final result = await context.push(
                    Routes.familyMembersScreenRoute,
                  );

                  if (result != null) {
                    // setState(() {
                    //   selectedPerson = result;
                    // });
                  }
                } else if (selectedIndex == 2) {
                  final result = await context.push(
                    Routes.addFamilyMemberScreenRoute,
                  );

                  if (result != null) {
                    // setState(() {
                    //   selectedPerson = result;
                    // });
                  }
                } else {}
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
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
          /// image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              "https://i.pravatar.cc/150?img=12",
              width: 70.w,
              height: 70.w,
              fit: BoxFit.cover,
            ),
          ),

          Gaps.hGap12,

          /// info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("د. أحمد خالد", style: TextStyles.semiBold16()),

                Gaps.vGap4,

                Text(
                  "استشاري جراحة العظام والمفاصل",
                  style: TextStyles.medium14(color: colors.main),
                ),

                Gaps.vGap8,

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: colors.lightTextColor,
                    ),
                    Gaps.hGap4,
                    Text("24 مايو", style: TextStyles.medium12()),

                    Gaps.hGap12,

                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: colors.lightTextColor,
                    ),
                    Gaps.hGap4,
                    Text("10:30 صباحاً", style: TextStyles.medium12()),
                  ],
                ),
              ],
            ),
          ),

          /// verified
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: .2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.verified, size: 18, color: colors.secondary),
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String title;
  final String desc;
  final IconData icon;
  final VoidCallback onTap;

  const _OptionItem({
    required this.index,
    required this.selectedIndex,
    required this.title,
    required this.desc,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? colors.main : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            /// radio
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colors.main : colors.lightTextColor,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: colors.main,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            Gaps.hGap12,

            /// text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.semiBold14()),
                  Gaps.vGap4,
                  Text(
                    desc,
                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),

            /// icon
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: .15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

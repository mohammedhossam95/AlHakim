import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FamilyMembersScreen extends StatelessWidget {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final familyMembers = [
      {
        "name": "أحمد محمد",
        "relation": "ابن",
        "age": "8 سنوات",
        "image": "https://i.pravatar.cc/150?img=3",
      },
      {
        "name": "سارة محمود",
        "relation": "زوجة",
        "age": "32 سنة",
        "image": "https://i.pravatar.cc/150?img=5",
      },
    ];
    return Scaffold(
      appBar: AppBar(title: Text("family_members".tr), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.addFamilyMemberScreenRoute);
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// count
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "2 ${"members".tr}",
                style: TextStyles.medium12(color: colors.secondary),
              ),
            ),

            Gaps.vGap16,

            /// list
            Expanded(
              child: ListView.separated(
                itemCount: familyMembers.length,
                separatorBuilder: (_, _) => Gaps.vGap12,
                itemBuilder: (context, index) {
                  return _FamilyItem(familyMembers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _FamilyItem(this.item);

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
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(item['image']),
          ),

          Gaps.hGap12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: TextStyles.semiBold16()),
                Gaps.vGap4,
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        item['relation'],
                        style: TextStyles.medium12(color: colors.secondary),
                      ),
                    ),
                    Gaps.hGap8,
                    Text(
                      "${"age".tr}: ${item['age']}",
                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Gaps.hGap12,

          Icon(Icons.delete_outline, color: colors.errorColor),
        ],
      ),
    );
  }
}

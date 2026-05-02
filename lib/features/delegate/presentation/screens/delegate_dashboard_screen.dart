import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DelegateDashboardScreen extends StatelessWidget {
  const DelegateDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔥 HEADER (RTL)
              Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=12",
                    ),
                  ),
                  Gaps.hGap8,
                  Text("al_hakim".tr, style: TextStyles.semiBold16()),
                  const Spacer(),
                  Icon(Icons.notifications_none, color: colors.textColor),
                ],
              ),

              Gaps.vGap20,

              /// 🔥 WELCOME
              Row(
                children: [
                  Text(
                    "welcome".tr,
                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),
                  Gaps.hGap4,
                  Text("محمد", style: TextStyles.semiBold20()),
                ],
              ),

              Gaps.vGap16,

              /// 🔥 SHARE BUTTON
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: colors.main,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "share_invite_code".tr,
                      style: TextStyles.medium14(color: colors.whiteColor),
                    ),
                    Gaps.hGap8,
                    Icon(Icons.share, color: colors.whiteColor),
                  ],
                ),
              ),

              Gaps.vGap20,

              /// 🔥 STATS
              _StatCard(
                title: "registered_doctors".tr,
                value: "148",
                icon: Icons.person_add_alt_1,
                color: colors.secondary,
                tag: "+12%",
              ),

              Gaps.vGap18,

              _StatCard(
                title: "conversion_rate".tr,
                value: "85%",
                icon: Icons.trending_up,
                color: colors.main,
                tag: "نشط",
              ),

              Gaps.vGap18,

              _StatCard(
                title: "profit".tr,
                value: "14,500",
                icon: Icons.attach_money,
                color: colors.secondary,
                tag: "ِEGP",
              ),
              Gaps.vGap30,

              _InviteCard(code: "HAKIM - 2026"),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String tag;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// icon (يمين)
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 30),
          ),

          Gaps.hGap12,

          Text(
            title,
            style: TextStyles.semiBold12(color: colors.lightTextColor),
            textAlign: TextAlign.right,
          ),

          /// text (شمال)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(tag, style: TextStyles.medium10(color: color)),
                ),

                Gaps.vGap8,

                Text(
                  value,
                  style: TextStyles.semiBold18(),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  final String code;

  const _InviteCard({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(colors: [colors.main, colors.secondary]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// title
          Text(
            "expand_network_today".tr,
            style: TextStyles.semiBold18(color: colors.whiteColor),
            textAlign: TextAlign.right,
          ),

          Gaps.vGap16,

          /// description
          Text(
            "expand_network_desc".tr,
            style: TextStyles.semiBold12(
              color: colors.whiteColor.withValues(alpha: .9),
            ),
            textAlign: TextAlign.right,
          ),

          Gaps.vGap16,

          /// code container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: colors.whiteColor.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                /// copy button
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    Constants.showSnakToast(
                      context: context,
                      message: "code_copied".tr,
                      type: 1,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "copy_code".tr,
                      style: TextStyles.medium12(color: colors.main),
                    ),
                  ),
                ),

                Gaps.hGap12,

                /// code text
                Expanded(
                  child: Text(
                    code,
                    style: TextStyles.semiBold16(color: colors.whiteColor),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

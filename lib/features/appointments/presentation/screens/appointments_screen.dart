import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.backGround,
        appBar: AppBar(
          title: Text("appointments".tr),

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.whiteColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: colors.main,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                labelColor: colors.whiteColor,
                unselectedLabelColor: colors.textColor,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "upcoming".tr),
                  Tab(text: "previous".tr),
                ],
              ),
            ),
          ),
        ),

        /// 🔥 BODY
        body: const TabBarView(
          children: [
            _AppointmentsList(isUpcoming: true),
            _AppointmentsList(isUpcoming: false),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final bool isUpcoming;

  const _AppointmentsList({required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    /// 🔥 Dummy Data (replace with API)
    final List<Map<String, dynamic>> data = isUpcoming
        ? [
            {
              "name": "د. أحمد علي",
              "speciality": "استشاري أمراض القلب",
              "date": "15 أكتوبر",
              "time": "10:00 صباحًا",
              "image": "https://i.pravatar.cc/150?img=3",
            },
          ]
        : [
            {
              "name": "د. سارة محمود",
              "speciality": "أخصائية أطفال",
              "date": "10 أكتوبر",
              "time": "04:30 مساءً",
              "image": "https://i.pravatar.cc/150?img=5",
            },
          ];

    /// ❌ Empty State
    if (data.isEmpty) {
      return Center(
        child: Text("no_appointments".tr, style: TextStyles.medium14()),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: data.length,
      separatorBuilder: (_, _) => Gaps.vGap12,
      itemBuilder: (context, index) {
        return _AppointmentCard(data[index]);
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _AppointmentCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          /// 🔥 HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(item['image']),
              ),
              Gaps.hGap10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: TextStyles.semiBold16()),
                    Gaps.vGap4,
                    Text(
                      item['speciality'],
                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.secondary.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "confirmed".tr,
                  style: TextStyles.medium12(color: colors.secondary),
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          /// 🔥 DATE & TIME
          Row(
            children: [
              Expanded(
                child: _InfoBox(
                  title: "time".tr,
                  value: item['time'],
                  icon: Icons.access_time,
                ),
              ),
              Gaps.hGap10,
              Expanded(
                child: _InfoBox(
                  title: "date".tr,
                  value: item['date'],
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    /// edit logic
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: colors.main,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "edit".tr,
                      style: TextStyles.medium14(color: colors.whiteColor),
                    ),
                  ),
                ),
              ),
              Gaps.hGap10,

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    /// cancel logic
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: colors.errorColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "cancel".tr,
                      style: TextStyles.medium14(color: colors.errorColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: colors.lightBackGroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.main),
          Gaps.hGap8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.medium10()),
              Text(value, style: TextStyles.medium12()),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorsListScreen extends StatelessWidget {
  const DoctorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        "name": "د. أحمد علي",
        "speciality": "استشاري القلب والقسطرة",
        "location": "المعادي، القاهرة",
        // "rating": 4.9,
        "price": 450,
        "image": "https://i.pravatar.cc/150?img=12",
        "times": ["الاحد", "الخميس"],
      },
      {
        "name": "د. محمد حسن",
        "speciality": "أخصائي عظام",
        "location": "مدينة نصر",
        // "rating": 4.7,
        "price": 300,
        "image": "https://i.pravatar.cc/150?img=13",
        "times": ["الاحد", "الخميس"],
      },
    ];
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text("الدكاترة"), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return _DoctorItem(doctors[index]);
        },
      ),
    );
  }
}

class _DoctorItem extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const _DoctorItem(this.doctor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 header
          Row(
            children: [
              /// image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  doctor['image'],
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
                    Text(doctor['name'], style: TextStyles.semiBold16()),
                    Gaps.vGap4,
                    Text(
                      doctor['speciality'],
                      style: TextStyles.medium14(color: colors.main),
                    ),
                    Gaps.vGap8,

                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: colors.lightTextColor,
                        ),
                        Gaps.hGap4,
                        Text(
                          doctor['location'],
                          style: TextStyles.medium12(
                            color: colors.lightTextColor,
                          ),
                        ),
                        // Gaps.hGap12,
                        // Icon(Icons.star, size: 16, color: colors.secondary),
                        // Gaps.hGap4,
                        // Text(
                        //   doctor['rating'].toString(),
                        //   style: TextStyles.medium12(),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          /// 💰 price + verified
          Row(
            children: [
              Text(
                "${doctor['price']} ج.م / كشف",
                style: TextStyles.semiBold16(color: colors.main),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.secondary.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, size: 16, color: colors.secondary),
                    Gaps.hGap4,
                    Text(
                      "موثق",
                      style: TextStyles.medium12(color: colors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          /// 🕐 available times
          Text("المواعيد المتاحة", style: TextStyles.medium14()),

          Gaps.vGap8,

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: doctor['times']
                .map<Widget>(
                  (time) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.lightBackGroundColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(time, style: TextStyles.medium12()),
                  ),
                )
                .toList(),
          ),

          Gaps.vGap16,

          /// 🔘 button
          MyDefaultButton(
            onPressed: () {
              context.push(
                Routes.bookingScreenRoute,
                extra: {
                  "doctorName": doctor['name'],
                  "doctorSpeciality": doctor['speciality'],
                  "doctorPrice": doctor['price'],
                },
              );
            },
            btnText: "book_now",
          ),
        ],
      ),
    );
  }
}

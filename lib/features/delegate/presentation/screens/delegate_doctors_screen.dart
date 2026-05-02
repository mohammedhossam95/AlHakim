import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DelegateDoctorsScreen extends StatelessWidget {
  const DelegateDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: const Text("الدكاترة المسجلين")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.registerRoute);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: _doctors.length,
        separatorBuilder: (_, _) => Gaps.vGap12,
        itemBuilder: (context, index) {
          return _DoctorItem(_doctors[index]);
        },
      ),
    );
  }
}

class _DoctorItem extends StatelessWidget {
  final Map<String, String> doctor;

  const _DoctorItem(this.doctor);

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
          /// avatar (يمين)
          CircleAvatar(
            radius: 26.r,
            backgroundImage: NetworkImage(doctor['image']!),
          ),

          Gaps.hGap12,

          /// info (النص)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor['name']!,
                style: TextStyles.semiBold16(),
                textAlign: TextAlign.right,
              ),
              Gaps.vGap8,
              Text(
                doctor['speciality']!,
                style: TextStyles.medium12(color: colors.lightTextColor),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🔥 داتا وهمية
final List<Map<String, String>> _doctors = [
  {
    "name": "د. سمير القحطاني",
    "speciality": "استشاري جراحة القلب",
    "image": "https://randomuser.me/api/portraits/men/32.jpg",
  },
  {
    "name": "د. ليلى عثمان",
    "speciality": "أخصائية طب الأطفال",
    "image": "https://randomuser.me/api/portraits/women/44.jpg",
  },
  {
    "name": "د. خالد الفيصل",
    "speciality": "طب الأسرة",
    "image": "https://randomuser.me/api/portraits/men/65.jpg",
  },
];

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DoctorItem extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorItem({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final bool isActive = doctor.isActive ?? false;

    return Container(
      padding: EdgeInsets.all(20.w),

      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.whiteColor, width: 1.5.w),
      ),

      child: Column(
        children: [
          /// top section
          Row(
            children: [
              /// avatar
              DiffImage(
                image:
                    doctor.profileImage ??
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                width: 60.0.w,
                height: 60.0.h,
                radius: 30.0.r,
                userName: appLocalizations.isArLocale
                    ? doctor.name?.ar ?? ''
                    : doctor.name?.en ?? '',
                isCircle: true,
                borderRadius: BorderRadius.circular(12.r),
              ),
              Gaps.hGap12,

              /// info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.isArLocale
                          ? doctor.name?.ar ?? ''
                          : doctor.name?.en ?? '',
                      style: TextStyles.semiBold16(),
                      textAlign: TextAlign.right,
                    ),

                    Gaps.vGap12,

                    Text(
                      doctor.specialty?.name ?? '',
                      style: TextStyles.medium13(color: colors.lightTextColor),
                      textAlign: TextAlign.right,
                    ),

                    Gaps.vGap12,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,

                          decoration: BoxDecoration(
                            color: isActive ? colors.secondary : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),

                        Gaps.hGap6,

                        Text(
                          isActive ? "العيادة مفتوحة" : "العيادة مغلقة",

                          style: TextStyles.medium12(
                            color: isActive
                                ? colors.secondary
                                : colors.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Gaps.hGap12,

              /// status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),

                decoration: BoxDecoration(
                  color: isActive
                      ? colors.secondary.withValues(alpha: .15)
                      : Colors.grey.withValues(alpha: .15),

                  borderRadius: BorderRadius.circular(20.r),
                ),

                child: Text(
                  isActive ? "نشط" : "مجمد",

                  style: TextStyles.medium12(
                    color: isActive ? colors.secondary : colors.lightTextColor,
                  ),
                ),
              ),
            ],
          ),

          Gaps.vGap30,

          Gaps.line,

          Gaps.vGap30,

          /// actions
          Row(
            children: [
              /// edit
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final result = await context.push(
                      Routes.updateDoctorScreenRoute,
                      extra: doctor,
                    );

                    if (result == true) {
                      if (!context.mounted) return;
                      context.read<GetDoctorsCubit>().getDoctors();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),

                      border: Border.all(
                        color: colors.backGround.withValues(alpha: .9),
                        width: 1.5,
                      ),
                    ),

                    child: Column(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: colors.main,
                          size: 30.sp,
                        ),

                        Gaps.vGap8,

                        Text(
                          "تحديث",
                          style: TextStyles.medium14(color: colors.main),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Gaps.hGap12,

              /// activate / freeze
              Expanded(
                child: InkWell(
                  onTap: () async {
                    Constants.showConfirmDialog(
                      context: context,
                      title: isActive
                          ? "freeze_doctor".tr
                          : "activate_doctor".tr,
                      content: isActive
                          ? "confirm_freeze_doctor".tr
                          : "confirm_activate_doctor".tr,
                      onYesPressed: () async {
                        if (!context.mounted) return;
                        context
                            .read<ToggelDoctorStatusCubit>()
                            .toggleDoctorStatus(doctor.id ?? '');
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),

                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.orange.withValues(alpha: .12)
                          : colors.main,

                      borderRadius: BorderRadius.circular(24.r),
                    ),

                    child: Column(
                      children: [
                        Icon(
                          isActive
                              ? Icons.ac_unit_rounded
                              : Icons.play_arrow_rounded,

                          color: isActive ? Colors.orange : colors.whiteColor,

                          size: 30.sp,
                        ),

                        Gaps.vGap8,

                        Text(
                          isActive ? "تجميد" : "تنشيط",

                          style: TextStyles.medium14(
                            color: isActive ? Colors.orange : colors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Gaps.hGap12,

              /// cancel
              Expanded(
                child: InkWell(
                  onTap: () {
                    Constants.showConfirmDialog(
                      context: context,
                      title: "delete_doctor".tr,
                      content: "confirm_delete_doctor".tr,
                      onYesPressed: () async {
                        if (!context.mounted) return;
                        context.read<DeleteDoctorCubit>().deleteDoctor(
                          doctor.id ?? '',
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),

                      border: Border.all(
                        color: colors.backGround.withValues(alpha: .9),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: colors.errorColor,
                          size: 30.sp,
                        ),

                        Gaps.vGap8,

                        Text(
                          "حذف",
                          style: TextStyles.medium14(color: colors.errorColor),
                        ),
                      ],
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

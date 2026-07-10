import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_medical_center_doctors_cubit/get_medical_center_doctors_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalCenterDoctorsSelectionScreen extends StatefulWidget {
  const MedicalCenterDoctorsSelectionScreen({super.key});

  @override
  State<MedicalCenterDoctorsSelectionScreen> createState() =>
      _MedicalCenterDoctorsSelectionScreenState();
}

class _MedicalCenterDoctorsSelectionScreenState
    extends State<MedicalCenterDoctorsSelectionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final medicalCenter = sharedPreferences.getAuth()?.profile;

      final medicalCenterId = medicalCenter?.id;
      if (medicalCenterId == null) return;

      context.read<GetMedicalCenterDoctorsCubit>().getMedicalCenterDoctors(
        medicalCenterId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        title: Text('doctors'.tr),
        automaticallyImplyLeading: false,
      ),
      body:
          BlocBuilder<
            GetMedicalCenterDoctorsCubit,
            GetMedicalCenterDoctorsState
          >(
            builder: (context, state) {
              if (state is GetMedicalCenterDoctorsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetMedicalCenterDoctorsError) {
                return Center(
                  child: ErrorText(
                    width: ScreenUtil().screenWidth,
                    text: state.message,
                  ),
                );
              }

              if (state is GetMedicalCenterDoctorsSuccess) {
                final doctors = state.response.data as List<DoctorEntity>;

                if (doctors.isEmpty) {
                  return Center(
                    child: ErrorText(
                      width: ScreenUtil().screenWidth,
                      text: "no_registered_doctors".tr,
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: doctors.length,
                  separatorBuilder: (_, _) => Gaps.vGap12,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return _DoctorSelectionItem(doctor: doctor);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
    );
  }
}

class _DoctorSelectionItem extends StatelessWidget {
  final DoctorEntity doctor;

  const _DoctorSelectionItem({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final name = appLocalizations.isArLocale
        ? doctor.name?.ar ?? ''
        : doctor.name?.en ?? '';

    return InkWell(
      onTap: () {
        context.read<SessionCubit>().selectDoctorForMedicalCenter(doctor);
        context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: colors.lightTextColor.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
          border: Border.all(
            color: colors.lightTextColor.withValues(alpha: .1),
          ),
        ),
        child: Row(
          children: [
            DiffImage(
              image: doctor.profileImage,
              width: 56.w,
              height: 56.w,
              isCircle: true,
              fitType: BoxFit.cover,
            ),
            Gaps.hGap12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyles.semiBold16()),
                  if (doctor.specialty?.name != null) ...[
                    Gaps.vGap4,
                    Text(
                      doctor.specialty!.name!,
                      style: TextStyles.medium14(color: colors.main),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.lightTextColor),
          ],
        ),
      ),
    );
  }
}

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/add_doctor_screen_args.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/delegate/presentation/widgets/doctor_item.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_medical_center_doctors_cubit/get_medical_center_doctors_cubit.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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

      final medicalCenterProfile = context
          .read<SessionCubit>()
          .state
          .userProfile;
      if (medicalCenterProfile?.id == null) return;

      context.read<GetMedicalCenterDoctorsCubit>().getMedicalCenterDoctors(
        medicalCenterProfile!.id!,
      );
    });
  }

  Future<void> _openAddDoctorScreen() async {
    final medicalCenterProfile = context.read<SessionCubit>().state.userProfile;
    if (medicalCenterProfile == null) return;

    final result = await context.push(
      Routes.addDoctorScreenRoute,
      extra: AddDoctorScreenArgs(
        source: DoctorFormSource.medicalCenter,
        medicalCenterProfile: medicalCenterProfile,
      ),
    );

    if (result == true) {
      if (!mounted) return;
      final profileId = medicalCenterProfile.id;
      if (profileId == null) return;
      context.read<GetMedicalCenterDoctorsCubit>().getMedicalCenterDoctors(
        profileId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        title: Text('doctors'.tr),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDoctorScreen,
        child: const Icon(Icons.add),
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
                  separatorBuilder: (_, _) => Gaps.vGap18,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorItem(
                      doctor: doctor,
                      showActions: true,
                      onTap: () {
                        context
                            .read<SessionCubit>()
                            .selectDoctorForMedicalCenter(doctor);
                        context.read<BottomNavBarCubit>().changeCurrentScreen(
                          index: 0,
                        );
                      },
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
    );
  }
}

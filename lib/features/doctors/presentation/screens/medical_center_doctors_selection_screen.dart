import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/params/add_doctor_screen_args.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/delegate/presentation/widgets/doctor_item.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_medical_center_doctors_cubit/get_medical_center_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
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
      _refreshDoctors();
    });
  }

  void _refreshDoctors() {
    final medicalCenterProfile = context
        .read<SessionCubit>()
        .state
        .userProfile;
    if (medicalCenterProfile?.id == null) return;

    context.read<GetMedicalCenterDoctorsCubit>().getMedicalCenterDoctors(
      int.parse(medicalCenterProfile!.id!),
    );
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
      _refreshDoctors();
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteDoctorCubit, DeleteDoctorState>(
            listener: (context, state) {
              if (state is DeleteDoctorLoading) {
                Constants.showLoading(context);
              }
              if (state is DeleteDoctorSuccess) {
                _refreshDoctors();
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.response.message,
                  type: 1,
                );
              }
              if (state is DeleteDoctorError) {
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.message,
                  type: 3,
                );
              }
            },
          ),
          BlocListener<ToggelDoctorStatusCubit, ToggelDoctorStatusState>(
            listener: (context, state) {
              if (state is ToggleDoctorStatusLoading) {
                Constants.showLoading(context);
              }
              if (state is ToggleDoctorStatusSuccess) {
                _refreshDoctors();
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.response.message,
                  type: 1,
                );
              }
              if (state is ToggleDoctorStatusError) {
                Constants.hideLoading(context);
                Constants.showSnakToast(
                  context: context,
                  message: state.message,
                  type: 3,
                );
              }
            },
          ),
        ],
        child:
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
                        onRefresh: _refreshDoctors,
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
      ),
    );
  }
}

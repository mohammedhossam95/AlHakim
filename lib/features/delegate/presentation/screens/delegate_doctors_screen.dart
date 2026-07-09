import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/delegate/presentation/widgets/doctor_item.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DelegateDoctorsScreen extends StatefulWidget {
  const DelegateDoctorsScreen({super.key});

  @override
  State<DelegateDoctorsScreen> createState() => _DelegateDoctorsScreenState();
}

class _DelegateDoctorsScreenState extends State<DelegateDoctorsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetDoctorsCubit>().getDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      appBar: AppBar(title: const Text("الدكاترة المسجلين")),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(Routes.addDoctorScreenRoute);

          if (result == true) {
            if (!context.mounted) return;
            context.read<GetDoctorsCubit>().getDoctors();
          }
        },
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
                context.read<GetDoctorsCubit>().getDoctors();
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
                context.read<GetDoctorsCubit>().getDoctors();
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
        child: BlocBuilder<GetDoctorsCubit, GetDoctorsState>(
          builder: (context, state) {
            if (state is GetDoctorsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is GetDoctorsError) {
              return Center(child: Text(state.message));
            }

            if (state is GetDoctorsSuccess) {
              final doctors = state.response.data as List<DoctorEntity>;

              if (doctors.isEmpty) {
                return const Center(child: Text("لا يوجد دكاترة"));
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),

                itemCount: doctors.length,

                separatorBuilder: (_, _) => Gaps.vGap18,

                itemBuilder: (context, index) {
                  return DoctorItem(doctor: doctors[index]);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

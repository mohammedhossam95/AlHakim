import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/widgets/doctor_list_item.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialty_doctors_cubit/get_specialty_doctors_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorsListScreen extends StatefulWidget {
  final SpecialtyEntity specialty;

  const DoctorsListScreen({super.key, required this.specialty});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetSpecialtyDoctorsCubit>().getSpecialtyDoctors(
      widget.specialty.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,

      appBar: AppBar(title: Text(widget.specialty.name ?? "")),

      body: BlocBuilder<GetSpecialtyDoctorsCubit, GetSpecialtyDoctorsState>(
        builder: (context, state) {
          if (state is GetSpecialtyDoctorsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetSpecialtyDoctorsError) {
            return Center(
              child: ErrorText(
                text: state.message,
                width: 300,
                onRetry: () => context
                    .read<GetSpecialtyDoctorsCubit>()
                    .getSpecialtyDoctors(widget.specialty.id.toString()),
              ),
            );
          }

          List<DoctorEntity> doctors = [];

          if (state is GetSpecialtyDoctorsSuccess) {
            doctors = state.response.data as List<DoctorEntity>;
          }

          if (doctors.isEmpty) {
            return Center(
              child: ErrorText(
                width: ScreenUtil().screenWidth,
                text: "no_registered_doctors".tr,
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),

            itemCount: doctors.length,

            itemBuilder: (context, index) {
              return DoctorListItem(doctor: doctors[index]);
            },
          );
        },
      ),
    );
  }
}

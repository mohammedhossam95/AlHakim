import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/widgets/doctor_list_item.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/domain/usecases/params/get_specialty_doctors_params.dart';
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
  final TextEditingController _searchController = TextEditingController();

  int get _specialtyId => widget.specialty.id ?? 0;

  @override
  void initState() {
    super.initState();

    context.read<GetSpecialtyDoctorsCubit>().getSpecialtyDoctors(
      GetSpecialtyDoctorsParams(specialtyId: _specialtyId),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text(widget.specialty.name ?? "")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: colors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: colors.main.withValues(alpha: .1),
                    blurRadius: 10.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: MyTextFormField(
                controller: _searchController,
                backgroundColor: colors.whiteColor,
                hintText: 'search_speciality'.tr,
                prefixIcon: Icon(Icons.search, color: colors.main),
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  context.read<GetSpecialtyDoctorsCubit>().search(value ?? '');
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<GetSpecialtyDoctorsCubit, GetSpecialtyDoctorsState>(
              builder: (context, state) {
                if (state is GetSpecialtyDoctorsError) {
                  return Center(
                    child: ErrorText(
                      text: state.message,
                      width: 300,
                      onRetry: () => context
                          .read<GetSpecialtyDoctorsCubit>()
                          .getSpecialtyDoctors(
                            GetSpecialtyDoctorsParams(
                              specialtyId: _specialtyId,
                              search: _searchController.text.trim().isEmpty
                                  ? null
                                  : _searchController.text.trim(),
                            ),
                          ),
                    ),
                  );
                }

                List<DoctorEntity> doctors = [];
                var isRefreshing = false;

                if (state is GetSpecialtyDoctorsSuccess) {
                  doctors = state.response.data as List<DoctorEntity>;
                } else if (state is GetSpecialtyDoctorsLoading) {
                  isRefreshing = true;
                  if (state.previousResponse != null) {
                    doctors =
                        state.previousResponse!.data as List<DoctorEntity>;
                  }
                }

                if (doctors.isEmpty && isRefreshing) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (doctors.isEmpty) {
                  return Center(
                    child: ErrorText(
                      width: ScreenUtil().screenWidth,
                      text: _searchController.text.trim().isEmpty
                          ? 'no_registered_doctors'.tr
                          : 'no_search_results'.tr,
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return DoctorListItem(doctor: doctors[index]);
                      },
                    ),
                    if (isRefreshing)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          minHeight: 2.h,
                          color: colors.main,
                          backgroundColor: colors.main.withValues(alpha: .15),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

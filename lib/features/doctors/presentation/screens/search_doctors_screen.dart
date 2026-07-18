import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/search_doctors_cubit/search_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/widgets/doctor_list_item.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchDoctorsScreen extends StatefulWidget {
  final String? initialQuery;
  const SearchDoctorsScreen({super.key, this.initialQuery});

  @override
  State<SearchDoctorsScreen> createState() => _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState extends State<SearchDoctorsScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      // أول بحث فوري من غير debounce
      context.read<SearchDoctorsCubit>().search(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(title: Text('search'.tr)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: MyTextFormField(
              controller: _controller,
              hintText: 'search_speciality'.tr,
              textInputAction: TextInputAction.search,
              prefixIcon: Icon(Icons.search, color: colors.main),
              onChanged: (value) {
                context.read<SearchDoctorsCubit>().search(value ?? '');
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchDoctorsCubit, SearchDoctorsState>(
              builder: (context, state) {
                if (state is SearchDoctorsInitial) {
                  return Center(
                    child: Text(
                      'search_speciality'.tr,
                      style: TextStyles.medium14(color: colors.lightTextColor),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (state is SearchDoctorsError) {
                  return Center(
                    child: ErrorText(
                      width: 300.w,
                      text: state.message,
                      onRetry: () {
                        context.read<SearchDoctorsCubit>().search(
                          _controller.text,
                        );
                      },
                    ),
                  );
                }

                if (state is SearchDoctorsEmpty) {
                  return Center(
                    child: Text(
                      'no_search_results'.tr,
                      style: TextStyles.medium14(color: colors.lightTextColor),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                List<DoctorEntity> doctors = [];
                var isRefreshing = false;

                if (state is SearchDoctorsLoaded) {
                  doctors = state.doctors;
                } else if (state is SearchDoctorsLoading) {
                  doctors = state.previousDoctors;
                  isRefreshing = true;
                }

                if (doctors.isEmpty && isRefreshing) {
                  return const Center(child: CircularProgressIndicator());
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

import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/error_text.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialty_doctors_cubit/get_specialty_doctors_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
            return const Center(
              child: ErrorText(text: "لا يوجد دكاترة", width: 300),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),

            itemCount: doctors.length,

            itemBuilder: (context, index) {
              return _DoctorItem(doctors[index]);
            },
          );
        },
      ),
    );
  }
}

class _DoctorItem extends StatelessWidget {
  final DoctorEntity doctor;

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
          /// header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),

                child: DiffImage(
                  image: doctor.profileImage,
                  width: 70.w,
                  height: 70.w,
                  isCircle: true,
                ),
              ),

              Gaps.hGap12,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      appLocalizations.isArLocale
                          ? doctor.name?.ar ?? ''
                          : doctor.name?.en ?? '',
                      style: TextStyles.semiBold16(),
                    ),

                    Gaps.vGap4,

                    Text(
                      doctor.specialty?.name ?? '',

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

                        Expanded(
                          child: Text(
                            doctor.location?.city ?? '',

                            style: TextStyles.medium12(
                              color: colors.lightTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          /// price
          Row(
            children: [
              Text(
                "${doctor.price ?? ''} ج.م / كشف",

                style: TextStyles.semiBold16(color: colors.main),
              ),

              const Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),

                decoration: BoxDecoration(
                  color: doctor.isActive == true
                      ? colors.secondary.withValues(alpha: .2)
                      : colors.errorColor.withValues(alpha: .1),

                  borderRadius: BorderRadius.circular(20.r),
                ),

                child: Row(
                  children: [
                    Icon(
                      doctor.isActive == true ? Icons.verified : Icons.close,

                      size: 16,

                      color: doctor.isActive == true
                          ? colors.secondary
                          : colors.errorColor,
                    ),

                    Gaps.hGap4,

                    Text(
                      doctor.isActive == true ? "موثق" : "غير مفعل",

                      style: TextStyles.medium12(
                        color: doctor.isActive == true
                            ? colors.secondary
                            : colors.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gaps.vGap12,

          /// rating
          Row(
            children: [
              Icon(Icons.star, size: 18, color: colors.secondary),

              Gaps.hGap4,

              Text(
                "${doctor.rating?.average ?? 0}",

                style: TextStyles.medium14(),
              ),

              Gaps.hGap8,

              Text(
                "(${doctor.rating?.count ?? 0})",

                style: TextStyles.medium12(color: colors.lightTextColor),
              ),
            ],
          ),

          Gaps.vGap16,

          /// button
          MyDefaultButton(
            onPressed: () {
              context.push(Routes.bookingScreenRoute, extra: doctor);
            },

            btnText: "book_now",
          ),
        ],
      ),
    );
  }
}

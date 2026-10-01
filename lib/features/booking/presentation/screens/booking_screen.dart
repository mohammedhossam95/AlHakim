import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/core/widgets/shimmer/booking_screen_shimmer.dart';
import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';
import 'package:alhakim/features/booking/domain/entities/family_member_entity.dart';
import 'package:alhakim/features/booking/domain/entities/schedule.dart';
import 'package:alhakim/features/booking/domain/usecases/params/booking_params.dart';
import 'package:alhakim/features/booking/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:alhakim/features/booking/presentation/widgets/appointment_type_bottom_sheet.dart';
import 'package:alhakim/features/booking/presentation/widgets/booking_dates_selector.dart';
import 'package:alhakim/features/booking/presentation/widgets/selected_booking_date_card.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_by_id_cubit/get_doctor_by_id_cubit.dart';
import 'package:alhakim/features/doctors/presentation/widgets/doctor_list_item.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final DoctorEntity doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedIndex = 0;

  int selectedDateIndex = 0;

  FamilyMemberEntity? selectedFamilyMember;

  List<AvailableBookingDate> availableDates = [];

  late DoctorEntity displayDoctor;

  @override
  void initState() {
    super.initState();
    displayDoctor = widget.doctor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final doctorId = widget.doctor.id?.trim() ?? '';
      if (doctorId.isEmpty) {
        _applySchedules(widget.doctor);
        return;
      }
      context.read<GetDoctorByIdCubit>().getDoctorById(doctorId);
    });
  }

  void _applySchedules(DoctorEntity doctor) {
    final schedules = doctor.schedules;
    setState(() {
      availableDates = BookingDatesHelper.generateAvailableDates(
        schedules ?? [],
        limit: int.tryParse(doctor.appointmentDaysNumber ?? '3') ?? 3,
      );
      selectedDateIndex = _firstSelectableDateIndex(
        availableDates,
        doctor.scheduleExceptions,
      );
      selectedIndex = 0;
    });
  }

  int _firstSelectableDateIndex(
    List<AvailableBookingDate> dates,
    List<ScheduleExceptionEntity>? exceptions,
  ) {
    final index = BookingDatesHelper.firstSelectableIndex(dates, exceptions);
    return index >= 0 ? index : 0;
  }

  bool _isDateDisabled(
    AvailableBookingDate booking, {
    List<ScheduleExceptionEntity>? exceptions,
  }) {
    return BookingDatesHelper.isDateDisabled(
      booking,
      exceptions ?? displayDoctor.scheduleExceptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetDoctorByIdCubit, GetDoctorByIdState>(
      listener: (context, state) {
        if (state is GetDoctorByIdSuccess) {
          displayDoctor = state.doctor;
          _applySchedules(state.doctor);
        } else if (state is GetDoctorByIdError) {
          _applySchedules(widget.doctor);
          Constants.showSnakToast(
            context: context,
            message: state.message.isNotEmpty
                ? state.message
                : 'schedule_refresh_failed'.tr,
            type: 3,
          );
        }
      },
      builder: (context, doctorState) {
        final isLoadingDoctor =
            doctorState is GetDoctorByIdInitial ||
            doctorState is GetDoctorByIdLoading;

        if (isLoadingDoctor) {
          return Scaffold(
            backgroundColor: colors.backGround,
            appBar: AppBar(title: Text('booking'.tr)),
            body: const BookingScreenShimmer(),
          );
        }

        if (availableDates.isEmpty) {
          return Scaffold(
            backgroundColor: colors.backGround,
            appBar: AppBar(title: Text('booking'.tr)),
            body: Center(
              child: Text(
                'no_available_dates'.tr,
                style: TextStyles.semiBold16(),
              ),
            ),
          );
        }

        final selectedBooking = availableDates[selectedDateIndex];

        return Scaffold(
          backgroundColor: colors.backGround,
          appBar: AppBar(title: Text('booking'.tr)),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// doctor card
                DoctorListItem(doctor: displayDoctor, bookingView: true),
                Gaps.vGap24,

                /// title
                Text("choose_booking_date".tr, style: TextStyles.semiBold18()),
                Gaps.vGap8,
                Text(
                  "choose_booking_date_desc".tr,
                  style: TextStyles.medium14(color: colors.lightTextColor),
                ),
                Gaps.vGap20,

                /// dates
                BookingDatesSelector(
                  dates: availableDates,
                  selectedIndex: selectedDateIndex,
                  isDisabled: _isDateDisabled,
                  onSelected: (index) {
                    setState(() => selectedDateIndex = index);
                  },
                ),
                Gaps.vGap20,

                /// selected date card
                SelectedBookingDateCard(booking: selectedBooking),

                Gaps.vGap30,

                /// booking for
                Text("who_is_booking".tr, style: TextStyles.semiBold18()),

                Gaps.vGap8,

                Text(
                  "booking_desc".tr,

                  style: TextStyles.medium14(color: colors.lightTextColor),
                ),

                Gaps.vGap18,
                BookingOptionItem(
                  index: 0,
                  selectedIndex: selectedIndex,
                  title: "myself".tr,
                  desc: "myself_desc".tr,
                  icon: Icons.person_outline,

                  onTap: () {
                    setState(() {
                      selectedIndex = 0;

                      selectedFamilyMember = null;
                    });
                  },
                ),
                Gaps.vGap16,
                selectedFamilyMember != null
                    ? Container(
                        padding: EdgeInsets.all(16.w),

                        decoration: BoxDecoration(
                          color: colors.whiteColor,

                          borderRadius: BorderRadius.circular(20.r),

                          border: Border.all(color: colors.main, width: 1.5),
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,

                              decoration: BoxDecoration(
                                color: colors.main.withValues(alpha: .1),

                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                Icons.groups_outlined,

                                color: colors.main,
                              ),
                            ),

                            Gaps.hGap12,

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    selectedFamilyMember?.fullName ?? '',

                                    style: TextStyles.semiBold14(),
                                  ),

                                  Gaps.vGap8,

                                  Text(
                                    selectedFamilyMember?.kinship?.label ?? '',

                                    style: TextStyles.medium12(
                                      color: colors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            TextButton(
                              onPressed: () async {
                                final result = await context.push(
                                  Routes.familyMembersScreenRoute,
                                  extra: true,
                                );

                                if (result is FamilyMemberEntity) {
                                  setState(() {
                                    selectedIndex = 1;

                                    selectedFamilyMember = result;
                                  });
                                }
                              },

                              child: Text("change".tr),
                            ),
                          ],
                        ),
                      )
                    : BookingOptionItem(
                        index: 1,
                        selectedIndex: selectedIndex,
                        title: "family_member".tr,
                        desc: "family_member_desc".tr,
                        icon: Icons.groups_outlined,

                        onTap: () async {
                          final result = await context.push(
                            Routes.familyMembersScreenRoute,
                            extra: true,
                          );

                          if (result is FamilyMemberEntity) {
                            setState(() {
                              selectedIndex = 1;

                              selectedFamilyMember = result;
                            });
                          }
                        },
                      ),
                Gaps.vGap30,

                /// confirm button
                BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
                  listener: (context, state) {
                    if (state is BookAppointmentSuccess) {
                      Constants.showSnakToast(
                        context: context,

                        message: state.response.message ?? '',
                        type: 1,
                      );

                      context.push(
                        Routes.appoinmentSuccessScreen,
                        extra: {
                          "doctor": widget.doctor,
                          "appointmentDate": selectedBooking.date.toString(),
                          "appointment": state.response.data,
                        },
                      );
                    } else if (state is BookAppointmentError) {
                      Constants.showSnakToast(
                        context: context,
                        message: state.message,
                        type: 3,
                      );
                    }
                  },
                  builder: (context, state) {
                    return state is BookAppointmentLoading
                        ? LoadingView()
                        : MyDefaultButton(
                            btnText: "confirm_booking",
                            borderRadius: 30,
                            onPressed: () async {
                              if (_isDateDisabled(selectedBooking)) {
                                Constants.showSnakToast(
                                  context: context,
                                  message: 'no_available_dates'.tr,
                                  type: 2,
                                );
                                return;
                              }

                              final selectedType =
                                  await showModalBottomSheet<
                                    AppointmentTypeEntity
                                  >(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => AppointmentTypeBottomSheet(
                                      appointmentTypes:
                                          displayDoctor.appointmentTypes ?? [],
                                    ),
                                  );

                              if (selectedType == null) return;
                              if (!context.mounted) return;

                              context
                                  .read<BookAppointmentCubit>()
                                  .bookAppointment(
                                    BookingParams(
                                      doctorId: widget.doctor.id ?? '',
                                      appointmentDate: DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(selectedBooking.date),
                                      appointmentTypeId: selectedType.id,
                                      familyMemberId: selectedFamilyMember?.id,
                                    ),
                                  );
                            },
                          );
                  },
                ),

                Gaps.vGap20,
              ],
            ),
          ),
        );
      },
    );
  }
}

class BookingOptionItem extends StatelessWidget {
  final int index;
  final int selectedIndex;

  final String title;
  final String desc;

  final IconData icon;

  final VoidCallback onTap;

  const BookingOptionItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.title,
    required this.desc,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: EdgeInsets.all(16.w),

        decoration: BoxDecoration(
          color: colors.whiteColor,

          borderRadius: BorderRadius.circular(20.r),

          border: Border.all(
            color: isSelected ? colors.main : Colors.transparent,

            width: 1.5,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: isSelected ? colors.main : colors.lightTextColor,
                ),
              ),

              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,

                        decoration: BoxDecoration(
                          color: colors.main,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            Gaps.hGap12,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(title, style: TextStyles.semiBold14()),

                  Gaps.vGap8,

                  Text(
                    desc,

                    style: TextStyles.medium12(color: colors.lightTextColor),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(12.w),

              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: .12),

                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

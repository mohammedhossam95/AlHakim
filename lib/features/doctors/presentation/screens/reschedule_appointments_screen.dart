import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/core/params/reschedule_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/booking/domain/entities/schedule.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_appoinments_for_day_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_appoinments_for_day_cubit/get_doctor_appoinments_for_day_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/reschedule_cubit/reschedule_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class RescheduleAppointmentsScreen extends StatefulWidget {
  const RescheduleAppointmentsScreen({super.key});

  @override
  State<RescheduleAppointmentsScreen> createState() =>
      _RescheduleAppointmentsScreenState();
}

class _RescheduleAppointmentsScreenState
    extends State<RescheduleAppointmentsScreen> {
  int selectedDateIndex = 0;

  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  TimeOfDay endTime = const TimeOfDay(hour: 15, minute: 0);

  late List<AvailableBookingDate> availableDates;

  @override
  void initState() {
    super.initState();

    availableDates = BookingDatesHelper.generateAvailableDates(
      sharedPreferences.getAuth()?.doctor?.schedules ?? [],
    );

    if (availableDates.isNotEmpty) {
      _getAppointments(availableDates.first);
    }
  }

  void _getAppointments(AvailableBookingDate date) {
    context.read<GetDoctorAppoinmentsForDayCubit>().getDoctorAppoinmentsForDay(
      params: AppoinmentsParams(
        doctorId: sharedPreferences.getAuth()?.doctor?.id ?? '',

        appointmentDate: DateFormat('yyyy-MM-dd').format(date.date),
      ),
    );
  }

  Future<void> pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,

      initialTime: isStart ? startTime : endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();

    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    final hour = DateFormat('hh:mm', 'en').format(date);

    final period = time.hour >= 12
        ? (appLocalizations.isArLocale ? 'مساءً' : 'PM')
        : (appLocalizations.isArLocale ? 'صباحاً' : 'AM');

    return "$hour $period";
  }

  String formatApiTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');

    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  int convertWeekDay(DateTime date) {
    if (date.weekday == 7) {
      return 0;
    }

    return date.weekday;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = availableDates[selectedDateIndex];

    return BlocListener<RescheduleCubit, RescheduleState>(
      listener: (context, state) {
        if (state is RescheduleLoading) {
          Constants.showLoading(context);
        }

        if (state is RescheduleSuccess) {
          Constants.hideLoading(context);

          Constants.showSnakToast(
            context: context,
            type: 1,
            message: state.response.message,
          );

          Navigator.pop(context);
        }

        if (state is RescheduleError) {
          Constants.hideLoading(context);

          Constants.showSnakToast(
            context: context,
            type: 3,
            message: state.message,
          );
        }
      },

      child: Scaffold(
        backgroundColor: colors.backGround,

        appBar: AppBar(title: Text("reschedule_appointments".tr)),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),

          child: Column(
            children: [
              /// choose day
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(18.w),

                decoration: BoxDecoration(
                  color: colors.whiteColor,

                  borderRadius: BorderRadius.circular(24.r),
                ),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),

                          decoration: BoxDecoration(
                            color: colors.main.withValues(alpha: .12),

                            borderRadius: BorderRadius.circular(14.r),
                          ),

                          child: Icon(
                            Icons.calendar_today_outlined,

                            color: colors.main,
                          ),
                        ),

                        Gaps.hGap12,

                        Expanded(
                          child: Text(
                            "choose_day".tr,

                            style: TextStyles.semiBold18(),
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap24,

                    SizedBox(
                      height: 110.h,

                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,

                        itemCount: availableDates.length,

                        separatorBuilder: (_, _) => Gaps.hGap12,

                        itemBuilder: (context, index) {
                          final date = availableDates[index];

                          final isSelected = selectedDateIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDateIndex = index;
                              });

                              _getAppointments(date);
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),

                              width: 85.w,

                              padding: EdgeInsets.symmetric(vertical: 12.h),

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.main
                                    : colors.backGround,

                                borderRadius: BorderRadius.circular(20.r),
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Text(
                                    DateFormat(
                                      'EEEE',

                                      appLocalizations.isArLocale ? 'ar' : 'en',
                                    ).format(date.date),

                                    style: TextStyles.medium14(
                                      color: isSelected
                                          ? colors.whiteColor
                                          : colors.lightTextColor,
                                    ),
                                  ),

                                  Gaps.vGap8,

                                  Text(
                                    "${date.date.day}",

                                    style: TextStyles.bold22(
                                      color: isSelected
                                          ? colors.whiteColor
                                          : colors.textColor,
                                    ),
                                  ),

                                  Gaps.vGap8,

                                  Text(
                                    DateFormat(
                                      'MMM',

                                      appLocalizations.isArLocale ? 'ar' : 'en',
                                    ).format(date.date),

                                    style: TextStyles.medium12(
                                      color: isSelected
                                          ? colors.whiteColor
                                          : colors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Gaps.vGap20,

              /// working hours
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(18.w),

                decoration: BoxDecoration(
                  color: colors.whiteColor,

                  borderRadius: BorderRadius.circular(24.r),
                ),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),

                          decoration: BoxDecoration(
                            color: colors.main.withValues(alpha: .12),

                            borderRadius: BorderRadius.circular(14.r),
                          ),

                          child: Icon(Icons.access_time, color: colors.main),
                        ),

                        Gaps.hGap12,

                        Expanded(
                          child: Text(
                            "edit_working_hours".tr,

                            style: TextStyles.semiBold18(),
                          ),
                        ),
                      ],
                    ),

                    Gaps.vGap20,

                    Align(
                      alignment: Alignment.centerRight,

                      child: Text("from_time".tr, style: TextStyles.medium14()),
                    ),

                    Gaps.vGap10,

                    GestureDetector(
                      onTap: () {
                        pickTime(isStart: true);
                      },

                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,

                          vertical: 18.h,
                        ),

                        decoration: BoxDecoration(
                          color: colors.backGround,

                          borderRadius: BorderRadius.circular(18.r),
                        ),

                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, color: colors.main),

                            Gaps.hGap10,

                            Expanded(
                              child: Text(
                                formatTime(startTime),

                                style: TextStyles.medium15(),
                              ),
                            ),

                            Icon(Icons.restart_alt_rounded, color: colors.main),
                          ],
                        ),
                      ),
                    ),

                    Gaps.vGap22,

                    Align(
                      alignment: Alignment.centerRight,

                      child: Text("to_time".tr, style: TextStyles.medium14()),
                    ),

                    Gaps.vGap10,

                    GestureDetector(
                      onTap: () {
                        pickTime(isStart: false);
                      },

                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,

                          vertical: 18.h,
                        ),

                        decoration: BoxDecoration(
                          color: colors.backGround,

                          borderRadius: BorderRadius.circular(18.r),
                        ),

                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, color: colors.main),

                            Gaps.hGap10,

                            Expanded(
                              child: Text(
                                formatTime(endTime),

                                style: TextStyles.medium15(),
                              ),
                            ),

                            Icon(Icons.restart_alt_rounded, color: colors.main),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gaps.vGap20,

              /// affected appointments
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(18.w),

                decoration: BoxDecoration(
                  color: colors.whiteColor,

                  borderRadius: BorderRadius.circular(24.r),
                ),

                child:
                    BlocBuilder<
                      GetDoctorAppoinmentsForDayCubit,
                      GetDoctorAppoinmentsForDayState
                    >(
                      builder: (context, state) {
                        if (state is GetDoctorAppoinmentsForDayLoading) {
                          return _buildShimmer();
                        }

                        if (state is GetDoctorAppoinmentsForDayError) {
                          return Center(child: Text(state.message));
                        }

                        List<DoctorAppoinmentsForDayEntity> appointments = [];

                        if (state is GetDoctorAppoinmentsForDaySuccess) {
                          appointments =
                              state.response.data
                                  as List<DoctorAppoinmentsForDayEntity>;
                        }

                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "affected_periods".tr,

                                  style: TextStyles.semiBold18(),
                                ),

                                Gaps.hGap8,

                                Icon(
                                  Icons.warning_rounded,

                                  color: colors.errorColor,
                                ),

                                const Spacer(),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,

                                    vertical: 6.h,
                                  ),

                                  decoration: BoxDecoration(
                                    color: colors.errorColor.withValues(
                                      alpha: .12,
                                    ),

                                    borderRadius: BorderRadius.circular(20.r),
                                  ),

                                  child: Text(
                                    "${"appointments".tr}: ${appointments.length}",

                                    style: TextStyles.medium12(
                                      color: colors.errorColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Gaps.vGap20,

                            if (appointments.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.h),

                                child: Text(
                                  "no_appointments".tr,

                                  style: TextStyles.medium14(),
                                ),
                              ),

                            if (appointments.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,

                                physics: const NeverScrollableScrollPhysics(),

                                itemCount: appointments.length,

                                separatorBuilder: (_, _) => Gaps.vGap12,

                                itemBuilder: (context, index) {
                                  final item = appointments[index];

                                  return Container(
                                    padding: EdgeInsets.all(14.w),

                                    decoration: BoxDecoration(
                                      color: colors.whiteColor,

                                      borderRadius: BorderRadius.circular(18.r),

                                      border: Border(
                                        right: BorderSide(
                                          color: colors.errorColor,

                                          width: 4.w,
                                        ),
                                      ),

                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.textColor.withValues(
                                            alpha: .04,
                                          ),

                                          blurRadius: 10,

                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),

                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.w),

                                          decoration: BoxDecoration(
                                            color: colors.backGround,

                                            shape: BoxShape.circle,
                                          ),

                                          child: Icon(
                                            Icons.person_outline,

                                            color: colors.lightTextColor,
                                          ),
                                        ),

                                        Gaps.hGap16,

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,

                                                  vertical: 4.h,
                                                ),

                                                decoration: BoxDecoration(
                                                  color: colors.errorColor
                                                      .withValues(alpha: .08),

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                ),

                                                child: Text(
                                                  "outside_new_hours".tr,

                                                  style: TextStyles.medium12(
                                                    color: colors.errorColor,
                                                  ),
                                                ),
                                              ),

                                              Gaps.vGap10,

                                              Text(
                                                item.bookedBy?.fullName ?? '',

                                                style: TextStyles.semiBold14(),
                                              ),

                                              Gaps.vGap8,

                                              Text(
                                                item.bookedBy?.phoneNumber ??
                                                    '',

                                                style: TextStyles.medium12(
                                                  color: colors.lightTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Gaps.hGap16,

                                        Text(
                                          item.queuePosition ?? '',

                                          style: TextStyles.medium16(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
              ),

              Gaps.vGap20,

              MyDefaultButton(
                btnText: "confirm_reschedule",

                borderRadius: 30,

                height: 56.h,

                onPressed: () {
                  context.read<RescheduleCubit>().reschedule(
                    params: RescheduleParams(
                      doctorId: sharedPreferences.getAuth()?.doctor?.id ?? '',

                      date: DateFormat('yyyy-MM-dd').format(selectedDate.date),

                      dayOfWeek: convertWeekDay(selectedDate.date),

                      startTime: formatApiTime(startTime),

                      endTime: formatApiTime(endTime),

                      slotDuration: sharedPreferences
                          .getAuth()
                          ?.doctor
                          ?.schedules
                          ?.first
                          .slotDuration,
                    ),
                  );
                },
              ),

              Gaps.vGap20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,

      highlightColor: Colors.grey[100]!,

      child: ListView.separated(
        shrinkWrap: true,

        physics: const NeverScrollableScrollPhysics(),

        itemCount: 4,

        separatorBuilder: (_, _) => Gaps.vGap12,

        itemBuilder: (context, index) {
          return Container(
            height: 100.h,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(18.r),
            ),
          );
        },
      ),
    );
  }
}

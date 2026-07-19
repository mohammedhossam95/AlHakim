import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/booking/domain/entities/family_member_entity.dart';
import 'package:alhakim/features/booking/domain/entities/schedule.dart';
import 'package:alhakim/features/booking/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
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

  late List<AvailableBookingDate> availableDates;

  @override
  void initState() {
    super.initState();

    availableDates = BookingDatesHelper.generateAvailableDates(
      widget.doctor.schedules ?? [],
    );
  }

  String formatTime(String time) {
    final parts = time.split(':');

    final date = DateTime(2025, 1, 1, int.parse(parts[0]), int.parse(parts[1]));

    final hour = DateFormat('hh:mm', 'en').format(date);

    final period = date.hour >= 12
        ? (appLocalizations.isArLocale ? 'مساء' : 'PM')
        : (appLocalizations.isArLocale ? 'صباحاً' : 'AM');

    return "$hour $period";
  }

  @override
  Widget build(BuildContext context) {
    final selectedBooking = availableDates[selectedDateIndex];

    return Scaffold(
      backgroundColor: colors.backGround,

      appBar: AppBar(title: Text("booking".tr)),

      body: availableDates.isEmpty
          ? Center(
              child: Text(
                "no_available_dates".tr,

                style: TextStyles.semiBold16(),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// doctor card
                  DoctorBookingCard(doctor: widget.doctor),

                  Gaps.vGap24,

                  /// title
                  Text(
                    "choose_booking_date".tr,

                    style: TextStyles.semiBold18(),
                  ),

                  Gaps.vGap8,

                  Text(
                    "choose_booking_date_desc".tr,

                    style: TextStyles.medium14(color: colors.lightTextColor),
                  ),

                  Gaps.vGap20,

                  /// dates
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(availableDates.length, (index) {
                        final bookingDate = availableDates[index];
                        final date = bookingDate.date;
                        final isSelected = selectedDateIndex == index;
                        final isLast = index == availableDates.length - 1;

                        return Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: isLast ? 0 : 12.w,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDateIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.main
                                    : colors.whiteColor,
                                borderRadius: BorderRadius.circular(22.r),
                                border: Border.all(
                                  color: isSelected
                                      ? colors.main
                                      : colors.main.withValues(alpha: .08),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat(
                                      'EEE',
                                      appLocalizations.locale?.languageCode,
                                    ).format(date),
                                    style: TextStyles.medium14(
                                      color: isSelected
                                          ? colors.whiteColor
                                          : colors.lightTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Gaps.vGap4,
                                  Text(
                                    '${date.day}',
                                    style: TextStyles.semiBold24(
                                      color: isSelected
                                          ? colors.whiteColor
                                          : colors.textColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Gaps.vGap4,
                                  Text(
                                    DateFormat(
                                      'MMM',
                                      appLocalizations.locale?.languageCode,
                                    ).format(date),
                                    style: TextStyles.medium12(
                                      color: isSelected
                                          ? colors.whiteColor
                                          : colors.lightTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Gaps.vGap20,

                  /// selected date card
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(18.w),

                    decoration: BoxDecoration(
                      color: colors.main.withValues(alpha: .05),

                      borderRadius: BorderRadius.circular(20.r),
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),

                              decoration: BoxDecoration(
                                color: colors.main.withValues(alpha: .12),

                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                Icons.calendar_today,
                                color: colors.main,
                              ),
                            ),

                            Gaps.hGap16,

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "selected_date".tr,

                                    style: TextStyles.medium12(
                                      color: colors.lightTextColor,
                                    ),
                                  ),

                                  Gaps.vGap8,

                                  Text(
                                    DateFormat(
                                      'EEEE, d MMM yyyy',

                                      appLocalizations.locale?.languageCode,
                                    ).format(selectedBooking.date),

                                    style: TextStyles.medium14(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Gaps.vGap18,

                        Divider(),

                        Gaps.vGap18,

                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),

                              decoration: BoxDecoration(
                                color: colors.secondary.withValues(alpha: .12),

                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                Icons.access_time,
                                color: colors.secondary,
                              ),
                            ),

                            Gaps.hGap16,

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "available_time".tr,

                                    style: TextStyles.medium12(
                                      color: colors.lightTextColor,
                                    ),
                                  ),

                                  Gaps.vGap8,

                                  Text(
                                    "from_to_time".trParams({
                                      "start": formatTime(
                                        selectedBooking.schedule.startTime ??
                                            '',
                                      ),

                                      "end": formatTime(
                                        selectedBooking.schedule.endTime ?? '',
                                      ),
                                    }),

                                    style: TextStyles.medium14(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

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
                                      selectedFamilyMember?.kinship?.label ??
                                          '',

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
                            );

                            if (result is FamilyMemberEntity) {
                              setState(() {
                                selectedIndex = 1;

                                selectedFamilyMember = result;
                              });
                            }
                          },
                        ),

                  // Gaps.vGap16,

                  // BookingOptionItem(
                  //   index: 2,
                  //   selectedIndex: selectedIndex,
                  //   title: "other_person".tr,
                  //   desc: "other_person_desc".tr,
                  //   icon: Icons.person_add_alt_1,

                  //   onTap: () {
                  //     setState(() {
                  //       selectedIndex = 2;
                  //     });

                  //     context.push(Routes.addFamilyMemberScreenRoute);
                  //   },
                  // ),
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

                              height: 54,

                              onPressed: () {
                                context
                                    .read<BookAppointmentCubit>()
                                    .bookAppointment(
                                      doctorId: widget.doctor.id ?? '',

                                      appointmentDate: DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(selectedBooking.date),

                                      familyMemberId: selectedFamilyMember?.id,
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
  }
}

class DoctorBookingCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorBookingCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: colors.whiteColor,

        borderRadius: BorderRadius.circular(22.r),
      ),

      child: Row(
        children: [
          DiffImage(
            image: doctor.profileImage,
            width: 75.w,
            height: 75.w,
            isCircle: true,
          ),

          Gaps.hGap16,

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

                Gaps.vGap8,

                Text(
                  doctor.specialty?.name ?? '',

                  style: TextStyles.medium14(color: colors.main),
                ),

                Gaps.vGap10,

                Row(
                  children: [
                    Icon(Icons.star, size: 16.sp, color: colors.review),

                    Gaps.hGap4,

                    Text("4.9", style: TextStyles.medium12()),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(8.w),

            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: .15),

              shape: BoxShape.circle,
            ),

            child: Icon(Icons.verified, color: colors.secondary),
          ),
        ],
      ),
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

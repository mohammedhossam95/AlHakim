import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/utils/validator.dart';
import 'package:alhakim/core/widgets/country_code_widget.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';
import 'package:alhakim/features/booking/domain/entities/schedule.dart';
import 'package:alhakim/features/booking/presentation/widgets/appointment_type_bottom_sheet.dart';
import 'package:alhakim/features/booking/presentation/widgets/booking_dates_selector.dart';
import 'package:alhakim/features/booking/presentation/widgets/selected_booking_date_card.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_by_id_cubit/get_doctor_by_id_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/quick_booking_cubit/quick_booking_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class QuickBookingScreen extends StatefulWidget {
  const QuickBookingScreen({super.key});

  @override
  State<QuickBookingScreen> createState() => _QuickBookingScreenState();
}

class _QuickBookingScreenState extends State<QuickBookingScreen> {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneController = TextEditingController();

  final firstNameFocus = FocusNode();

  final lastNameFocus = FocusNode();

  final phoneFocus = FocusNode();

  List<AvailableBookingDate> _availableDates = [];

  int? _selectedDateIndex;

  final appointmentTypeController = TextEditingController();

  Country _selectedCountry = CountryParser.parsePhoneCode('20');

  AppointmentTypeEntity? _selectedAppointmentType;

  @override
  void initState() {
    super.initState();
    _fetchDoctor();
  }

  /// The appointment types come with the doctor's details.
  void _fetchDoctor() {
    final doctorId = context.read<SessionCubit>().state.activeDoctorId;
    if (doctorId == null || doctorId.isEmpty) return;
    context.read<GetDoctorByIdCubit>().getDoctorById(doctorId);
  }

  Future<void> _pickAppointmentType() async {
    final doctorState = context.read<GetDoctorByIdCubit>().state;
    if (doctorState is GetDoctorByIdLoading) return;
    if (doctorState is! GetDoctorByIdSuccess) {
      _fetchDoctor();
      return;
    }

    final selectedType = await showModalBottomSheet<AppointmentTypeEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppointmentTypeBottomSheet(
        appointmentTypes: doctorState.doctor.appointmentTypes ?? [],
      ),
    );
    if (selectedType == null || !mounted) return;

    setState(() {
      _selectedAppointmentType = selectedType;
      appointmentTypeController.text = selectedType.name;
    });
  }

  Future<void> _onConfirmPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final dateIndex = _selectedDateIndex;
    if (dateIndex == null) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: 'choose_date'.tr,
      );
      return;
    }

    final doctorId = context.read<SessionCubit>().state.activeDoctorId;
    if (doctorId == null || doctorId.isEmpty) return;

    final phone = await Constants.phoneParsing(
      phone: phoneController.text,
      countryCode: _selectedCountry.countryCode,
      withCode: false,
    );
    if (!mounted) return;

    if (phone == null) {
      Constants.showSnakToast(
        context: context,
        type: 3,
        message: 'invalid_phone'.tr,
      );
      return;
    }

    context.read<QuickBookingCubit>().quickBooking(
      params: QuickBookingParams(
        doctorId: doctorId,
        appointmentDate: DateFormat(
          'yyyy-MM-dd',
        ).format(_availableDates[dateIndex].date),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        countryCode: '+${_selectedCountry.phoneCode}',
        phoneNumber: phone,
        appointmentTypeId: _selectedAppointmentType?.id,
      ),
    );
  }

  /// Same rules as the patient booking screen: only the doctor's working
  /// days, limited by `appointmentDaysNumber`, with full days and exceptions
  /// disabled.
  void _applySchedules(DoctorEntity doctor) {
    final dates = BookingDatesHelper.generateAvailableDates(
      doctor.schedules ?? [],
      limit: int.tryParse(doctor.appointmentDaysNumber ?? '3') ?? 3,
    );
    final firstIndex = BookingDatesHelper.firstSelectableIndex(
      dates,
      doctor.scheduleExceptions,
    );
    setState(() {
      _availableDates = dates;
      _selectedDateIndex = firstIndex >= 0 ? firstIndex : null;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();

    lastNameController.dispose();

    phoneController.dispose();

    appointmentTypeController.dispose();

    firstNameFocus.dispose();

    lastNameFocus.dispose();

    phoneFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetDoctorByIdCubit, GetDoctorByIdState>(
          listener: (context, state) {
            if (state is GetDoctorByIdSuccess) _applySchedules(state.doctor);
          },
        ),
        BlocListener<QuickBookingCubit, QuickBookingState>(
          listener: (context, state) {
            if (state is QuickBookingSuccess) {
              Constants.showSnakToast(
                context: context,
                type: 1,
                message: state.response.message,
              );

              context.pop(true);
            }

            if (state is QuickBookingError) {
              Constants.showSnakToast(
                context: context,
                type: 3,
                message: state.message,
              );
            }
          },
        ),
      ],

      child: Scaffold(
        backgroundColor: colors.backGround,

        appBar: AppBar(title: Text("quick_booking".tr)),

        body: Form(
          key: formKey,

          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),

            child: Column(
              children: [
                /// patient info
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(18.w),

                  decoration: BoxDecoration(
                    color: colors.whiteColor,

                    borderRadius: BorderRadius.circular(24.r),
                  ),

                  child: Column(
                    children: [
                      /// title
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),

                            decoration: BoxDecoration(
                              color: colors.main.withValues(alpha: .1),

                              borderRadius: BorderRadius.circular(12.r),
                            ),

                            child: Icon(
                              Icons.people_alt_outlined,

                              color: colors.main,
                            ),
                          ),

                          Gaps.hGap10,

                          Text(
                            "patient_information".tr,

                            style: TextStyles.medium18(),
                          ),
                        ],
                      ),

                      Gaps.vGap16,

                      /// names
                      Row(
                        children: [
                          Expanded(
                            child: MyTextFormField(
                              controller: firstNameController,

                              focusNode: firstNameFocus,

                              hintText: "first_name".tr,

                              textInputAction: TextInputAction.next,

                              prefixIcon: const Icon(Icons.person_outline),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr;
                                }

                                return null;
                              },
                            ),
                          ),
                          Gaps.hGap12,

                          Expanded(
                            child: MyTextFormField(
                              controller: lastNameController,

                              focusNode: lastNameFocus,

                              hintText: "last_name".tr,

                              textInputAction: TextInputAction.next,

                              prefixIcon: const Icon(Icons.person_outline),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "required".tr;
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      Gaps.vGap18,

                      /// phone
                      Row(
                        children: [
                          CountryCodeWidget(
                            country: _selectedCountry,
                            updateValue: (country) {
                              setState(() => _selectedCountry = country);
                            },
                          ),
                          Gaps.hGap8,
                          Expanded(
                            child: MyTextFormField(
                              controller: phoneController,
                              focusNode: phoneFocus,
                              hintText: "phone_number".tr,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              validatorType: ValidatorType.phone,
                              prefixIcon: const Icon(
                                Icons.phone_android_outlined,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Gaps.vGap20,

                /// booking details
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(18.w),

                  decoration: BoxDecoration(
                    color: colors.whiteColor,

                    borderRadius: BorderRadius.circular(24.r),
                  ),

                  child: Column(
                    children: [
                      /// title
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),

                            decoration: BoxDecoration(
                              color: colors.main.withValues(alpha: .1),

                              borderRadius: BorderRadius.circular(12.r),
                            ),

                            child: Icon(
                              Icons.calendar_today_outlined,

                              color: colors.main,
                            ),
                          ),

                          Gaps.hGap10,

                          Text(
                            "appointment_details".tr,

                            style: TextStyles.medium18(),
                          ),
                        ],
                      ),

                      Gaps.vGap24,

                      /// date
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "appointment_date".tr,
                          style: TextStyles.medium16(),
                        ),
                      ),

                      Gaps.vGap10,

                      BlocBuilder<GetDoctorByIdCubit, GetDoctorByIdState>(
                        builder: (context, doctorState) {
                          if (doctorState is GetDoctorByIdInitial ||
                              doctorState is GetDoctorByIdLoading) {
                            return const LoadingView();
                          }

                          if (doctorState is GetDoctorByIdError) {
                            return Center(
                              child: TextButton.icon(
                                onPressed: _fetchDoctor,
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text("retry".tr),
                              ),
                            );
                          }

                          if (_availableDates.isEmpty) {
                            return Text(
                              "no_available_dates".tr,
                              style: TextStyles.medium14(
                                color: colors.lightTextColor,
                              ),
                            );
                          }

                          final exceptions = doctorState is GetDoctorByIdSuccess
                              ? doctorState.doctor.scheduleExceptions
                              : null;

                          final dateIndex = _selectedDateIndex;

                          return Column(
                            children: [
                              BookingDatesSelector(
                                dates: _availableDates,
                                selectedIndex: _selectedDateIndex,
                                isDisabled: (booking) =>
                                    BookingDatesHelper.isDateDisabled(
                                      booking,
                                      exceptions,
                                    ),
                                onSelected: (index) {
                                  setState(() => _selectedDateIndex = index);
                                },
                              ),
                              if (dateIndex != null) ...[
                                Gaps.vGap16,
                                SelectedBookingDateCard(
                                  booking: _availableDates[dateIndex],
                                ),
                              ],
                            ],
                          );
                        },
                      ),

                      Gaps.vGap16,

                      /// appointment type
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "appointment_type".tr,
                          style: TextStyles.medium16(),
                        ),
                      ),

                      Gaps.vGap10,

                      BlocBuilder<GetDoctorByIdCubit, GetDoctorByIdState>(
                        builder: (context, doctorState) {
                          return GestureDetector(
                            onTap: _pickAppointmentType,
                            child: AbsorbPointer(
                              child: MyTextFormField(
                                controller: appointmentTypeController,
                                hintText: "select_appointment_type".tr,
                                prefixIcon: const Icon(
                                  Icons.medical_services_outlined,
                                ),
                                suffixIcon: doctorState is GetDoctorByIdLoading
                                    ? Padding(
                                        padding: EdgeInsets.all(14.r),
                                        child: SizedBox(
                                          width: 16.r,
                                          height: 16.r,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                        ),
                                      )
                                    : doctorState is GetDoctorByIdError
                                    ? const Icon(Icons.refresh_rounded)
                                    : const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                      ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "required".tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Gaps.vGap30,

                /// button
                BlocBuilder<QuickBookingCubit, QuickBookingState>(
                  builder: (context, state) {
                    return state is QuickBookingLoading
                        ? const LoadingView()
                        : MyDefaultButton(
                            btnText: "confirm_booking",

                            borderRadius: 30,

                            height: 56.h,

                            onPressed: _onConfirmPressed,
                          );
                  },
                ),

                Gaps.vGap20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

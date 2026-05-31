import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/defult_text_field.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/core/widgets/loading_view.dart';
import 'package:alhakim/core/widgets/my_default_button.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/quick_booking_cubit/quick_booking_cubit.dart';
import 'package:alhakim/injection_container.dart';
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

  final dateController = TextEditingController();

  final firstNameFocus = FocusNode();

  final lastNameFocus = FocusNode();

  final phoneFocus = FocusNode();

  final dateFocus = FocusNode();

  DateTime? selectedDate;

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),

      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;

      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {});
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();

    lastNameController.dispose();

    phoneController.dispose();

    dateController.dispose();

    firstNameFocus.dispose();

    lastNameFocus.dispose();

    phoneFocus.dispose();

    dateFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuickBookingCubit, QuickBookingState>(
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

                          Gaps.hGap12,

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
                        ],
                      ),

                      Gaps.vGap18,

                      /// phone
                      MyTextFormField(
                        controller: phoneController,

                        focusNode: phoneFocus,

                        hintText: "phone_number".tr,

                        keyboardType: TextInputType.phone,

                        textInputAction: TextInputAction.done,

                        prefixIcon: const Icon(Icons.phone_android_outlined),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "required".tr;
                          }

                          return null;
                        },
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
                        alignment: Alignment.centerRight,

                        child: Text(
                          "appointment_date".tr,

                          style: TextStyles.medium16(),
                        ),
                      ),

                      Gaps.vGap10,

                      GestureDetector(
                        onTap: pickDate,

                        child: AbsorbPointer(
                          child: MyTextFormField(
                            controller: dateController,

                            focusNode: dateFocus,

                            hintText: "choose_date".tr,

                            prefixIcon: const Icon(
                              Icons.calendar_month_outlined,
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "required".tr;
                              }

                              return null;
                            },
                          ),
                        ),
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

                            onPressed: () {
                              if (!(formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }

                              context.read<QuickBookingCubit>().quickBooking(
                                params: QuickBookingParams(
                                  doctorId:
                                      sharedPreferences.getAuth()?.doctor?.id ??
                                      '',

                                  appointmentDate: dateController.text,

                                  firstName: firstNameController.text,

                                  lastName: lastNameController.text,

                                  countryCode: '+20',

                                  phoneNumber: phoneController.text,
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
        ),
      ),
    );
  }
}

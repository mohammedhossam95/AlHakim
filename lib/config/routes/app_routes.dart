import 'package:alhakim/config/routes/adaptive_route_page.dart';
import 'package:alhakim/config/routes/navigator_observer.dart'
    show routeObserver;
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/app_strings.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/appointments/presentation/cubt/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_appointments/get_appointments_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_queue_status/get_queue_status_cubit.dart';
import 'package:alhakim/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:alhakim/features/appointments/presentation/screens/follow_up_queue_screen.dart';
import 'package:alhakim/features/auth/presentation/cubit/complete_profile_cubit/complete_profile_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_all_cities_cubit/get_all_cities_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_countries_cubit/get_countries_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_setting/get_setting_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/resend_otp_cubit/resend_otp_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/send_code_cubit/send_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/screen/choose_user_type_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/complete_profile_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/login_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/otp_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/register_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/reset_password_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/splash_screen.dart';
import 'package:alhakim/features/booking/presentation/cubit/add_family_member_cubit/add_family_member_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_family_members_cubit/get_family_members_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_kinships_cubit/get_kinships_cubit.dart';
import 'package:alhakim/features/booking/presentation/screens/add_family_member_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/booking_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/family_members_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/success_screen.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_representative_stats_cubit/get_representative_stats_cubit.dart';
import 'package:alhakim/features/delegate/presentation/screens/add_new_doctor_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_doctors_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/update_doctor_screen.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/close_clinic_today_cubit/close_clinic_today_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_appoinments_for_day_cubit/get_doctor_appoinments_for_day_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_home_cubit/get_doctor_home_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/reschedule_cubit/reschedule_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggle_clinic_cubit/toggle_clinic_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/update_doctor_cubit/update_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/screens/clinic_home_screen.dart';
import 'package:alhakim/features/doctors/presentation/screens/reschedule_appointments_screen.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/get_queue_management_cubit/get_queue_management_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/quick_booking_cubit/quick_booking_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/update_queue_status_cubit/update_queue_status_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/screens/queue_management_screen.dart';
import 'package:alhakim/features/queue_management/presentation/screens/quick_booking_screen.dart';
import 'package:alhakim/features/settings/presentaion/cubit/update_user_profile_cubit/update_user_profile_cubit.dart';
import 'package:alhakim/features/settings/presentaion/screens/edit_profile_screen.dart';
import 'package:alhakim/features/settings/presentaion/screens/static_page_content_screen.dart';
import 'package:alhakim/features/settings/presentaion/screens/user_profile_screen.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialties_cubit/get_specialties_cubit.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialty_doctors_cubit/get_specialty_doctors_cubit.dart';
import 'package:alhakim/features/specialities/presentation/screens/doctors_list_screen.dart';
import 'package:alhakim/features/specialities/presentation/screens/specialities_screen.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/delete_user_account/delete_user_account_cubit.dart';
import '../../features/auth/presentation/screen/phone_entry_screen.dart';
import '../../features/home/presentation/cubit/all_ads_cubit/all_ads_cubit.dart';
import '../../features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/settings/presentaion/cubit/get_user_profile_cubit/get_user_profile_cubit.dart';
import '../../features/settings/presentaion/screens/change_password_screen.dart';
import '../../features/settings/presentaion/screens/contact_us_screen.dart';
import '../../features/tabbar/presentation/screens/main_page.dart';

abstract class Routes {
  static const String initialRoute = '/';
  static const String loginScreenRoute = '/LoginScreen';
  static const String phoneEntryScreenRoute = '/PhoneEntryScreen';
  static const String completeProfileRegisterScreenRoute =
      '/completeProfileRegisterScreen';

  static const String registerRoute = '/RegisterScreen';
  static const String secondStepRegisterScreenRoute =
      '/SecondStepRegisterScreen';
  static const String forgotPasswordRoute = '/ForgotPasswordScreen';
  static const String resetPasswordRoute = '/ResetPasswordScreen';
  static const String otpAuthRoute = '/OtpAuthScreen';
  static const String mainPageRoute = '/MainPage';
  static const String editProfileScreenRoute = '/EditProfileScreen';
  static const String changePasswordScreenRoute = '/ChangePasswordScreen';
  static const String contactUsRoute = '/ContactUsScreen';
  static const String notificationsScreenRoute = '/NotificationScreen';
  static const String allCategoriesScreenRoute = '/allCategoriesScreen';
  static const String allSubCategoriesScreenRoute = '/allSubCategoriesScreen';
  static const String productDetailsScreenRoute = '/productDetailsScreen';
  static const String productsScreenRoute = '/producsScreen';
  static const String addPostEntryRoute = '/addPostEntryScreen';
  static const String addPostCategoryRoute = '/addPostCategory';
  static const String addPostSubCategoryRoute = '/addPostSubCategory';
  static const String addPostFormRoute = '/addPostForm';
  static const String addPostPublishRoute = '/addPostPublish';
  static const String locationPickerScreenRoute = '/locationPickerScreen';
  static const String myMapViewRoute = '/MyMapViewScreen';
  static const String messagesRoute = '/MessagesScreen';
  static const String editMyAdScreenRoute = '/editMyAdScreen';
  static const String staticPageScreenRoute = '/StaticPageScreen';
  static const String favoritesScreenRoute = '/favoritesScreen';
  static const String userProfileScreenRoute = '/userProfileScreen';

  static const String specialitiesScreenRoute = '/specialitiesScreen';
  static const String doctorsListScreenRoute = '/doctorsListScreen';
  static const String bookingScreenRoute = '/bookingScreen';
  static const String familyMembersScreenRoute = '/familyMembersScreen';
  static const String addFamilyMemberScreenRoute = '/addFamilyMemberScreen';
  static const String chooseUserTypeScreenRoute = '/ChooseUserTypeScreen';
  static const String appointmentsScreenRoute = '/AppointmentsScreenRoute';
  static const String delegateDoctorsScreenRoute =
      '/DelegateDoctorsScreenRoute';
  static const String addDoctorScreenRoute = '/AddDoctorScreenRoute';
  static const String updateDoctorScreenRoute = '/UpdateDoctorScreenRoute';
  static const String clinicHomeScreenRoute = '/ClinicHomeScreenRoute';
  static const String rescheduleAppointmentsScreenRoute =
      '/RescheduleAppointmentsScreenRoute';
  static const String queueManagementScreenRoute =
      '/QueueManagementScreenRoute';
  static const String quickBookingScreenRoute = '/QuickBookingScreenRoute';
  static const String appoinmentSuccessScreen = '/AppoinmentSuccessScreen';
  static const String followUpQueueScreenRoute = '/FollowUpQueueScreenRoute';

  static final sl = ServiceLocator.instance;

  static final router = GoRouter(
    initialLocation: initialRoute,
    observers: [routeObserver],
    routes: [
      GoRoute(
        name: initialRoute,
        path: initialRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => sl<GetSettingCubit>()..getSetting(),
            child: SplashScreen(),
          ),
        ),
      ),

      /// LoginScreen
      GoRoute(
        name: loginScreenRoute,
        path: loginScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => sl<SendCodeCubit>(),
            child: const LoginScreen(),
          ),
        ),
      ),

      /// LoginScreen
      GoRoute(
        name: phoneEntryScreenRoute,
        path: phoneEntryScreenRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<RegisterCubit>(),
              child: PhoneEntryScreen(),
            ),
          );
        },
      ),

      GoRoute(
        path: addDoctorScreenRoute,
        name: addDoctorScreenRoute,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<GetSpecialtiesCubit>()),
            BlocProvider(create: (context) => sl<AddDoctorCubit>()),
          ],
          child: const AddNewDoctorScreen(),
        ),
      ),
      GoRoute(
        path: updateDoctorScreenRoute,
        name: updateDoctorScreenRoute,
        pageBuilder: (context, state) {
          final doctor = state.extra as DoctorEntity;
          return buildAdaptivePage(
            state: state,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<GetSpecialtiesCubit>()),
                BlocProvider(create: (context) => sl<UpdateDoctorCubit>()),
              ],
              child: UpdateDoctorScreen(doctor: doctor),
            ),
          );
        },
      ),

      GoRoute(
        name: completeProfileRegisterScreenRoute,
        path: completeProfileRegisterScreenRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<CompleteProfileCubit>(),
              child: CompleteProfileRegisterScreen(),
            ),
          );
        },
      ),

      /// Register
      GoRoute(
        name: registerRoute,
        path: registerRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (_) => sl<RegisterCubit>(),
              child: RegisterScreen(),
            ),
          );
        },
      ),

      GoRoute(
        name: chooseUserTypeScreenRoute,
        path: chooseUserTypeScreenRoute,
        builder: (context, state) => const ChooseUserTypeScreen(),
      ),

      GoRoute(
        path: clinicHomeScreenRoute,
        name: clinicHomeScreenRoute,
        builder: (context, state) => const ClinicHomeScreen(),
      ),

      GoRoute(
        path: rescheduleAppointmentsScreenRoute,
        name: rescheduleAppointmentsScreenRoute,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<GetDoctorAppoinmentsForDayCubit>(),
            ),
            BlocProvider(create: (context) => sl<RescheduleCubit>()),
          ],
          child: const RescheduleAppointmentsScreen(),
        ),
      ),

      GoRoute(
        path: queueManagementScreenRoute,
        name: queueManagementScreenRoute,
        builder: (context, state) => const QueueManagementScreen(),
      ),

      GoRoute(
        path: quickBookingScreenRoute,
        name: quickBookingScreenRoute,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<QuickBookingCubit>(),
          child: const QuickBookingScreen(),
        ),
      ),

      GoRoute(
        path: appointmentsScreenRoute,
        name: appointmentsScreenRoute,
        builder: (context, state) => const AppointmentsScreen(),
      ),

      GoRoute(
        path: followUpQueueScreenRoute,
        name: followUpQueueScreenRoute,
        builder: (context, state) {
          final args = state.extra as AppointmentEntity;
          return BlocProvider(
            create: (context) => sl<GetQueueStatusCubit>()
              ..getQueueStatus(appointmentId: args.id.toString()),
            child: FollowUpQueueScreen(appointment: args),
          );
        },
      ),

      GoRoute(
        path: delegateDoctorsScreenRoute,
        name: delegateDoctorsScreenRoute,
        builder: (context, state) => const DelegateDoctorsScreen(),
      ),

      /// Reset Password
      GoRoute(
        name: resetPasswordRoute,
        path: resetPasswordRoute,
        pageBuilder: (context, state) {
          final authParams = state.extra as AuthParams;
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<RegisterCubit>(),
              child: ResetPasswordScreen(authParams: authParams),
            ),
          );
        },
      ),

      /// OTP Auth
      GoRoute(
        name: otpAuthRoute,
        path: otpAuthRoute,
        pageBuilder: (context, state) {
          final args = state.extra as AuthParams;
          return buildAdaptivePage(
            state: state,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<VerifyCodeCubit>()),
                BlocProvider(create: (_) => sl<ResendOtpCubit>()),
              ],
              child: OtpAuthScreen(authParams: args),
            ),
          );
        },
      ),

      /// Main Page
      GoRoute(
        name: mainPageRoute,
        path: mainPageRoute,

        pageBuilder: (context, state) {
          final isDelegate = sessionCubit.state.userType == UserType.delegate;

          final isPatient = sessionCubit.state.userType == UserType.patient;

          return buildAdaptivePage(
            state: state,

            child: isDelegate
                ? MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            sl<GetDoctorsCubit>()..getDoctors(),
                      ),

                      BlocProvider(
                        create: (context) => sl<DeleteDoctorCubit>(),
                      ),

                      BlocProvider(
                        create: (context) => sl<ToggelDoctorStatusCubit>(),
                      ),

                      BlocProvider(
                        create: (context) => sl<GetRepresentativeStatsCubit>(),
                      ),
                    ],

                    child: const MainPage(),
                  )
                : isPatient
                ? MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            sl<GetSpecialtiesCubit>()..getSpecialties(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            sl<GetAppointmentsCubit>()..getAppointments(),
                      ),
                      BlocProvider(
                        create: (context) => sl<CancelAppointmentCubit>(),
                      ),
                    ],
                    child: const MainPage(),
                  )
                : MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => sl<GetDoctorHomeCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => sl<CloseClinicTodayCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => sl<ToggleClinicCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => sl<GetQueueManagementCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => sl<UpdateQueueStatusCubit>(),
                      ),
                    ],
                    child: const MainPage(),
                  ),
          );
        },
      ),
      GoRoute(
        path: specialitiesScreenRoute,
        name: specialitiesScreenRoute,
        pageBuilder: (context, state) =>
            buildAdaptivePage(state: state, child: const SpecialitiesScreen()),
      ),
      GoRoute(
        path: doctorsListScreenRoute,
        name: doctorsListScreenRoute,
        pageBuilder: (context, state) {
          final specialty = state.extra as SpecialtyEntity;
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<GetSpecialtyDoctorsCubit>(),
              child: DoctorsListScreen(specialty: specialty),
            ),
          );
        },
      ),
      GoRoute(
        path: bookingScreenRoute,
        name: bookingScreenRoute,
        pageBuilder: (context, state) {
          final doctor = state.extra as DoctorEntity;
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<BookAppointmentCubit>(),
              child: BookingScreen(doctor: doctor),
            ),
          );
        },
      ),

      GoRoute(
        path: familyMembersScreenRoute,
        name: familyMembersScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => sl<GetFamilyMembersCubit>(),
            child: const FamilyMembersScreen(),
          ),
        ),
      ),
      GoRoute(
        path: addFamilyMemberScreenRoute,
        name: addFamilyMemberScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<GetKinshipsCubit>()),
              BlocProvider(create: (context) => sl<AddFamilyMemberCubit>()),
            ],
            child: const AddFamilyMemberScreen(),
          ),
        ),
      ),

      /// Edit Profile
      GoRoute(
        name: editProfileScreenRoute,
        path: editProfileScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<GetAllCitiesCubit>()),
              BlocProvider(create: (_) => sl<GetCountriesCubit>()),
              BlocProvider(create: (_) => sl<GetUserProfileCubit>()),
              BlocProvider(create: (_) => sl<UpdateUserProfileCubit>()),
              BlocProvider(create: (_) => sl<DeleteUserAccountCubit>()),
            ],
            child: EditProfileScreen(),
          ),
        ),
      ),

      /// Search Screen
      GoRoute(
        name: changePasswordScreenRoute,
        path: changePasswordScreenRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: const ChangePasswordScreen(),
          );
        },
      ),
      GoRoute(
        name: contactUsRoute,
        path: contactUsRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: const ContactUsScreen(),
          );
        },
      ),
      GoRoute(
        name: appoinmentSuccessScreen,
        path: appoinmentSuccessScreen,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;

          return buildAdaptivePage(
            state: state,
            child: AppoinmentSuccessScreen(
              doctor: args['doctor'],
              appointmentDate: args['appointmentDate'],
            ),
          );
        },
      ),
      GoRoute(
        name: notificationsScreenRoute,
        path: notificationsScreenRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<NotificationsCubit>(),
              child: const NotificationScreen(),
            ),
          );
        },
      ),

      GoRoute(
        name: staticPageScreenRoute,
        path: staticPageScreenRoute,
        pageBuilder: (context, state) {
          final args = state.extra as StaticPageType;
          return buildAdaptivePage(
            state: state,
            child: StaticPageScreen(type: args),
          );
        },
      ),

      GoRoute(
        name: userProfileScreenRoute,
        path: userProfileScreenRoute,
        pageBuilder: (context, state) {
          final args = state.extra as int?;
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<AllAdsCubit>(),
              child: UserProfileScreen(userId: args),
            ),
          );
        },
      ),
      //-------
    ],

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(AppStrings.noRouteFound))),
  );

  static String get currentRoute => routesStack.last;
  static void pushRouteToRoutesStack(String route) {
    routesStack.add(route);
    ServiceLocator.injectRoutesStackSingleton(routesStack);
  }

  static void popRouteFromRoutesStack() {
    routesStack.removeLast();
    ServiceLocator.injectRoutesStackSingleton(routesStack);
  }
}

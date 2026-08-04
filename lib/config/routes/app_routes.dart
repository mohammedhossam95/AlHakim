import 'package:alhakim/config/routes/adaptive_route_page.dart';
import 'package:alhakim/config/routes/navigator_observer.dart'
    show routeObserver;
import 'package:alhakim/core/params/add_doctor_screen_args.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/app_strings.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_queue_status/get_queue_status_cubit.dart';
import 'package:alhakim/features/appointments/presentation/screens/follow_up_queue_screen.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/auth/presentation/cubit/check_account_cubit/check_account_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/complete_profile_cubit/complete_profile_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_all_cities_cubit/get_all_cities_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_countries_cubit/get_countries_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/resend_otp_cubit/resend_otp_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/screen/choose_user_type_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/complete_profile_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/login_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/otp_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/register_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/reset_password_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/splash_screen.dart';
import 'package:alhakim/features/booking/domain/entities/family_member_entity.dart';
import 'package:alhakim/features/booking/presentation/cubit/add_family_member_cubit/add_family_member_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/delete_family_member_cubit/delete_family_member_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_family_members_cubit/get_family_members_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_kinships_cubit/get_kinships_cubit.dart';
import 'package:alhakim/features/booking/presentation/screens/add_family_member_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/booking_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/family_members_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/success_screen.dart';
import 'package:alhakim/features/delegate/domain/entities/medical_center_entity.dart';
import 'package:alhakim/features/delegate/presentation/cubit/add_medical_center_cubit/add_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/update_medical_center_cubit/update_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/screens/add_new_doctor_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/add_new_medical_center_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_doctors_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/my_map_view_widget.dart';
import 'package:alhakim/features/delegate/presentation/screens/update_doctor_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/update_medical_center_screen.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/presentation/cubit/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_appoinments_for_day_cubit/get_doctor_appoinments_for_day_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_schedule_cubit/delete_schedule_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_by_id_cubit/get_doctor_by_id_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/reschedule_cubit/reschedule_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/search_doctors_cubit/search_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/update_doctor_cubit/update_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/screens/clinic_home_screen.dart';
import 'package:alhakim/features/doctors/presentation/screens/reschedule_appointments_screen.dart';
import 'package:alhakim/features/doctors/presentation/screens/search_doctors_screen.dart';
import 'package:alhakim/features/home/presentation/screen/agent_screen.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/quick_booking_cubit/quick_booking_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/screens/queue_management_screen.dart';
import 'package:alhakim/features/queue_management/presentation/screens/quick_booking_screen.dart';
import 'package:alhakim/features/settings/presentaion/cubit/app_setting_cubit/app_setting_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_emergency_categories_cubit/get_emergency_categories_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_hospital_emergency_cubit/get_hospital_emergency_cubit.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../features/auth/presentation/cubit/delete_user_account/delete_user_account_cubit.dart';
import '../../features/auth/presentation/screen/phone_entry_screen.dart';
import '../../features/home/presentation/cubit/all_ads_cubit/all_ads_cubit.dart';
import '../../features/home/presentation/cubit/analyze_complaint_cubit/analyze_complaint_cubit.dart';
import '../../features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/settings/presentaion/cubit/get_user_profile_cubit/get_user_profile_cubit.dart';
import '../../features/settings/presentaion/screens/change_password_screen.dart';
import '../../features/settings/presentaion/screens/contact_us_screen.dart';
import '../../features/settings/presentaion/screens/emergency_screen.dart';
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
  static const String agentScreenRoute = '/AgentScreen';
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
  static const String emergencyScreenRoute = '/emergencyScreen';
  static const String specialitiesScreenRoute = '/specialitiesScreen';
  static const String doctorsListScreenRoute = '/doctorsListScreen';
  static const String searchDoctorsScreenRoute = '/searchDoctorsScreen';
  static const String bookingScreenRoute = '/bookingScreen';
  static const String familyMembersScreenRoute = '/familyMembersScreen';
  static const String addFamilyMemberScreenRoute = '/addFamilyMemberScreen';
  static const String chooseUserTypeScreenRoute = '/ChooseUserTypeScreen';
  static const String delegateDoctorsScreenRoute =
      '/DelegateDoctorsScreenRoute';
  static const String addDoctorScreenRoute = '/AddDoctorScreenRoute';
  static const String addMedicalCenterScreenRoute =
      '/AddMedicalCenterScreenRoute';
  static const String updateDoctorScreenRoute = '/UpdateDoctorScreenRoute';
  static const String updateMedicalCenterScreenRoute =
      '/UpdateMedicalCenterScreenRoute';
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
        name: emergencyScreenRoute,
        path: emergencyScreenRoute,

        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<GetHospitalEmergencyCubit>()),
              BlocProvider(create: (_) => sl<GetEmergencyCategoriesCubit>()),
            ],
            child: const EmergencyScreen(isInTabBar: false),
          ),
        ),
      ),
      GoRoute(
        name: initialRoute,
        path: initialRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => sl<AppSettingCubit>(),
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<VerifyCodeCubit>()),
              BlocProvider(create: (_) => sl<CheckAccountCubit>()),
            ],
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
        builder: (context, state) {
          final args = state.extra as AddDoctorScreenArgs?;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<GetSpecialtiesCubit>()),
              BlocProvider(create: (context) => sl<AddDoctorCubit>()),
            ],
            child: AddNewDoctorScreen(
              source: args?.source ?? DoctorFormSource.delegate,
              medicalCenterProfile: args?.medicalCenterProfile,
            ),
          );
        },
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
        path: addMedicalCenterScreenRoute,
        name: addMedicalCenterScreenRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<AddMedicalCenterCubit>(),
              child: const AddNewMedicalCenterScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: updateMedicalCenterScreenRoute,
        name: updateMedicalCenterScreenRoute,
        pageBuilder: (context, state) {
          final medicalCenter = state.extra as MedicalCenterEntity;
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<UpdateMedicalCenterCubit>(),
              child: UpdateMedicalCenterScreen(medicalCenter: medicalCenter),
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
      GoRoute(
        path: myMapViewRoute,
        name: myMapViewRoute,
        builder: (context, state) {
          // Expecting state.extra to be a map with 'location' and 'onChanged'
          final map = state.extra as Map<String, dynamic>?;

          final LatLng initialLocation =
              map?['location'] as LatLng? ?? LatLng(30.0444, 31.2357);
          final LocationCallback? onChanged =
              map?['onChanged'] as LocationCallback?;

          return MyMapView(
            location: initialLocation,
            onLocationChanged: onChanged ?? (pos) {},
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
            BlocProvider(create: (context) => sl<DeleteScheduleCubit>()),
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
        path: '$followUpQueueScreenRoute/:appointmentId',
        name: followUpQueueScreenRoute,
        builder: (context, state) {
          final appointment = _resolveFollowUpAppointmentArgs(
            state.extra,
            appointmentId: state.pathParameters['appointmentId'],
          );

          if (appointment == null || appointment.id == null) {
            return const SizedBox.shrink();
          }

          return BlocProvider(
            create: (context) =>
                sl<GetQueueStatusCubit>()..getQueueStatus(
                  appointmentId: appointment.id.toString(),
                ),
            child: FollowUpQueueScreen(appointment: appointment),
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
          return buildAdaptivePage(state: state, child: const MainPage());
        },
      ),
      GoRoute(
        path: agentScreenRoute,
        name: agentScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => sl<AnalyzeComplaintCubit>(),
            child: const AIAgentScreen(),
          ),
        ),
      ),
      GoRoute(
        path: specialitiesScreenRoute,
        name: specialitiesScreenRoute,
        pageBuilder: (context, state) =>
            buildAdaptivePage(state: state, child: const SpecialitiesScreen()),
      ),
      GoRoute(
        path: '$doctorsListScreenRoute/:specialtyId',
        name: doctorsListScreenRoute,
        pageBuilder: (context, state) {
          // `extra` is not part of the URL and is lost on router remount
          // (e.g. locale change). Prefer extra, fall back to path/query.
          final specialtyFromExtra = state.extra as SpecialtyEntity?;
          final specialtyId =
              int.tryParse(state.pathParameters['specialtyId'] ?? '') ??
              specialtyFromExtra?.id;

          if (specialtyId == null) {
            return buildAdaptivePage(
              state: state,
              child: const SpecialitiesScreen(),
            );
          }

          final specialty =
              specialtyFromExtra ??
              SpecialtyEntity(
                id: specialtyId,
                name: state.uri.queryParameters['name'],
              );

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
        path: searchDoctorsScreenRoute,
        name: searchDoctorsScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => sl<SearchDoctorsCubit>(),
            child: SearchDoctorsScreen(initialQuery: state.extra as String?),
          ),
        ),
      ),
      GoRoute(
        path: bookingScreenRoute,
        name: bookingScreenRoute,
        pageBuilder: (context, state) {
          final doctor = state.extra as DoctorEntity;
          return buildAdaptivePage(
            state: state,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<BookAppointmentCubit>()),
                BlocProvider(create: (context) => sl<GetDoctorByIdCubit>()),
              ],
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
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<GetFamilyMembersCubit>()),
              BlocProvider(create: (context) => sl<DeleteFamilyMemberCubit>()),
            ],
            child: const FamilyMembersScreen(),
          ),
        ),
      ),
      GoRoute(
        path: addFamilyMemberScreenRoute,
        name: addFamilyMemberScreenRoute,
        pageBuilder: (context, state) {
          final member = state.extra as FamilyMemberEntity?;
          return buildAdaptivePage(
            state: state,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<GetKinshipsCubit>()),
                BlocProvider(create: (context) => sl<AddFamilyMemberCubit>()),
              ],
              child: AddFamilyMemberScreen(member: member),
            ),
          );
        },
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

AppointmentEntity? _resolveFollowUpAppointmentArgs(
  Object? extra, {
  String? appointmentId,
}) {
  if (extra is AppointmentEntity) {
    return extra;
  }

  if (extra is Map) {
    final map = Map<String, dynamic>.from(extra);
    final rawDoctor = map['doctor'];
    DoctorEntity? doctor;
    if (rawDoctor is DoctorEntity) {
      doctor = rawDoctor;
    } else if (rawDoctor is Map) {
      doctor = DoctorModel.fromJson(Map<String, dynamic>.from(rawDoctor));
    }

    final parsedId = int.tryParse(
      (map['id'] ?? map['appointment_id'] ?? appointmentId)?.toString() ?? '',
    );

    return AppointmentEntity(
      id: parsedId,
      appointmentDate:
          (map['appointment_date'] ?? map['appointmentDate'])?.toString(),
      appointmentType: map['appointment_type']?.toString(),
      appointmentTypeText: map['appointment_type_text']?.toString(),
      status: map['status']?.toString(),
      doctor: doctor,
      createdAt: map['created_at']?.toString(),
    );
  }

  if (appointmentId != null && appointmentId.isNotEmpty) {
    return AppointmentEntity(id: int.tryParse(appointmentId));
  }

  return null;
}

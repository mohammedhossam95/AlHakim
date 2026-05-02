import 'package:alhakim/config/routes/adaptive_route_page.dart';
import 'package:alhakim/config/routes/navigator_observer.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/app_strings.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_all_cities_cubit/get_all_cities_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_countries_cubit/get_countries_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_setting/get_setting_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/screen/choose_user_type_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/complete_profile_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/login_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/otp_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/register_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/reset_password_screen.dart';
import 'package:alhakim/features/auth/presentation/screen/splash_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/add_family_member_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/booking_screen.dart';
import 'package:alhakim/features/booking/presentation/screens/family_members_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_doctors_screen.dart';
import 'package:alhakim/features/settings/presentaion/cubit/update_user_profile_cubit/update_user_profile_cubit.dart';
import 'package:alhakim/features/settings/presentaion/screens/edit_profile_screen.dart';
import 'package:alhakim/features/settings/presentaion/screens/static_page_content_screen.dart';
import 'package:alhakim/features/settings/presentaion/screens/user_profile_screen.dart';
import 'package:alhakim/features/specialities/presentation/screens/doctors_list_screen.dart';
import 'package:alhakim/features/specialities/presentation/screens/specialities_screen.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/delete_user_account/delete_user_account_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
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

  static final _sl = ServiceLocator.instance;

  static final router = GoRouter(
    initialLocation: initialRoute,
    observers: [AppNavigatorObserver()],
    routes: [
      GoRoute(
        name: initialRoute,
        path: initialRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => _sl<GetSettingCubit>()..getSetting(),
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
            create: (context) => _sl<LoginCubit>(),
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
              create: (context) => _sl<RegisterCubit>(),
              child: PhoneEntryScreen(),
            ),
          );
        },
      ),

      /// LoginScreen
      GoRoute(
        name: completeProfileRegisterScreenRoute,
        path: completeProfileRegisterScreenRoute,
        pageBuilder: (context, state) {
          final args = state.extra as AuthParams;
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => _sl<RegisterCubit>(),
              child: CompleteProfileRegisterScreen(authParams: args),
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
              create: (_) => _sl<RegisterCubit>(),
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
        path: appointmentsScreenRoute,
        name: appointmentsScreenRoute,
        builder: (context, state) => const AppointmentsScreen(),
      ),

      GoRoute(
        path: delegateDoctorsScreenRoute,
        name: delegateDoctorsScreenRoute,
        builder: (context, state) => const DelegateDoctorsScreen(),
      ),

      /// Forgot Password
      GoRoute(
        name: forgotPasswordRoute,
        path: forgotPasswordRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: BlocProvider(
            create: (context) => _sl<LoginCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        ),
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
              create: (context) => _sl<RegisterCubit>(),
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
                BlocProvider(create: (_) => _sl<VerifyCodeCubit>()),
                BlocProvider(
                  create: (_) => _sl<RegisterCubit>(),
                ), //todo remove i use it to resend code
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
        pageBuilder: (context, state) =>
            buildAdaptivePage(state: state, child: const MainPage()),
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
        pageBuilder: (context, state) =>
            buildAdaptivePage(state: state, child: const DoctorsListScreen()),
      ),
      GoRoute(
        path: bookingScreenRoute,
        name: bookingScreenRoute,
        pageBuilder: (context, state) =>
            buildAdaptivePage(state: state, child: const BookingScreen()),
      ),

      GoRoute(
        path: familyMembersScreenRoute,
        name: familyMembersScreenRoute,
        pageBuilder: (context, state) =>
            buildAdaptivePage(state: state, child: const FamilyMembersScreen()),
      ),
      GoRoute(
        path: addFamilyMemberScreenRoute,
        name: addFamilyMemberScreenRoute,
        pageBuilder: (context, state) => buildAdaptivePage(
          state: state,
          child: const AddFamilyMemberScreen(),
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
              BlocProvider(create: (_) => _sl<GetAllCitiesCubit>()),
              BlocProvider(create: (_) => _sl<GetCountriesCubit>()),
              BlocProvider(create: (_) => _sl<GetUserProfileCubit>()),
              BlocProvider(create: (_) => _sl<UpdateUserProfileCubit>()),
              BlocProvider(create: (_) => _sl<DeleteUserAccountCubit>()),
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
        name: notificationsScreenRoute,
        path: notificationsScreenRoute,
        pageBuilder: (context, state) {
          return buildAdaptivePage(
            state: state,
            child: BlocProvider(
              create: (context) => _sl<NotificationsCubit>(),
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
              create: (context) => _sl<AllAdsCubit>(),
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

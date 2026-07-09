import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/appointments/presentation/cubt/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_appointments/get_appointments_cubit.dart';
import 'package:alhakim/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:alhakim/features/auth/presentation/cubit/logout/logout_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/delete_medical_center_cubit/delete_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_medical_centers_cubit/get_medical_centers_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_representative_stats_cubit/get_representative_stats_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/toggle_medical_center_status_cubit/toggle_medical_center_status_cubit.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_dashboard_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_doctors_screen.dart';
import 'package:alhakim/features/delegate/presentation/screens/delegate_medical_centers_screen.dart';
import 'package:alhakim/features/doctors/presentation/cubit/close_clinic_today_cubit/close_clinic_today_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_home_cubit/get_doctor_home_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggle_clinic_cubit/toggle_clinic_cubit.dart';
import 'package:alhakim/features/doctors/presentation/screens/clinic_home_screen.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/get_queue_management_cubit/get_queue_management_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/update_queue_status_cubit/update_queue_status_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/screens/queue_management_screen.dart';
import 'package:alhakim/features/settings/presentaion/screens/settings_screen.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialties_cubit/get_specialties_cubit.dart';
import 'package:alhakim/features/specialities/presentation/screens/specialities_screen.dart';
import 'package:alhakim/features/tabbar/presentation/cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageStorageBucket bucket = PageStorageBucket();

  int badge = 0;
  bool _pendingBottomNavResync = false;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  List<Widget> _buildTabsFor(UserType role) {
    final settingsTab = BlocProvider(
      create: (context) => ServiceLocator.instance<LogoutCubit>(),
      child: const SettingsScreen(),
    );

    return switch (role) {
      UserType.delegate => [
        const DelegateDashboardScreen(),
        const DelegateDoctorsScreen(),
        const DelegateMedicalCentersScreen(),
        settingsTab,
      ],
      UserType.patient => [
        const SpecialitiesScreen(),
        const AppointmentsScreen(),
        settingsTab,
      ],
      UserType.doctor => [
        ClinicHomeScreen(),
        QueueManagementScreen(),
        settingsTab,
      ],
    };
  }

  int _settingsTabIndex(UserType role) => role == UserType.delegate ? 3 : 2;

  Widget _wrapWithRoleProviders({
    required UserType role,
    required Widget child,
  }) {
    switch (role) {
      case UserType.delegate:
        return MultiBlocProvider(
          key: ValueKey('main-page-providers-${role.name}'),
          providers: [
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetDoctorsCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<DeleteDoctorCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<ToggelDoctorStatusCubit>(),
            ),
            BlocProvider(
              create: (_) =>
                  ServiceLocator.instance<GetRepresentativeStatsCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetMedicalCentersCubit>(),
            ),
            BlocProvider(
              create: (_) =>
                  ServiceLocator.instance<DeleteMedicalCenterCubit>(),
            ),
            BlocProvider(
              create: (_) =>
                  ServiceLocator.instance<ToggleMedicalCenterStatusCubit>(),
            ),
          ],
          child: child,
        );
      case UserType.patient:
        return MultiBlocProvider(
          key: ValueKey('main-page-providers-${role.name}'),
          providers: [
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetSpecialtiesCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetAppointmentsCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<CancelAppointmentCubit>(),
            ),
          ],
          child: child,
        );
      case UserType.doctor:
        return MultiBlocProvider(
          key: ValueKey('main-page-providers-${role.name}'),
          providers: [
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetDoctorHomeCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<CloseClinicTodayCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<ToggleClinicCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetQueueManagementCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<UpdateQueueStatusCubit>(),
            ),
          ],
          child: child,
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // BottomNavBarCubit lives above routes; a prior role (e.g. teacher tab 3) can
    // outlive navigation. Reset when MainPage mounts so tab count always matches.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen: (prev, curr) => prev.userType != curr.userType,
      builder: (context, sessionState) {
        final role = sessionState.userType;
        final tabs = _buildTabsFor(role);
        // final isTeacherShell = role == UserType.doctor;

        return _wrapWithRoleProviders(
          role: role,
          child: BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
            listenWhen: (pre, current) => pre.index != current.index,
            listener: (context, state) {},
            builder: (context, state) {
              final tabCount = tabs.length;
              final displayIndex = state.index >= 0 && state.index < tabCount
                  ? state.index
                  : 0;
              if (state.index != displayIndex && !_pendingBottomNavResync) {
                _pendingBottomNavResync = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _pendingBottomNavResync = false;
                  if (!context.mounted) return;
                  context.read<BottomNavBarCubit>().changeCurrentScreen(
                    index: displayIndex,
                  );
                });
              }
              return PopScope(
                canPop: displayIndex == 0,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  context.read<BottomNavBarCubit>().changeCurrentScreen(
                    index: 0,
                  );
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  // ACCESSING THE SCREEN VIA CUBIT STATE
                  body: PageStorage(bucket: bucket, child: tabs[displayIndex]),

                  // floatingActionButton: _buildFab(),
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: _buildBottomBar(context, displayIndex),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void onTapped(int index) {
    BlocProvider.of<BottomNavBarCubit>(
      context,
    ).changeCurrentScreen(index: index);
  }

  // Floating Action Button (The "Post" Button)
  // Widget _buildFab() {
  //   return FloatingActionButton(
  //     backgroundColor: colors.main,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
  //     onPressed: () {
  //       // if (!Constants.requireAuth(context)) return;
  //       // ServiceLocator.instance<AddPostCubit>().resetFlow();
  //       // context.pushNamed(Routes.addPostEntryRoute);
  //     },
  //     child: Icon(Icons.add, color: colors.whiteColor, size: 32.sp),
  //   );
  // }

  // Bottom Navigation Bar UI
  Widget _buildBottomBar(BuildContext context, int currentIndex) {
    final role = sessionCubit.state.userType;
    final settingsIndex = _settingsTabIndex(role);

    return Container(
      decoration: BoxDecoration(
        //color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: colors.textColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4), // shadow goes UP
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Expanded(
            //   child: _navItem(
            //     context,
            //     0,
            //     FontAwesomeIcons.house,
            //     "home".tr,
            //     currentIndex,
            //   ),
            // ),
            (sessionCubit.state.userType == UserType.patient)
                ? Expanded(
                    child: _navItem(
                      context,
                      0,

                      Icons.group,
                      "specialities_title".tr,
                      currentIndex,
                    ),
                  )
                : (sessionCubit.state.userType == UserType.delegate)
                ? Expanded(
                    child: _navItem(
                      context,
                      0,

                      Icons.dashboard,
                      "dashboard".tr,
                      currentIndex,
                    ),
                  )
                : Expanded(
                    child: _navItem(
                      context,
                      0,
                      Icons.home_outlined,
                      "home".tr,
                      currentIndex,
                    ),
                  ),

            // const SizedBox(width: 48), // Gap for FAB
            sessionCubit.state.userType == UserType.delegate
                ? Expanded(
                    child: _navItem(
                      context,
                      1,
                      Icons.group,
                      "doctors".tr,
                      currentIndex,
                    ),
                  )
                : sessionCubit.state.userType == UserType.patient
                ? Expanded(
                    child: _navItem(
                      context,
                      1,
                      Icons.calendar_month,
                      "appointments".tr,
                      currentIndex,
                    ),
                  )
                : Expanded(
                    child: _navItem(
                      context,
                      1,
                      Icons.manage_history,
                      "queue_management".tr,
                      currentIndex,
                    ),
                  ),
            if (role == UserType.delegate)
              Expanded(
                child: _navItem(
                  context,
                  2,
                  Icons.local_hospital_outlined,
                  "medical_centers".tr,
                  currentIndex,
                ),
              ),
            Expanded(
              child: _navItem(
                context,
                settingsIndex,
                Icons.settings,
                "settings".tr,
                currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Individual Nav Item that triggers the Cubit
  Widget _navItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    int activeIndex,
  ) {
    final bool isSelected = activeIndex == index;
    final Color color = isSelected ? colors.main : colors.lightTextColor;

    return SizedBox(
      //height: 60,
      child: InkWell(
        onTap: () {
          context.read<BottomNavBarCubit>().changeCurrentScreen(index: index);
          if (index == 1 && sessionCubit.state.userType == UserType.delegate) {
            context.read<GetDoctorsCubit>().getDoctors();
          }
          if (index == 2 && sessionCubit.state.userType == UserType.delegate) {
            context.read<GetMedicalCentersCubit>().getMedicalCenters();
          }
          if (index == 1 && sessionCubit.state.userType == UserType.patient) {
            context.read<GetAppointmentsCubit>().getAppointments();
          }
          if (index == 1 && sessionCubit.state.userType == UserType.doctor) {
            context.read<GetQueueManagementCubit>().getQueueManagement(
              doctorId: sharedPreferences.getAuth()?.doctor?.id ?? '',
            );
          }
          if (index == 0 && sessionCubit.state.userType == UserType.doctor) {
            context.read<GetDoctorHomeCubit>().getDoctorHome();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22.sp),
              Gaps.vGap4,
              Text(label, style: TextStyles.medium10(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

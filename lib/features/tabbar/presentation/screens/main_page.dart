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
import 'package:alhakim/features/doctors/presentation/cubit/get_medical_center_doctors_cubit/get_medical_center_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggle_clinic_cubit/toggle_clinic_cubit.dart';
import 'package:alhakim/features/doctors/presentation/screens/clinic_home_screen.dart';
import 'package:alhakim/features/doctors/presentation/screens/medical_center_doctors_selection_screen.dart';
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

  List<Widget> _buildTabsFor(SessionState sessionState) {
    final role = sessionState.userType;

    final settingsTab = BlocProvider(
      create: (_) => ServiceLocator.instance<LogoutCubit>(),
      child: const SettingsScreen(),
    );

    return switch (role) {
      UserType.delegate => [
        BlocProvider(
          create: (_) => ServiceLocator.instance<GetRepresentativeStatsCubit>(),
          child: const DelegateDashboardScreen(),
        ),
        MultiBlocProvider(
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
          ],
          child: const DelegateDoctorsScreen(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetMedicalCentersCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<DeleteMedicalCenterCubit>(),
            ),
            BlocProvider(
              create: (_) =>
                  ServiceLocator.instance<ToggleMedicalCenterStatusCubit>(),
            ),
          ],
          child: const DelegateMedicalCentersScreen(),
        ),
        settingsTab,
      ],
      UserType.patient => [
        BlocProvider(
          create: (_) => ServiceLocator.instance<GetSpecialtiesCubit>(),
          child: const SpecialitiesScreen(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetAppointmentsCubit>(),
            ),
            BlocProvider(
              create: (_) => ServiceLocator.instance<CancelAppointmentCubit>(),
            ),
          ],
          child: const AppointmentsScreen(),
        ),
        settingsTab,
      ],
      UserType.doctor => _buildDoctorTabs(sessionState, settingsTab),
    };
  }

  List<Widget> _buildDoctorTabs(
    SessionState sessionState,
    Widget settingsTab,
  ) {
    if (sessionState.doctorAccountMode == DoctorAccountMode.medicalCenter &&
        sessionState.activeDoctorId == null) {
      return [
        BlocProvider(
          create: (_) =>
              ServiceLocator.instance<GetMedicalCenterDoctorsCubit>(),
          child: const MedicalCenterDoctorsSelectionScreen(),
        ),
        settingsTab,
      ];
    }

    return [
      MultiBlocProvider(
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
        ],
        child: const ClinicHomeScreen(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ServiceLocator.instance<GetQueueManagementCubit>(),
          ),
          BlocProvider(
            create: (_) => ServiceLocator.instance<UpdateQueueStatusCubit>(),
          ),
        ],
        child: const QueueManagementScreen(),
      ),
      settingsTab,
    ];
  }

  int _settingsTabIndex(SessionState sessionState) {
    if (sessionState.userType == UserType.delegate) return 3;

    if (sessionState.userType == UserType.doctor &&
        sessionState.doctorAccountMode == DoctorAccountMode.medicalCenter &&
        sessionState.activeDoctorId == null) {
      return 1;
    }

    return 2;
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
      buildWhen: (prev, curr) =>
          prev.userType != curr.userType ||
          prev.status != curr.status ||
          prev.doctorAccountMode != curr.doctorAccountMode ||
          prev.activeDoctorId != curr.activeDoctorId,
      builder: (context, sessionState) {
        final tabs = _buildTabsFor(sessionState);

        return BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
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
                body: PageStorage(bucket: bucket, child: tabs[displayIndex]),
                bottomNavigationBar: _buildBottomBar(
                  context,
                  displayIndex,
                  sessionState,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onTapped(int index) {
    BlocProvider.of<BottomNavBarCubit>(
      context,
    ).changeCurrentScreen(index: index);
  }

  Widget _buildBottomBar(
    BuildContext context,
    int currentIndex,
    SessionState sessionState,
  ) {
    if (sessionState.userType == UserType.doctor &&
        sessionState.doctorAccountMode == DoctorAccountMode.medicalCenter &&
        sessionState.activeDoctorId == null) {
      return _buildMedicalCenterSelectionBottomBar(context, currentIndex);
    }

    final role = sessionState.userType;
    final settingsIndex = _settingsTabIndex(sessionState);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colors.textColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
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
            role == UserType.patient
                ? Expanded(
                    child: _navItem(
                      context,
                      0,
                      Icons.group,
                      "specialities_title".tr,
                      currentIndex,
                    ),
                  )
                : role == UserType.delegate
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
            role == UserType.delegate
                ? Expanded(
                    child: _navItem(
                      context,
                      1,
                      Icons.group,
                      "doctors".tr,
                      currentIndex,
                    ),
                  )
                : role == UserType.patient
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

  Widget _buildMedicalCenterSelectionBottomBar(
    BuildContext context,
    int currentIndex,
  ) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colors.textColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
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
            Expanded(
              child: _navItem(
                context,
                0,
                Icons.group,
                "doctors".tr,
                currentIndex,
              ),
            ),
            Expanded(
              child: _navItem(
                context,
                1,
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
      child: InkWell(
        onTap: () {
          context.read<BottomNavBarCubit>().changeCurrentScreen(index: index);
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

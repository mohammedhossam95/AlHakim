// ignore_for_file: strict_top_level_inference

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../../../injection_container.dart';
import '../cubit/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageStorageBucket bucket = PageStorageBucket();
  final PersistentTabController _controller = PersistentTabController();

  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
      listenWhen: (pre, current) => pre.index != current.index,
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<BottomNavBarCubit>();

        return PopScope(
          canPop: state.index == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.read<BottomNavBarCubit>().changeCurrentScreen(index: 0);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // ACCESSING THE SCREEN VIA CUBIT STATE
            body: IndexedStack(index: state.index, children: cubit.screens),

            // floatingActionButton: _buildFab(),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _buildBottomBar(context, state.index),
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
                : const Spacer(),

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
                : Expanded(
                    child: _navItem(
                      context,
                      1,
                      Icons.calendar_month,
                      "appointments".tr,
                      currentIndex,
                    ),
                  ),
            Expanded(
              child: _navItem(
                context,
                2,
                FontAwesomeIcons.user,
                "my_profile".tr,
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
          // features that require auth
          // final protectedTabs = [1, 3];

          // if (protectedTabs.contains(index)) {
          //   if (!Constants.requireAuth(context)) return;
          // }

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

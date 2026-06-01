// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    await context.read<SessionCubit>().resolveSession();
    if (!mounted) return;
    _scheduleNavigationFromSession();
  }

  void _scheduleNavigationFromSession() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final session = context.read<SessionCubit>().state;
      log('Splash navigate for: ${session.status}');
      if (session.status == SessionStatus.firstLaunch) {
        context.go(Routes.chooseUserTypeScreenRoute);
      } else if (session.status == SessionStatus.authenticated) {
        context.go(Routes.mainPageRoute);
      } else {
        context.go(Routes.chooseUserTypeScreenRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            FadeIn(
              delay: Duration(milliseconds: 800),
              curve: Curves.easeIn,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png", height: 400.h),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 3),
            // --- 3. Loading Progress Bar ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.w),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.main),
                      minHeight: 2.5,
                    ),
                  ),
                  Gaps.vGap12,
                  Text(
                    "LOADING SECURE ENVIRONMENT",
                    style: TextStyle(
                      color: colors.main,
                      fontSize: 8.sp,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            Gaps.vGap40,
          ],
        ),
      ),
    );
  }
}

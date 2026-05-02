// ignore_for_file: use_build_context_synchronously
import 'package:alhakim/core/utils/values/text_styles.dart';
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
    context.read<SessionCubit>().resolveSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SessionCubit, SessionState>(
        listener: (context, session) {
          Future.delayed(const Duration(seconds: 2), () {
            //this applay geust mode
            // if (session.status == SessionStatus.firstLaunch) {
            //   context.pushReplacementNamed(Routes.phoneEntryScreenRoute);
            // } else if (session.status == SessionStatus.guest) {
            //   context.pushReplacementNamed(Routes.loginScreenRoute);
            // } else if (session.status == SessionStatus.authenticated) {
            //  context.pushReplacementNamed(Routes.mainPageRoute);
            //}
            context.pushReplacementNamed(Routes.chooseUserTypeScreenRoute);
          });
        },

        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              FadeIn(
                delay: Duration(milliseconds: 600),
                curve: Curves.easeIn,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: colors.main,
                        child: Icon(
                          Icons.medical_services_outlined,
                          color: colors.whiteColor,
                          size: 40,
                        ),
                      ),

                      Gaps.vGap16,

                      Text(
                        "Al-Hakim",
                        style: TextStyles.semiBold24(color: colors.main),
                      ),
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
      ),
    );
  }
}

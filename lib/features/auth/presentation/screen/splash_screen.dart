// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/values/text_styles.dart';
import 'package:alhakim/core/widgets/custom_alert.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/settings/domain/entity/app_setting_entity.dart';
import 'package:alhakim/features/settings/presentaion/cubit/app_setting_cubit/app_setting_cubit.dart';
import 'package:alhakim/injection_container.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _forceUpdateShown = false;

  Future<void> _continueToApp() async {
    await context.read<SessionCubit>().resolveSession();
    if (!mounted) return;

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final session = context.read<SessionCubit>().state;
    log('Splash navigate for: ${session.status}');

    if (session.status == SessionStatus.guest ||
        session.status == SessionStatus.firstLaunch ||
        session.status == SessionStatus.authenticated) {
      context.go(Routes.mainPageRoute);
    } else {
      context.go(Routes.chooseUserTypeScreenRoute);
    }
  }

  void _showForceUpdateDialog(String? storeUrl) {
    if (_forceUpdateShown || !mounted) return;
    _forceUpdateShown = true;

    CustomAlert().showAlertDialog(
      context: context,
      isDismissible: false,
      onpress: () {
        if (storeUrl != null && storeUrl.isNotEmpty) {
          Constants.launchURL(storeUrl);
        }
      },
      title: 'update_app'.tr,
      subTitle: 'force_update_app_body'.tr,
      btnTitle: 'update',
      color: colors.main,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppSettingCubit, AppSettingState>(
        listener: (context, state) async {
          if (state is AppSettingLoaded) {
            final config = state.resp.data as AppConfigEntity?;
            final update = config?.update;
            final updateType = update?.type?.toLowerCase();

            if (updateType == 'force') {
              _showForceUpdateDialog(update?.storeUrl);
              return;
            }

            // optional / none / null → continue normally
            await _continueToApp();
          }
        },
        builder: (context, state) {
          if (state is AppSettingError) {
            return SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  FadeIn(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Image.asset(
                        'assets/images/logo2.png',
                        height: 200.h,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  InkWell(
                    onTap: () {
                      _forceUpdateShown = false;
                      context.read<AppSettingCubit>().getAppsetting();
                    },
                    child: Column(
                      children: [
                        Icon(Icons.refresh, color: colors.main, size: 28.sp),
                        Gaps.vGap8,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            state.message,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyles.regular12(color: colors.main),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.vGap40,
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                FadeIn(
                  delay: const Duration(milliseconds: 800),
                  curve: Curves.easeIn,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo2.png',
                          height: 200.h,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.main,
                          ),
                          minHeight: 2.5,
                        ),
                      ),
                      Gaps.vGap12,
                      Text(
                        'LOADING SECURE ENVIRONMENT',
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
          );
        },
      ),
    );
  }
}

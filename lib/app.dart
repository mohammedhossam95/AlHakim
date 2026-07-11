import 'dart:developer';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/api/auth_event_bus.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/features/settings/setting_injection.dart';
import '/features/tabbar/tabbar_injection.dart';
import 'config/locale/app_localizations_setup.dart';
import 'config/routes/app_routes.dart';
import 'config/routes/navigator_observer.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'core/utils/values/text_styles.dart';
import 'features/language/language_injection.dart';
import 'features/language/presentation/cubit/locale_cubit/locale_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isDialogShown = false;
  @override
  void initState() {
    super.initState();

    AuthEventBus.instance.unauthorizedStream.listen((_) async {
      if (_isDialogShown) return;

      final ctx = routeObserver.context;
      if (ctx == null || !ctx.mounted) return;
      if (routeObserver.currentRoute == null) return;
      if (routeObserver.currentRoute == Routes.loginScreenRoute) return;

      _isDialogShown = true;
      await showDialog<void>(
        context: ctx,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('sessionExpiredTitle'.tr),
            content: Text('sessionExpired'.tr),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _handleLogout();
                  _isDialogShown = false;
                },
                child: Text('login'.tr),
              ),
            ],
          );
        },
      );
      _isDialogShown = false;
    });
  }

  Future<void> _handleLogout() async {
    try {
      await sessionCubit.logout();
    } catch (e, st) {
      debugPrint('Logout error: $e\n$st');
    }
    if (!mounted) return;
    context.push(Routes.chooseUserTypeScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [...languageBlocs, ...bottomNavBlocs, ...settingBlocs],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previous, current) {
          return previous.locale.languageCode != current.locale.languageCode;
        },
        builder: (context, state) {
          log('LocaleCubit state: ${state.locale.languageCode}');
          TextStyles.updateForLocale(state.locale.languageCode);
          return LayoutBuilder(
            builder: (context, constrants) {
              return ScreenUtilInit(
                designSize: Size(constrants.maxWidth, constrants.maxHeight),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp.router(
                    key: ValueKey(state.locale.languageCode),
                    title: AppStrings.appName,
                    locale: state.locale,
                    debugShowCheckedModeBanner: false,
                    theme: getAppTheme(state.locale.languageCode),
                    themeMode: ThemeMode.light,
                    routerDelegate: Routes.router.routerDelegate,
                    routeInformationParser:
                        Routes.router.routeInformationParser,
                    routeInformationProvider:
                        Routes.router.routeInformationProvider,
                    builder: (context, child) {
                      return Directionality(
                        textDirection: state.locale.languageCode == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: child ?? const SizedBox.shrink(),
                      );
                    },
                    supportedLocales: AppLocalizationsSetup.supportedLocales,
                    localeResolutionCallback:
                        AppLocalizationsSetup.localeResolutionCallback,
                    localizationsDelegates:
                        AppLocalizationsSetup.localizationsDelegates,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

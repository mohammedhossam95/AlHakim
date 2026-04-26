import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/features/settings/setting_injection.dart';
import '/features/tabbar/tabbar_injection.dart';
import 'config/locale/app_localizations_setup.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'features/language/language_injection.dart';
import 'features/language/presentation/cubit/locale_cubit/locale_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // final bool _isDialogShown = false;
  @override
  void initState() {
    super.initState();

    // AuthEventBus.instance.unauthorizedStream.listen((_) async {
    //   if (_isDialogShown) return; // Prevent showing multiple dialogs
    //   final ctx = navigatorKey.currentContext!;
    //   if (!ctx.mounted) return;

    //   // Ensure the current route is valid before showing the dialog
    //   if (routeObserver.currentRoute == null) return;

    //   debugPrint("current route ${routeObserver.currentRoute}");
    //   _isDialogShown = true;
    //   CustomAlert().showAlertDialog(
    //     context: ctx,
    //     onpress: () async {
    //       Navigator.of(ctx).pop(); // Close the dialog
    //       // Clear secure storage

    //       secureStorage.removeDeviceToken();
    //       secureStorage.clearAll();
    //       // Navigate to login screen
    //       navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //         Routes.loginScreenRoute,
    //         (route) => false,
    //       );
    //       // Reset the dialog flag once it's closed
    //       _isDialogShown = false;
    //     },
    //     title: "sessionExpiredTitle".tr,
    //     subTitle: "sessionExpired".tr,
    //     btnTitle: "login",
    //   );
    // });
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
                    theme: getAppTheme(context),
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

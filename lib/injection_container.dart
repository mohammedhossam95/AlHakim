import 'package:alhakim/features/home/home_injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/api/auth_event_bus.dart';
import '/features/notifications/notifications_injection.dart';
import '/features/settings/setting_injection.dart';
import '/features/tabbar/tabbar_injection.dart';
import 'config/locale/app_localizations.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/services/local_storage/app_secure_storage.dart';
import 'core/services/local_storage/app_shared_preferences.dart';
import 'core/utils/values/app_colors.dart';
import 'features/auth/auth_injection.dart';
import 'features/language/language_injection.dart';

abstract class ServiceLocator {
  static final GetIt instance = GetIt.instance;

  static Future<void> init() async {
    instance.allowReassignment = true;

    /// Features

    await initsettingFeatureInjection();

    ///
    await initLanguageFeatureInjection();
    await initAuthFeatureInjection();
    await initTabbarFeatureInjection();
    await initNotificationsFeatureInjection();

    await initHomeFeatureInjection();

    /// Core
    await _injectSharedPreferences();
    _injectSecureStorage();
    _injectDioConsumer();
    _injectAppInterceptors();
    _injectEventBus();
    _injectLogInterceptor();
    injectRoutesStackSingleton(<String>[]);
    injectAppColors(
      appColors: AppColors(
        backGround: MyColors.backGround,
        whiteColor: MyColors.whiteColor,
        main: MyColors.main,
        secondary: MyColors.secondary,
        textColor: MyColors.textColor,
        errorColor: MyColors.errorColor,
        review: MyColors.review,
        lightTextColor: MyColors.lightTextColor,
        lightBackGroundColor: MyColors.lightBackGroundColor,
        success: MyColors.success,
        error: MyColors.error,
        warning: MyColors.warning,
      ),
    );
  }

  static void _injectDioConsumer() {
    instance.registerLazySingleton<DioConsumer>(
      () => DioConsumerImpl(client: Dio()),
    );
  }

  static void _injectEventBus() {
    instance.registerLazySingleton<AuthEventBus>(() => AuthEventBus.instance);
  }

  static void _injectAppInterceptors() {
    instance.registerLazySingleton(() => AppInterceptors());
  }

  static void _injectLogInterceptor() {
    instance.registerLazySingleton(
      () => LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ),
    );
  }

  static Future<void> _injectSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    instance.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferencesImpl(instance: sharedPreferences),
    );
  }

  static void _injectSecureStorage() {
    AndroidOptions androidOptions = const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    final FlutterSecureStorage secureStorage = FlutterSecureStorage(
      aOptions: androidOptions,
    );
    instance.registerLazySingleton<AppSecureStorage>(
      () => AppSecureStorageImpl(instance: secureStorage),
    );
  }

  static void injectAppColors({
    AppColors? appColors,
    BuildContext? context,
  }) async {
    instance.registerLazySingleton<AppColors>(() {
      // if (context != null) {
      //   return Theme.of(context).extension<AppColors>()!;
      // }
      return appColors!;
    });
  }

  static void injectAppLocalizations({
    AppLocalizations? appLocalizations,
    BuildContext? context,
  }) async {
    instance.registerLazySingleton<AppLocalizations>(() {
      if (context != null) {
        return AppLocalizations.of(context)!;
      }
      return appLocalizations!;
    });
  }

  static void injectRoutesStackSingleton(List<String> routes) {
    instance.registerLazySingleton<List<String>>(
      () => routes,
      instanceName: 'routesStack',
    );
  }

  static void injectTokenFCMSingleton(String? tokenFCM) =>
      instance.registerLazySingleton<String>(
        () => tokenFCM ?? '',
        instanceName: 'tokenFCM',
      );
}

AppSharedPreferences get sharedPreferences =>
    ServiceLocator.instance<AppSharedPreferences>();

AuthEventBus get eventBus => ServiceLocator.instance<AuthEventBus>();

AppSecureStorage get secureStorage =>
    ServiceLocator.instance<AppSecureStorage>();

DioConsumer get dioConsumer => ServiceLocator.instance<DioConsumer>();

AppInterceptors get appInterceptors =>
    ServiceLocator.instance<AppInterceptors>();

LogInterceptor get logInterceptor => ServiceLocator.instance<LogInterceptor>();

AppColors get colors => ServiceLocator.instance<AppColors>();

AppLocalizations get appLocalizations =>
    ServiceLocator.instance<AppLocalizations>();

List<String> get routesStack =>
    ServiceLocator.instance<List<String>>(instanceName: 'routesStack');

String get tokenFCM =>
    ServiceLocator.instance<String>(instanceName: 'tokenFCM');

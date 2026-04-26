import 'dart:async';

import 'package:alhakim/core/services/local_database/database_helper.dart';
import 'package:alhakim/core/services/local_database/favorite_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app.dart';
import 'core/services/bloc_observer/bloc_observer.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();

  // Initialize timeago locales
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xffFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.light, // for iOS
      statusBarIconBrightness: Brightness.dark, // for Android
    ),
  );

  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  // NotificationService.instance.initialize();
  Bloc.observer = AppBlocObserver();
  dioConsumer.updateDeviceTypeHeader();
  sharedPreferences.clearSecureStorageOnFreshInstall();
  await DBHelper.initDB();
  await FavoriteDatabaseHelper.instance.database;

  runApp(const App());
}

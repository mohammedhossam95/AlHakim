import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:alhakim/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {
    // Firebase may already be initialized in this isolate.
  }

  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'high_importance_channel';
  static const String _legacyChannelId = 'com.sharaftech.alhakim';

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Setup message handlers
    await _setupMessageHandlers();

    await setupFlutterNotifications();

    // Get FCM token
    final token = await _messaging.getToken();
    log('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('Permission settings: $settings');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    // Remove orphaned auto-created FCM channel (old id) before creating the
    // canonical channel.
    await androidPlugin?.deleteNotificationChannel(_legacyChannelId);

    // android setup
    const channel = AndroidNotificationChannel(
      _channelId,
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      sound: null,
      enableVibration: true,
    );

    await androidPlugin?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS permissions are requested via FirebaseMessaging.requestPermission.
    // Keep Darwin request flags false to avoid a second system prompt.
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Map<String, dynamic> payloadDecode = json.decode(details.payload ?? '');
        // int? typeId = int.parse(payloadDecode['type_id'] ?? 0);
        // String? type = payloadDecode['type'];
        // if (type == "chat") {
        // var jsonStr = jsonDecode(payloadDecode['message']);
        // ChatMessage messageData = MessageModel.fromJson(jsonStr);

        // _onSelect(type, typeId, message: messageData);
        // } else {
        //   _onSelect(type, typeId);
        // }
      },
    );

    await androidPlugin?.requestNotificationsPermission();

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          sound: null,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          presentBanner: true,
        ),
      ),
      payload: json.encode(message.data),
    );
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
      //todo
      // if (routeObserver.currentRoute != Routes.messagesRoute) {
      //   showNotification(message);
      // }
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    log(message.data.toString());

    // int? typeId = int.parse(message.data['type_id'] ?? 0);
    // String? type = message.data['type'];
    // Log.e(message.data['message'].toString());
    // if (message.data['type'] == "chat") {
    // var jsonStr = jsonDecode(message.data['message']);
    // ChatMessage messageData = MessageModel.fromJson(jsonStr);
    // _onSelect(type, typeId, message: messageData);
    // } else {
    //   _onSelect(type, typeId);
    // }
  }

  // void _onSelect(String? type, int? typeId) {
  //   try {
  //     if (type != null) {
  //       if (type == "task") {
  //         // navigatorKey.currentState?.pushNamed(
  //         //   Routes.taskDetailsScreenRoute,
  //         //   arguments: TaskEntity(id: typeId),
  //         // );
  //       } else if (type == 'hot_deal') {
  //         // navigatorKey.currentState?.pushNamed(Routes.myBookingsScreenRoute);
  //       } else if (type == 'chat') {
  //         // navigatorKey.currentState?.pushNamed(
  //         //   Routes.messagesRoute,
  //         //   arguments: ChatParams(
  //         //     conversationId: "$typeId",
  //         //     receiverId: int.parse(message?.senderId ?? '0'),
  //         //   ),
  //         // );
  //       } else {
  //         //  navigatorKey.currentState?.pushNamed(Routes.notificationsScreenRoute);
  //       }
  //     } else {
  //       //  navigatorKey.currentState?.pushNamed(Routes.notificationsScreenRoute);
  //     }
  //   } catch (e) {
  //     Log.e("Navigator ${e.toString()}");
  //   }
  // }
}

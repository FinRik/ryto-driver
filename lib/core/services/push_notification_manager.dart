import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../utils/storage/fcm_token_storage.dart';
import '../models/driver_notification.dart';

@pragma('vm:entry-point')
void onLocalNotificationTapBackground(NotificationResponse response) {
  debugPrint(
    'From Background Isolate: Local notification clicked with payload: ${response.payload}',
  );
}

class PushNotificationService {
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  static final PushNotificationService _instance =
      PushNotificationService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal();

  Future<void> initNotification() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? fcmToken = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $fcmToken');

    if (fcmToken != null) {
      _setFcmToken(fcmToken);
    }

    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('Token refreshed: $newToken');
      // Here you would send this token to your server
      _setFcmToken(newToken);
    });

    // Set up foreground notification presentation options
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Initialize local notifications
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestSoundPermission: true,
      requestAlertPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onLocalNotificationTapBackground,
      onDidReceiveNotificationResponse: (response) {
        debugPrint(
          'From Foreground: Notification clicked with payload: ${response.payload}',
        );

        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data = json.decode(response.payload!);

            // Parse into DriverNotification model
            final notification = DriverNotification.fromJson(data);

            // Dispatch navigation or handling logic
            _handleNotificationAction(notification);
          } catch (e) {
            debugPrint('Failed to parse notification click payload: $e');
          }
        }
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await _notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${json.encode(message.data)}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification:');
        debugPrint('Title: ${message.notification?.title}');
        debugPrint('Body: ${message.notification?.body}');
        showNotification(message.notification!, message);
      }
    });

    // Test if topics work when direct messages don't
    // await FirebaseMessaging.instance.subscribeToTopic('all_users');
    // debugPrint('Subscribed to topic: all_users');
  }

  Future<void> showNotification(
    RemoteNotification notification,
    RemoteMessage message,
  ) async {
    final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final iosPlatformChannelSpecifics = const DarwinNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notificationPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: platformChannelSpecifics,
      payload: json.encode(message.data),
    );

    debugPrint(
      'Local notification displayed with payload: ${json.encode(message.data)}',
    );
  }
  
  Future<void> showSocketNotification(DriverNotification message) async {
    final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final iosPlatformChannelSpecifics = const DarwinNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notificationPlugin.show(
      id: message.hashCode,
      title: message.title,
      body: message.body,
      notificationDetails: platformChannelSpecifics,
      payload: json.encode(message),
    );

    debugPrint(
      'Local notification displayed with payload: ${json.encode(message)}',
    );
  }

  void _handleNotificationAction(DriverNotification notification) {
    switch (notification.type) {
      case 'ride_request':
      case 'trip_payment':
      case 'booking_verified':
      case 'trip_reminder':
        if (notification.tripId != null) {
          // Example navigation:
          // router.push('/trip-details', extra: notification.tripId);
        }
        break;

      case 'new_message':
        if (notification.chatId != null) {
          // Example navigation:
          // router.push('/chat', extra: notification.chatId);
        }
        break;
    }
  }

  void _setFcmToken(String token) async =>
      await FcmTokenStorage.saveFCMToken(token);
}

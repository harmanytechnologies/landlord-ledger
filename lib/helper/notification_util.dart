import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationUtil {
  static late AndroidNotificationChannel _channel;
  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static const String _channelId = '1';
  static const String _channelName = 'babel';
  static const String _channelDescription = 'This channel is used for important notifications.';

  static Future<void> init() async {
    await requestNotificationPermission();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Set the background messaging handler early on, as a named top-level function
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _channel = const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );

    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);

    if (Platform.isAndroid) {
      var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
      var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (value) => _onSelectNotification(value),
        onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
      );
    }

    /// Update the iOS foreground notification presentation options to allow heads up notifications.
    // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
    var data = jsonDecode(notificationResponse.payload!);
    debugPrint('_notificationTapBackground: $data');
  }

  // @pragma('vm:entry-point')
  // static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   debugPrint('_firebaseMessagingBackgroundHandler: ${message.data}');
  // }

  static Future<void> _onSelectNotification(NotificationResponse response) async {
    ///when the notification is clicked from the app (app is in foreground)
    await _clearAllNotifications();
    final payload = response.payload;
    if (payload != null) {
      var data = jsonDecode(payload);
      debugPrint('_onSelectNotification: $data');
      _handleTapOnNotification(data);
    }
    //in else part it will automatically opens the app and calls the default route
  }

  // static Future<void> listen() async {
  //   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
  //     if (kDebugMode) print("getInitialMessage: The Notification is received here in 1st step and showed in tray");
  //     debugPrint('getInitialMessage: ${message?.data}');

  //     int? type = int.tryParse(message?.data['type'].toString() ?? "");
  //     if (type != null) {
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         // _appPreferences.setNotification(loggedIn: true);
  //         // _appPreferences.setEventTitle(title: jsonEncode(message?.data));
  //       });
  //     }
  //   });

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (kDebugMode) print("listen: The Notification is received here in 2nd step and showed in app");
  //     debugPrint('listen: ${message.data}');

  //     var notification = message.notification;
  //     if (notification != null) {
  //       _flutterLocalNotificationsPlugin.show(
  //           int.parse(_channel.id),
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             iOS: DarwinNotificationDetails(),
  //             android: AndroidNotificationDetails(
  //               _channel.id,
  //               _channel.name,
  //               channelDescription: _channel.description,
  //               icon: 'app_icon',
  //             ),
  //           ),
  //           payload: Platform.isAndroid ? jsonEncode(message.data) : null);
  //     }
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     (RemoteMessage message) async {
  //       ///when the notification is clicked from the tray (app is in background)
  //       if (kDebugMode) print("The Notification is received here in 3rd step and showed in tray");
  //       debugPrint('onMessageOpenedApp: ${message.data}');
  //       await _clearAllNotifications();
  //       _handleTapOnNotification(message.data);
  //     },
  //   );
  // }

  static Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static void _handleTapOnNotification(Map<String, dynamic>? data) {
    if (data == null) return;

  }

  static Future<void> _clearAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Failed to clear notifications: $e');
    }
  }
}

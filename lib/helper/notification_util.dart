import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../views/reminders/reminder_detail_view.dart';

class NotificationUtil {
  static late AndroidNotificationChannel _channel;
  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static const String _channelId = '1';
  static const String _channelName = 'Landlord Ledger';
  static const String _channelDescription = 'This channel is used for important notifications.';

  static Future<void> init() async {
    await requestNotificationPermission();

    // Initialize timezone data
    tz.initializeTimeZones();

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

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (value) => _onSelectNotification(value),
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    /// Update the iOS foreground notification presentation options to allow heads up notifications.
    // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action when notification is tapped in background
    final payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('_notificationTapBackground: reminderId=$payload');
      _handleTapOnNotificationById(payload);
    }
  }

  // @pragma('vm:entry-point')
  // static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   debugPrint('_firebaseMessagingBackgroundHandler: ${message.data}');
  // }

  static Future<void> _onSelectNotification(NotificationResponse response) async {
    ///when the notification is clicked from the app (app is in foreground)
    final payload = response.payload;
    if (payload != null) {
      // Payload is the reminder ID (string)
      debugPrint('_onSelectNotification: reminderId=$payload');
      _handleTapOnNotificationById(payload);
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

  static void _handleTapOnNotificationById(String reminderId) {
    // Navigate to reminder detail view
    try {
      Get.to(() => ReminderDetailView(reminderId: reminderId));
    } catch (e) {
      debugPrint('Failed to navigate to reminder: $e');
    }
  }

  /// Schedule a notification for a reminder
  /// Returns true if scheduled successfully, false otherwise
  static Future<bool> scheduleReminderNotification({
    required int id, // Use reminder ID hash as notification ID
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final now = DateTime.now();

      // Don't schedule if the date is in the past
      if (scheduledDate.isBefore(now)) {
        debugPrint('Cannot schedule notification for past date: $scheduledDate');
        return false;
      }

      // For Android
      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'app_icon',
        enableVibration: true,
        playSound: true,
      );

      // For iOS
      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Convert scheduled date to TZDateTime
      final scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);

      // Schedule the notification
      // Try exact scheduling first, fall back to inexact if permission is not granted
      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledTZ,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        // If exact alarm permission is not granted, use inexact scheduling
        debugPrint('Exact alarm not permitted, using inexact scheduling: $e');
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledTZ,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }

      debugPrint('Scheduled notification for reminder: $title at $scheduledDate');
      return true;
    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
      return false;
    }
  }

  /// Cancel a scheduled notification for a reminder
  static Future<void> cancelReminderNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      debugPrint('Cancelled notification with id: $id');
    } catch (e) {
      debugPrint('Failed to cancel notification: $e');
    }
  }

  /// Cancel all scheduled notifications
  static Future<void> cancelAllScheduledNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      debugPrint('Cancelled all scheduled notifications');
    } catch (e) {
      debugPrint('Failed to cancel all notifications: $e');
    }
  }

  /// Get a unique notification ID from reminder ID string
  static int getNotificationId(String reminderId) {
    // Convert reminder ID string to a hash code for use as notification ID
    return reminderId.hashCode.abs();
  }
}

// import 'dart:convert';
// import 'dart:developer';

// import 'package:alphafit/main.dart';
// import 'package:alphafit/model/gym.dart';
// import 'package:alphafit/screens/admin/gyms_details_admin_view.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// void initFCM() {
//   // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
//   //   log("getInitialMessage: ");
//   //   if (message != null) {}
//   // });

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     // log("onMessage:");

//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android; //? implement separate for ios
//     if (notification != null && android != null) {
//       _showNotification(message);
//     }
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     // log("onMessageOpenedApp:");
//     // _handelNotification(message.data);
//   });

//   //initialize
//   var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
//   var initializationSettingsIOs = IOSInitializationSettings();
//   var initSetttings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
//   flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: selectNotification);
// }

// Future selectNotification(String? payload) async {
//   if (payload != null) {
//     Map<String, dynamic> data = jsonDecode(payload);

//     _handelNotification(data);
//   }
// }

// _handelNotification(Map data) {
//   // var routeTo = user == null
//   //     ? Login()
//   //     : widget.isAdmin
//   //         ? OrderItems(id: data['order_id'])
//   //         : MyOrderItems(id: data['order_id']);

//   Navigator.pushNamed(globalNavState.currentContext!, GymsDetailsAdminView.routeName, arguments: Gym(id: data['gym_id']));
//   // Navigator.push(globalNavState.currentContext!, MaterialPageRoute(builder: (context) => GymsDetailsAdminView()));
// }

// Future _showNotification(RemoteMessage message) async {
//   var android = AndroidNotificationDetails('id', 'channel ', priority: Priority.high, importance: Importance.max);
//   var iOS = IOSNotificationDetails();
//   var platform = new NotificationDetails(android: android, iOS: iOS);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     message.notification!.title,
//     message.notification!.body,
//     platform,
//     payload: jsonEncode(message.data),
//   );
// }

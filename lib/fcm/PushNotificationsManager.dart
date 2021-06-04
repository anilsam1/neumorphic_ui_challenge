// import 'dart:convert';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:sample_app/core/db/app_db.dart';
//
// class PushNotificationsManager {
//   PushNotificationsManager._();
//
//   factory PushNotificationsManager() => _instance;
//
//   static final PushNotificationsManager _instance = PushNotificationsManager._();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'customer_channel',
//     'Customer Update',
//     'channel_description',
//     importance: Importance.high,
//   );
//
//   Future<void> init() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     /// Update the iOS foreground notification presentation options to allow
//     /// heads up notifications.
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     _firebaseMessaging.getToken().then((String? token) {
//       appDB.fcmToken = token!;
//       print("Push Messaging token: ${appDB.fcmToken}");
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       if (notification != null && android != null) {
//         _showNotificationWithDefaultSound(message);
//       }
//     });
//
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       print("====================initialMessage=======================");
//       printRemoteMessage(initialMessage);
//     }
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("====================onMessageOpenedApp=======================");
//       printRemoteMessage(message);
//       updateNavigation(message.data);
//     });
//
//     var android = AndroidInitializationSettings('mipmap/ic_launcher');
//     var ios = IOSInitializationSettings();
//     var platform = InitializationSettings(android: android, iOS: ios);
//     flutterLocalNotificationsPlugin.initialize(
//       platform,
//       onSelectNotification: (payload) {
//         print("====================onSelectNotification=======================");
//         print(payload);
//         updateNavigation(jsonDecode(payload!));
//         return Future.value(jsonDecode(payload));
//       },
//     );
//   }
//
//   Future _showNotificationWithDefaultSound(RemoteMessage payload) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'customer_channel', 'Customer Update', 'channel_description',
//         importance: Importance.max, priority: Priority.high);
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
//
//     var notification = payload.notification;
//     var data = payload.data;
//
//     print("====================_showNotificationWithDefaultSound=======================");
//     printRemoteMessage(payload);
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       notification!.title ?? "",
//       notification.body ?? "",
//       platformChannelSpecifics,
//       payload: jsonEncode(payload.data),
//     );
//   }
//
// //Data: {"clickaction":"FLUTTERNOTIFICATIONCLICK","poll_id":"2","tag":"poll_push","body":"Hurry up new poll added","title":"Poll","message":"Hurry up new poll added"}
//
// }
//
// const String pollPush = "poll_push";
// const String storyPush = "story_push";
// const String quizPush = "quiz_push";
//
// void updateNavigation(Map data) {
//   print("===============updateNavigation=================");
//   print(jsonEncode(data));
//
//   switch (data["tag"]) {
//     case pollPush:
//       {
//         // navigator.pushOrReplacementNamed(RouteName.landing, arguments: Map.of({"tab": 2}));
//         break;
//       }
//
//     case quizPush:
//     case storyPush:
//       {
//         print("StoryPUSH NAVIGATE:");
//         // navigator.pushOrReplacementNamed(RouteName.landing, arguments: Map.of({"tab": 0}));
//         break;
//       }
//   }
// }
//
// printRemoteMessage(RemoteMessage message) {
//   print(message);
//   print("Notification_TITLE: ${jsonEncode(message.notification!.title)}");
//   print("Notification_BODY: ${jsonEncode(message.notification!.body)}");
//   print("Data: ${jsonEncode(message.data)}");
// }
//
// /*
// It must not be an anonymous function.
// It must be a top-level function (e.g. not a class method which requires initialization).
// */
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
//
//   updateNavigation(message.data);
// }

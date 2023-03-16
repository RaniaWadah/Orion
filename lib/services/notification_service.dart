// // // import 'package:firebase_messaging/firebase_messaging.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // //
// // // class NotificationService {
// // //   const NotificationService._();
// // //
// // //   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
// // //   FlutterLocalNotificationsPlugin();
// // //
// // //   static const AndroidNotificationChannel _androidChannel =
// // //   AndroidNotificationChannel(
// // //     'myChannel',
// // //     'myChannel',
// // //     description: 'description',
// // //     importance: Importance.max,
// // //     playSound: true,
// // //   );
// // //
// // //   static NotificationDetails _notificationDetails() {
// // //     return NotificationDetails(
// // //       android: AndroidNotificationDetails(
// // //         _androidChannel.id,
// // //         _androidChannel.name,
// // //         channelDescription: _androidChannel.description,
// // //         importance: Importance.max,
// // //         priority: Priority.max,
// // //         playSound: true,
// // //         icon: '@mipmap/ic_launcher',
// // //       ),
// // //       iOS: const DarwinNotificationDetails(),
// // //     );
// // //   }
// // //
// // //   static Future<void> initializeNotification() async {
// // //     const AndroidInitializationSettings androidInitializationSettings =
// // //     AndroidInitializationSettings('@mipmap/ic_launcher');
// // //
// // //     await _notificationsPlugin.initialize(
// // //       const InitializationSettings(
// // //           android: androidInitializationSettings,
// // //           iOS: DarwinInitializationSettings()),
// // //     );
// // //   }
// // //
// // //   static void onMessage(RemoteMessage message) {
// // //     RemoteNotification? notification = message.notification;
// // //     AndroidNotification? androidNotification = message.notification?.android;
// // //     AppleNotification? appleNotification = message.notification?.apple;
// // //
// // //     if (notification == null) return;
// // //
// // //     if (androidNotification != null || appleNotification != null) {
// // //       _notificationsPlugin.show(
// // //         notification.hashCode,
// // //         notification.title,
// // //         notification.body,
// // //         _notificationDetails(),
// // //       );
// // //     }
// // //   }
// // //
// // //   static void onMessageOpenedApp(BuildContext context, RemoteMessage message) {
// // //     RemoteNotification? notification = message.notification;
// // //     AndroidNotification? androidNotification = message.notification?.android;
// // //     AppleNotification? appleNotification = message.notification?.apple;
// // //
// // //     if (notification == null) return;
// // //
// // //     if (androidNotification != null || appleNotification != null) {
// // //       showDialog(
// // //         context: context,
// // //         builder: (_) => AlertDialog(
// // //           title: Text(notification.title ?? 'No Title'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(notification.body ?? 'No body'),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       );
// // //     }
// // //   }
// // // }
// //
// // import 'dart:convert';
// // import 'dart:html';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;
// //
// //
// // class LocalNotificationService{
// //   static Future initialize (FlutterLocalNotificationsPlugin _notificationsPlugin) async {
// //     var androidInitialization = new AndroidInitializationSettings(
// //         "@mipmap/ic_launcher");
// //     var initializationSettings = new InitializationSettings(
// //         android: androidInitialization);
// //     await _notificationsPlugin.initialize(initializationSettings);
// //   }
// //
// //   static Future sendPushMessage(String token, String title, String body,
// //       FlutterLocalNotificationsPlugin fln) async{
// //
// //     final getHelpTime = DateTime.now().add(const Duration(seconds: 10));
// //     (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
// //     try{
// //       await http.post(
// //           Uri.parse('http://fcm.googleapis.com/fcm/send'),
// //           headers: <String, String>{
// //             'Content-Type': 'application/json',
// //             'Authorization':
// //             'key=AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg',
// //           },
// //           body: jsonEncode(
// //               <String, dynamic>{
// //                 "priority" : "high",
// //                 "data" : <String, dynamic>{
// //                   "click-action" : "FLUTTER_NOTIFICATION_CLICK",
// //                   "status" : "done",
// //                   "body" : body,
// //                   "title" : title,
// //                 },
// //                 "notification" : <String, dynamic>{
// //                   "title" : title,
// //                   "body" : body,
// //                   "android_channel_id" : "pushnotification",
// //                 },
// //                 "to" : token,
// //               }
// //           )
// //       );
// //       // AndroidNotificationDetails androidPlatformChannelSpecifics =
// //       // new AndroidNotificationDetails(
// //       //   'pushnotification',
// //       //   'pushnotification',
// //       //   playSound: true,
// //       //   importance: Importance.max,
// //       //   priority: Priority.high,
// //       // );
// //       // var notification = NotificationDetails(android: androidPlatformChannelSpecifics);
// //       // await fln.show(token, title, body, notification);
// //
// //     }catch (e){
// //       print(e);
// //     }
// //   }
// //
// //
// //   static Future showNotification({var id = 0, required String title, required String body,
// //     var payload, required FlutterLocalNotificationsPlugin fln}) async{
// //     AndroidNotificationDetails androidPlatformChannelSpecifics =
// //     new AndroidNotificationDetails(
// //       'pushnotification',
// //       'pushnotification',
// //       playSound: true,
// //       importance: Importance.max,
// //       priority: Priority.high,
// //     );
// //     var notification = NotificationDetails(android: androidPlatformChannelSpecifics);
// //     await fln.show(0, title, body, notification);
// //   }
// // }
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationService {
//   static final _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future<void> initNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     var details = await NotificationService._notifications.getNotificationAppLaunchDetails();
//     if (details!.didNotificationLaunchApp) {
//       print(details);
//     }
//   }
//
//   static Future sendPushMessage(String token, String body, String title) async{
//     // final getHelpTime = DateTime.now().add(const Duration(seconds: 10));
//     // (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
//     try{
//       await http.post(
//           Uri.parse('http://fcm.googleapis.com/fcm/send'),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//             'Authorization':
//             'key=AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg',
//           },
//           body: jsonEncode(
//               <String, dynamic>{
//                 "priority" : "max",
//                 "Importance" : "high",
//                 "data" : <String, dynamic>{
//                   "click-action" : "FLUTTER_NOTIFICATION_CLICK",
//                   "status" : "done",
//                   "body" : body,
//                   "title" : title,
//                   // "id" : 1,
//                   "channelId" : "pushnotification",
//                 },
//                 "to" : token,
//                 "token" : token,
//               }
//           )
//       );
//     }catch (e){
//       print(e);
//     }
//   }
// }
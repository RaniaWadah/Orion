// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // class NotificationService {
// //   const NotificationService._();
// //
// //   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   static const AndroidNotificationChannel _androidChannel =
// //   AndroidNotificationChannel(
// //     'myChannel',
// //     'myChannel',
// //     description: 'description',
// //     importance: Importance.max,
// //     playSound: true,
// //   );
// //
// //   static NotificationDetails _notificationDetails() {
// //     return NotificationDetails(
// //       android: AndroidNotificationDetails(
// //         _androidChannel.id,
// //         _androidChannel.name,
// //         channelDescription: _androidChannel.description,
// //         importance: Importance.max,
// //         priority: Priority.max,
// //         playSound: true,
// //         icon: '@mipmap/ic_launcher',
// //       ),
// //       iOS: const DarwinNotificationDetails(),
// //     );
// //   }
// //
// //   static Future<void> initializeNotification() async {
// //     const AndroidInitializationSettings androidInitializationSettings =
// //     AndroidInitializationSettings('@mipmap/ic_launcher');
// //
// //     await _notificationsPlugin.initialize(
// //       const InitializationSettings(
// //           android: androidInitializationSettings,
// //           iOS: DarwinInitializationSettings()),
// //     );
// //   }
// //
// //   static void onMessage(RemoteMessage message) {
// //     RemoteNotification? notification = message.notification;
// //     AndroidNotification? androidNotification = message.notification?.android;
// //     AppleNotification? appleNotification = message.notification?.apple;
// //
// //     if (notification == null) return;
// //
// //     if (androidNotification != null || appleNotification != null) {
// //       _notificationsPlugin.show(
// //         notification.hashCode,
// //         notification.title,
// //         notification.body,
// //         _notificationDetails(),
// //       );
// //     }
// //   }
// //
// //   static void onMessageOpenedApp(BuildContext context, RemoteMessage message) {
// //     RemoteNotification? notification = message.notification;
// //     AndroidNotification? androidNotification = message.notification?.android;
// //     AppleNotification? appleNotification = message.notification?.apple;
// //
// //     if (notification == null) return;
// //
// //     if (androidNotification != null || appleNotification != null) {
// //       showDialog(
// //         context: context,
// //         builder: (_) => AlertDialog(
// //           title: Text(notification.title ?? 'No Title'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(notification.body ?? 'No body'),
// //               ],
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //   }
// // }
//
// import 'dart:convert';
// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
//
// class LocalNotificationService{
//   static Future initialize (FlutterLocalNotificationsPlugin _notificationsPlugin) async {
//     var androidInitialization = new AndroidInitializationSettings(
//         "@mipmap/ic_launcher");
//     var initializationSettings = new InitializationSettings(
//         android: androidInitialization);
//     await _notificationsPlugin.initialize(initializationSettings);
//   }
//
//   static Future sendPushMessage(String token, String title, String body,
//       FlutterLocalNotificationsPlugin fln) async{
//
//     final getHelpTime = DateTime.now().add(const Duration(seconds: 10));
//     (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
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
//                 "priority" : "high",
//                 "data" : <String, dynamic>{
//                   "click-action" : "FLUTTER_NOTIFICATION_CLICK",
//                   "status" : "done",
//                   "body" : body,
//                   "title" : title,
//                 },
//                 "notification" : <String, dynamic>{
//                   "title" : title,
//                   "body" : body,
//                   "android_channel_id" : "pushnotification",
//                 },
//                 "to" : token,
//               }
//           )
//       );
//       // AndroidNotificationDetails androidPlatformChannelSpecifics =
//       // new AndroidNotificationDetails(
//       //   'pushnotification',
//       //   'pushnotification',
//       //   playSound: true,
//       //   importance: Importance.max,
//       //   priority: Priority.high,
//       // );
//       // var notification = NotificationDetails(android: androidPlatformChannelSpecifics);
//       // await fln.show(token, title, body, notification);
//
//     }catch (e){
//       print(e);
//     }
//   }
//
//
//   static Future showNotification({var id = 0, required String title, required String body,
//     var payload, required FlutterLocalNotificationsPlugin fln}) async{
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//     new AndroidNotificationDetails(
//       'pushnotification',
//       'pushnotification',
//       playSound: true,
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var notification = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, notification);
//   }
// }

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, AndroidNotificationChannel channel) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                styleInformation: BigTextStyleInformation(''),
              ),
            ));
      }
    });

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //   var details = await NotificationService._notifications
  //       .getNotificationAppLaunchDetails();
  //   if (details!.didNotificationLaunchApp) {
  //     print(details);
  //   }
  // }
  //
  // NotificationDetails get _ongoing {
  //   final androidChannelSpecifics = AndroidNotificationDetails(
  //     'pushnotification',
  //     'pushnotification',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ongoing: true,
  //     styleInformation: BigTextStyleInformation(''),
  //   );
  //   return NotificationDetails();
  }

  Future<void> sendPushMsgPlb(List<String> token, String title, String body, List<XFile>? imageList) async {
    bool isEmpty = true;
    final userSnapshot = await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).get();
    print(userSnapshot.data()!['Area'].toString());
    if(imageList!.isNotEmpty){
      isEmpty = false;
    }
    if(isEmpty) {
      try {
        String serverKey = "AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg";
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode({
            "registration_ids": token,
            'data': {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              'via': 'FlutterFire Cloud Messaging!!!',
              "image": "gs://csc350orion.appspot.com/files/eb579226-4e07-4fa4-9117-4330b108f1ab7432483971391303323.jpg/file",
            },
            'notification': {
              'title': title,
              'body': body+ "\nSent from "+ userSnapshot.data()!['Area'].toString() + ", "
                  + userSnapshot.data()!['Block'].toString(),
              'sound': 'default',
              'alert': 'new',
              'image': userSnapshot.data()!['imageUrl'],
              // 'image': 'https://s3.us-east-2.amazonaws.com/crypticpoint.projects.upload/convergein/users/162738162682638205.jpg',
            },
          }),
        );
        print('FCM request for device sent!');
      } catch (e) {
        print(e);
      }
    }
    else if(!isEmpty){
      try {
        String serverKey = "AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg";
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode({
            "registration_ids": token,
            'data': {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              'via': 'FlutterFire Cloud Messaging!!!',
              "image": "gs://csc350orion.appspot.com/files/eb579226-4e07-4fa4-9117-4330b108f1ab7432483971391303323.jpg/file",
            },
            'notification': {
              'title': title,
              'body': body + '\nImage\nSent from '+ userSnapshot.data()!['Area'].toString() + ", "
                  + userSnapshot.data()!['Block'].toString(),
              'sound': 'default',
              'alert': 'new',
              'image': userSnapshot.data()!['imageUrl'],
              // 'image': 'https://s3.us-east-2.amazonaws.com/crypticpoint.projects.upload/convergein/users/162738162682638205.jpg',
            },
          }),
        );
        // styleInformation: bigTextStyleInformation;
        print('FCM request for device sent!');
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> sendPushMsg(List<String> token, String title, String body) async {
    final userSnapshot = await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).get();
    print(userSnapshot.data()!['Area'].toString());
    try {
      String serverKey = "AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg";
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey'
        },
        body: jsonEncode({
          "registration_ids": token,
          'data': {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            'via': 'FlutterFire Cloud Messaging!!!',
            "image": "gs://csc350orion.appspot.com/files/eb579226-4e07-4fa4-9117-4330b108f1ab7432483971391303323.jpg/file",
          },
          'notification': {
            'title': title,
            'body': body + "\nSent from "+ userSnapshot.data()!['Area'].toString() + ", "
                + userSnapshot.data()!['Block'].toString(),
            'sound': 'default',
            'alert': 'new',
            'image': userSnapshot.data()!['imageUrl'],
            // 'image': 'https://s3.us-east-2.amazonaws.com/crypticpoint.projects.upload/convergein/users/162738162682638205.jpg',
          },
        }),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

}
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';

class NotificationService {
  static Future<void> initNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, AndroidNotificationChannel channel) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

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
            },
          }),
        );
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
          },
        }),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

}
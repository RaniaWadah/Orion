import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:rxdart/subjects.dart';

class localNotification{
  localNotification();
  final _localNotificationService = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async{
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('');

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,

    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true);

    return const NotificationDetails(
      android: androidNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    _localNotificationService.show(id, title, body, details);
  }

  Future<void> showNotificationWithPayload(
      {required int id,
        required String title,
        required String body,
        required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  Future<void> onSelectNotification(String? payload) async{
    print('payload $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
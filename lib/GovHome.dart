import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/GiveAlarm.dart';
import 'package:untitled2/Identify.dart';
import 'package:untitled2/ProvideSafetyMessage.dart';
import 'package:untitled2/StartRecording.dart';
import 'package:untitled2/Track.dart';
import 'package:untitled2/ViewNotifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GovHome extends StatelessWidget {
  const GovHome({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
    child: AppBar(
          title: Container(
            width: 200,
            alignment: Alignment.center,
            child: Image.asset('images/Orion.png'),
          ),
          backgroundColor: const Color(0xFFB9CAE0),
          elevation: 0.0,
          titleSpacing: 10.0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        ),
        body: const GovHomeWidget(),
      ),
    );
  }
}

class GovHomeWidget extends StatefulWidget {
  const GovHomeWidget({Key? key}) : super(key: key);

  @override
  State<GovHomeWidget> createState() => _GovHomeWidgetState();
}

class _GovHomeWidgetState extends State<GovHomeWidget> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  String? token = '';
  String? mtoken = ' ';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission.');
    }
    else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission.');
    }
    else {
      print('User declined or has not accepted permission.');
    }
  }

  void getAddress() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    String address = await GetAddressFromLatLong(position);
    String area = await GetAreaFromLatLong(position);
    await FirebaseFirestore.instance.collection('government').
    doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'Location': address.toString()}, SetOptions(merge: true)
    );
    await FirebaseFirestore.instance.collection('government').
    doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'Area': area.toString()}, SetOptions(merge: true)
    );
  }

    Future<void> saveToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = await _firebaseMessaging.getToken();
      await FirebaseFirestore.instance.collection('government').
      doc(FirebaseAuth.instance.currentUser!.uid).set(
          {'Token': token}, SetOptions(merge: true)
      );
      prefs.setString('token', token!);
      print(token);
    }

    _getAndSaveToken() async {
      _firebaseMessaging.getToken().then((token) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", token!);
        print(token);
      });
    }

    Future<void> messageHandler() async {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

    }

    String constructFCMPayload(String token) {
      return jsonEncode({
        'to': token,
        'data': {
          'via': 'FlutterFire Cloud Messaging!!!',
        },
        'notification': {
          'title': 'Your item is added successfully !',
          'body': 'Please subscribe, like and share this tutorial !',
        },
      });
    }

    Future<void> sendPushMsg(String token, String title, String body) async {
      try {
        String serverKey = "AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg";
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=$serverKey'
          },
          body: jsonEncode({
            'to': token,
            'data': {
              'via': 'FlutterFire Cloud Messaging!!!',
            },
            'notification': {
              'title': title,
              'body': body,
              "image": "images/Orion.png",
              'sound': 'default',
              'alert': 'new',
            },
          }),
        );
        print('FCM request for device sent!');
      } catch (e) {
        print(e);
      }
    }


    void sendPushMessage(String token, String body, String title) async {
      try {
        await http.post(
            Uri.parse('http://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
              'key=AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg',
            },
            body: jsonEncode(
                <String, dynamic>{
                  "priority": "high",
                  "data": <String, dynamic>{
                    "click-action": "FLUTTER_NOTIFICATION_CLICK",
                    "status": "done",
                    "body": body,
                    "title": title,
                  },
                  "notification": <String, dynamic>{
                    "title": title,
                    "body": body,
                    "id": 9,
                    "android_channel_id": "pushnotification",
                  },
                  "to": token,
                  "token": token,
                }
            )
        );
        // final getHelpTime = DateTime.now().add(const Duration(seconds: 60));
        // (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
      } catch (e) {
        print(e);
      }
    }

    void listenFCM() async {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'pushnotification',
                'pushnotification',
                icon: 'launch_background',
              ),
            ),
          );
        }
      });
    }

    void loadFCM() async {
      if (!kIsWeb) {
        channel = const AndroidNotificationChannel(
          'pushnotification', // id
          'pushnotification', // title
          importance: Importance.high,
          enableVibration: true,
        );

        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }

    isCurrentUser() async {
      var snapshot = await FirebaseFirestore.instance
          .collection("user").
      doc(FirebaseAuth.instance.currentUser!.uid);
      final userDocSnapshot = await snapshot.get();
      if (userDocSnapshot.exists) {
        return true;
      }
      else {
        return false;
      }
    }

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: Colors.black,
      minimumSize: Size(350, 45),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      backgroundColor: const Color(0xFFB9CAE0),
    );

    @override
    void initState() {
      super.initState();
      requestPermission();
      loadFCM();
      listenFCM();
      saveToken();
      getAddress();

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print("New Notification");
        }
      });

      FirebaseMessaging.onMessage.listen((message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification = message.notification
            ?.android;
        if (notification != null && androidNotification != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  // channel.description,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                  styleInformation: BigTextStyleInformation(notification.body.toString()),
                ),
              )
          );
        }

      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification = message.notification
            ?.android;
        if (notification != null && androidNotification != null) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                    title: Text(notification.title!),
                    content: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification.body!),
                            ]
                        )
                    )
                );
              }
          );
        }

      });

    }
    @override
    Widget build(BuildContext context) {
      return Container(
        color: const Color(0xFFB9CAE0),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                    child: const Text(
                      'How Can Orion Help You?',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    )),

                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(104, 20, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Track(),
                                ));
                          },
                          child: const Text('Track', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(75, 10, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StartRecording(),
                                ));
                          },
                          child: const Text('Record a Video', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckRecordings(),
                                ));
                          },
                          child: const Text(
                            'Check a Recording', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(90, 10, 10, 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GiveAlarm(),
                                ));
                          },

                          child: const Text('Give Alarm', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(67, 10, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpeakerPage(),
                                ));
                          },
                          child: const Text('Provide Message', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(104, 10, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Identify()));
                          },
                          child: const Text('Identify', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 10, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewNotifications(),
                                ));
                          },
                          child: const Text(
                            'View Notifications', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(170, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      )
                    ]
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                      child: ElevatedButton.icon(
                        icon: Icon( // <-- Icon
                          Icons.logout,
                          size: 24.0,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Log Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),

                        ),
                        style: flatButtonStyle,
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection(
                              'government').
                          doc(FirebaseAuth.instance.currentUser!.uid).set(
                              {'Token': null}, SetOptions(merge: true)
                          );
                          FirebaseAuth.instance.signOut();
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
    }

    String location = 'Null, Press Button';
    String Address = 'search';
    String Area = 'search';
    Future<Position> _getGeoLocationPosition() async {
      bool serviceEnabled;
      LocationPermission permission;
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);
    }

    Future<String> GetAddressFromLatLong(Position position) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      Address =
      'Street: ${place.street}, Area: ${place.locality}, Governorate: ${place
          .administrativeArea}, Country: ${place.country}';
      return Address;
    }

    Future<String> GetAreaFromLatLong(Position position) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      Area = '${place.locality}';
      return Area;
    }
  }
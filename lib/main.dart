import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/UserMainPage.dart';
import 'package:untitled2/GovLogin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled2/firebase_config.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:untitled2/services/localNotification.dart';
import 'package:untitled2/services/NotificationService.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

SharedPreferences? _sharedPrefs;
Future<void> backgroundHandler(RemoteMessage message) async{
  // String? title = message.notification!.title;
  // String? body = message.notification!.body;
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ));

  // await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  // print(message.messageId);
  // print(message.data.toString());
  // print(message.notification!.title);
}

// Future<void> foregroundHandler(RemoteMessage message) async{
//   await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
//   print(message.messageId);
//   print(message.data.toString());
//   print(message.notification!.title);
// }

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'pushnotification', // id
  'pushnotification', // title/ description
  importance: Importance.high,
  playSound: true,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: 'AIzaSyA9FTuu2JGDiIBstXJKOxlbpxd_eMwN3Ps',
      appId: '1:989604871715:android:7f085bd1142e800743fb96',
      messagingSenderId: '989604871715',
      projectId: 'csc350orion'));


  await NotificationService.initNotification(flutterLocalNotificationsPlugin, channel);

  FirebaseMessaging.onMessage.listen((message) async{
    await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
    print(message.messageId);
    print(message.data.toString());
    print(message.notification!.title);

    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    if(notification != null && androidNotification != null){
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              styleInformation: BigTextStyleInformation(notification.body.toString()),

            ),
          )
      );
    }
    // if(message.notification != null){
    //   print(message.notification!.title);
    //   print(message.notification!.body);
    // }
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  // NotificationService().initNotification();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: _title,
      // navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: Container(
              width: 200,
              alignment: Alignment.center,
              child: Image.asset('images/Orion.png'),
            ),
            // title: Text(_title,
            //   style: TextStyle(
            //     fontSize: 25,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            backgroundColor: const Color(0xFFB9CAE0),
            elevation: 0.0,
            titleSpacing: 10.0,
            centerTitle: true,
          ),
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late DatabaseReference db;
  // late final localNotification _notification;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("New Notification");
        // final routeFromMessage = message.data["route"];
        // Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
    //   if(message != null){
    //     final routeFromMessage = message.data["route"];
    //     Navigator.of(context).pushNamed(routeFromMessage);
    //   }
    // });

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if(notification != null && androidNotification != null){
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
            ),
          )
        );
      }
      // if(message.notification != null){
      //   print(message.notification!.title);
      //   print(message.notification!.body);
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if(notification != null && androidNotification != null){
        showDialog(
            context: context,
            builder: (_){
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
      // final routeFromMessage = message.data["route"];
      // Navigator.of(context).pushNamed(routeFromMessage);
    });

  }

  @override
  Widget build(BuildContext context) {
    providerConfigs: [
      EmailProviderConfiguration(),
    ];

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
                    padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: const Text(
                      'Select Your Type:',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                Row(
                    children: [
                      Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserMainPage()));
                          },
                          child: const Text('User', style: TextStyle(
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
                      ),
                    ]
                ),
                Row(
                    children:[
                      Padding (padding: const EdgeInsets.fromLTRB(91, 15, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GovLogin()));
                          },
                          child: const Text('Government', style: TextStyle(
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
                      ),
                    ]
                ),
              ],
            )),
    );
  }
}
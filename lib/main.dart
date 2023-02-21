import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:untitled2/UserMainPage.dart';
import 'package:untitled2/GovLogin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled2/firebase_config.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:untitled2/services/localNotification.dart';
import 'package:get/get.dart';


Future<void> backgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print(message.messageId);
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: 'AIzaSyA9FTuu2JGDiIBstXJKOxlbpxd_eMwN3Ps',
      appId: '1:989604871715:android:7f085bd1142e800743fb96',
      messagingSenderId: '989604871715',
      projectId: 'csc350orion'));

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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
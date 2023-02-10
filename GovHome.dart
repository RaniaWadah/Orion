import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/ViewNotifications.dart';
import 'package:untitled2/services/localNotification.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class GovHome extends StatelessWidget {
  const GovHome({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          backgroundColor: const Color(0x6FE8D298),
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
      routes: {
        "View": (_) => ViewNotifications(),
      },
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

  String? mtoken = ' ';

  void requestPermission() async{
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

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission.');
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission.');
    }
    else{
      print('User declined or has not accepted permission.');
    }
  }

  // void getToken() async{
  //   await FirebaseMessaging.instance.getToken().then(
  //       (token){
  //         setState(() {
  //           mtoken = token;
  //         });
  //         saveToken(token!);
  //       }
  //   );
  // }

  // void saveToken(String token) async{
  //
  // }
  //
  // void sendPushMessage(String token, String body, String title) async{
  //   try{
  //     await http.post(
  //       Uri.parse('http://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg
  //         ',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           "priority" : "high",
  //           "data" : <String, dynamic>{
  //             "click-action" : "FLUTTER_NOTIFICATION_CLICK",
  //             "status" : "done",
  //             "body" : body,
  //             "title" : title,
  //           },
  //           "notification" : <String, dynamic>{
  //             "title" : title,
  //             "body" : body,
  //             "android_channel_id" : "easyapproach",
  //           },
  //           "to" : token,
  //     }
  //     )
  //     );
  //   }catch (e){
  //     if(kDebugMode){
  //       print('Error pushing notification');
  //     }
  //   }
  // }
  //
  // void initInfo() async{
  //   await FirebaseFirestore.instance.collection('userTokens').doc('users1').set()
  // }

  void getToken() async{
    try{
      final token = await _firebaseMessaging.getToken();
      FirebaseFirestore.instance.collection('government').
      doc(FirebaseAuth.instance.currentUser!.uid).set(
          {'Token' : token}, SetOptions(merge: true)
      );
    } catch(e){
      print(e.toString());
    }
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black,
    minimumSize: Size(350, 45),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: const Color(0x6FE8D298),
  );

  @override
  void initState(){
    super.initState();
    // localNotification.initialize(_notificationsPlugin);
    // requestPermission();
    getToken();
    // initInfo();

    FirebaseMessaging.instance.getInitialMessage();
    //   if(message != null){
    //     final routeFromMessage = message.data["route"];
    //     Navigator.of(context).pushNamed(routeFromMessage);
    //   }
    // });

    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification!.title);
      }

      // localNotification.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }
  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.signOut();
    return Container(
      color: const Color(0x6FE8D298),
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
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                  child: const Text(
                    'How Can Orion Help You?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Row(
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(75, 30, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Record a Video', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45),
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
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(60, 10, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CheckRecordings()));
                        },
                        child: const Text('Check a Recording', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45),
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
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(90, 10, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Give Alarm', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45),
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
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(67, 10, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Provide Message', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45),
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
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(90, 10, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add Image', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45),
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
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(60, 10, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ViewNotifications()));
                        },
                        child: const Text('View Notifications', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45),
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
                    padding: const EdgeInsets.fromLTRB(20, 30, 10, 10),
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
                      onPressed: () {
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
}
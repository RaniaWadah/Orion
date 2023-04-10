import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled2/UserHome.dart';
import 'package:untitled2/services/localNotification.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:untitled2/services/NotificationService.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class GetHelp extends StatelessWidget {
  const GetHelp({Key? key}) : super(key: key);

  static const String _title = 'Orion';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      home: Scaffold(
        body: const GetHelpWidget(),
      ),
    );
  }
}

class GetHelpWidget extends StatefulWidget {
  const GetHelpWidget({Key? key}) : super(key: key);
  @override
  State<GetHelpWidget> createState() => _GetHelpWidgetState();
}

class _GetHelpWidgetState extends State<GetHelpWidget> {
  // late final FlutterLocalNotificationsPlugin _notificationsPlugin;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // String? token = '';
  String? mtoken = ' ';
  late DatabaseReference db;
  String? _currentAddress;
  Position? _currentPosition;
  late TextEditingController controller;
  Timer? _timer;
  final ValueNotifier<bool> _getHelpState = ValueNotifier<bool>(false);
  Timer? _countdownTimer;
  final ValueNotifier<int> _timeLeft = ValueNotifier<int>(0);
  final firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  int _remainingSeconds = 0;
  Duration _remainingDuration = Duration();

  // List<String> tokens = [
  //   'cH1jckoWToE:APA91bERLybvnYFwyUz4mB5dz2DXoqAygjObRnQjzEZ-klIemoyCwN59hjbXHnB5ryXSdMEaew60sBAsctJ1ELWRmdMLz3l0fpjCKoPZqYzA13zskfm_z8TEG2Zdq0H57N7k3mbutbY3',
  //   'eTMpfXOjQseR4-KNU27S8t:APA91bGRN72GCQj_eUswyc55HOulRPx77zKnvG6w94mGZKr8Qkdtvv7xf5vvDQpSy_qR75tq89y70pZx1gmaQwf6cN79MRFUtVsMzN6NRobhoNBCrvVDYJheD_1KhFdO5wv5-tIfO1s1',
  //   'eIwSH02xQbO8NpKPCPNFOt:APA91bFHwb7gI-1JB4piiL3vxUW_Bad81hQL7ARTAT0yPSuej9eSVJoEgmW5VQ9ufz6qyCjmyaK0M6lwMBCwo5oifSN0E12xNm8jiYJLNRycFeEfKker-xVizerHPJlF0ab1oIPS1n1m'
  // ];
  //
  // String token = 'cH1jckoWToE:APA91bERLybvnYFwyUz4mB5dz2DXoqAygjObRnQjzEZ-klIemoyCwN59hjbXHnB5ryXSdMEaew60sBAsctJ1ELWRmdMLz3l0fpjCKoPZqYzA13zskfm_z8TEG2Zdq0H57N7k3mbutbY3';

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

  // void getToken() async{
  //   await _firebaseMessaging.getToken().then(
  //           (token) {
  //         setState(() {
  //           mtoken = token;
  //           // print(mtoken);
  //         });
  //         saveToken(token!);
  //       }
  //   );
  // }
  //
  // void saveToken(String? token) async{
  //   await FirebaseFirestore.instance.collection('government').
  //   doc(FirebaseAuth.instance.currentUser!.uid).set(
  //       {'Token' : token}, SetOptions(merge: true)
  //   );
  //   await FirebaseFirestore.instance.collection('user').
  //   doc(FirebaseAuth.instance.currentUser!.uid).set(
  //       {'Token' : token}, SetOptions(merge: true)
  //   );
  // }

  // saveToken() async {
  //   token = (await SharedPreferences.getInstance()).getString('token');
  //   print(token);
  // }
  //
  // Future<void> getToken() async {
  //   // await SharedPreferences.getInstance();
  //   final tokenValue = (await SharedPreferences.getInstance()).getString('token');
  //   print(tokenValue.toString());
  //   // return tokenValue.toString();
  // }

  // Future getVal() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = await jsonDecode(prefs.getString('token')!);
  //   return token;
  // }
  //
  // _getSavedToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("token");
  //   print(token);// do something with this
  // }

  // Future<String?> getTokenAndPrint() async {
  //   String? tokenValue = await getToken();
  //   print(tokenValue.toString());
  //   return tokenValue.toString();
  // }

  Future<void> messageHandler() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //
    // });

  }

  // String constructFCMPayload(String token) {
  //   return jsonEncode({
  //     'to': token,
  //     'data': {
  //       'via': 'FlutterFire Cloud Messaging!!!',
  //     },
  //     'notification': {
  //       'title': 'Your item is added successfully !',
  //       'body': 'Please subscribe, like and share this tutorial !',
  //     },
  //   });
  // }
  //
  // Future<void> sendPushMsg(List<String> token, String title,
  //     String body) async {
  //   final userSnapshot = await FirebaseFirestore.instance.collection('user').
  //   doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   print(userSnapshot.data()!['Area'].toString());
  //   try {
  //     String serverKey = "AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg";
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'key=$serverKey'
  //       },
  //       body: jsonEncode({
  //         "registration_ids": token,
  //         'data': {
  //           "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //           'via': 'FlutterFire Cloud Messaging!!!',
  //           'title': title,
  //           'body': body,
  //           'image': '@mipmap/ic_launcher',
  //           'icon': '@mipmap/ic_launcher',
  //         },
  //         'notification': {
  //           'title': title,
  //           'body': body + "\nSent from " +
  //               userSnapshot.data()!['Area'].toString(),
  //           'image': '@mipmap/ic_launcher',
  //           'icon': '@mipmap/ic_launcher',
  //           'sound': 'default',
  //           'alert': 'new',
  //         },
  //       }),
  //     );
  //     print('FCM request for device sent!');
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  // void sendPushMessage(String token, String body, String title) async{
  //
  //   try{
  //     await http.post(
  //       Uri.parse('http://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //         'key=AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg',
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
  //             "id" : 9,
  //             "android_channel_id" : "pushnotification",
  //           },
  //           "to" : token,
  //           "token" : token,
  //     }
  //     )
  //     );
  //     // final getHelpTime = DateTime.now().add(const Duration(seconds: 60));
  //     // (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
  //   }catch (e){
  //     print(e);
  //   }
  // }

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
                + userSnapshot.data()!['Block'].toString() + ".",
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

  void initInfo() async {
    // await FirebaseFirestore.instance.collection('userTokens').doc('users1').set()
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseDatabase.instance.ref().child('userNotifications');
    controller = TextEditingController();
    _init();
    // initInfo();
    // NotificationService.initNotification(_notificationsPlugin, channel);

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     print("New Notification");
    //     // final routeFromMessage = message.data["route"];
    //     // Navigator.of(context).pushNamed(routeFromMessage);
    //   }
    // });
    // //   if(message != null){
    // //     final routeFromMessage = message.data["route"];
    // //     Navigator.of(context).pushNamed(routeFromMessage);
    // //   }
    // // });
    //
    // FirebaseMessaging.onMessage.listen((message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? androidNotification = message.notification?.android;
    //   if (notification != null && androidNotification != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             // channel.description,
    //             playSound: true,
    //             icon: '@mipmap/ic_launcher',
    //           ),
    //         )
    //     );
    //   }
    //   // if(message.notification != null){
    //   //   print(message.notification!.title);
    //   //   print(message.notification!.body);
    //   // }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? androidNotification = message.notification?.android;
    //   if (notification != null && androidNotification != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //               title: Text(notification.title!),
    //               content: SingleChildScrollView(
    //                   child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(notification.body!),
    //                       ]
    //                   )
    //               )
    //           );
    //         }
    //     );
    //   }
    //   // final routeFromMessage = message.data["route"];
    //   // Navigator.of(context).pushNamed(routeFromMessage);
    // });
    // messageHandler();
    // LocalNotificationService.initialize(_notificationsPlugin);
  }

  // Future<void> _init() async {
  //   final getHelpTime = (await SharedPreferences.getInstance()).getInt('get_help_time');
  //   if (getHelpTime != null) {
  //     final duration = getHelpTime - DateTime.now().millisecondsSinceEpoch;
  //     if (duration > 0) {
  //       _timer = Timer(Duration(milliseconds: duration), _handleTimeout);
  //
  //       _remainingDuration = Duration(milliseconds: duration);
  //
  //       // Update remaining duration every second
  //       Timer.periodic(Duration(seconds: 1), (_) {
  //         if (_remainingDuration.inSeconds > 0) {
  //           if(mounted) {
  //             setState(() {
  //               _remainingDuration -= Duration(seconds: 1);
  //             });
  //           }
  //         }
  //       });
  //       return;
  //     }
  //   }
  //   _getHelpState.value = true;
  // }
  //
  // void _handleTimeout() {
  //   _getHelpState.value = true;
  //   _timer?.cancel();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   controller.dispose();
  //   _timer?.cancel();
  // }

  Future _init() async {
    final getHelpTime =
    (await SharedPreferences.getInstance()).getInt('get_help_time');
    if (getHelpTime != null) {
      final duration = getHelpTime - DateTime
          .now()
          .millisecondsSinceEpoch;
      if (duration > 0) {
        _timeLeft.value = duration;
        _timer = Timer(Duration(milliseconds: duration), _handleTimeout);
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _timeLeft.value = _timeLeft.value - 1000;
        });
        return;
      }
    }

    _getHelpState.value = true;
  }

  void _handleTimeout() {
    _getHelpState.value = true;
    _timer?.cancel();
    _countdownTimer?.cancel();
  }

  String _getButtonLabel(bool enabled, int timeLeft) {
    if (enabled) {
      return 'Send';
    }

    if (timeLeft <= 0) {
      return '00 : 00';
    }

    if (timeLeft <= 1000) {
      return '00 : 01';
    }

    final minute = ((timeLeft / 1000) ~/ 60).toString().padLeft(2, '0');
    final second = (((timeLeft / 1000) % 60).toInt()).toString().padLeft(
        2, '0');
    return '$minute : $second';
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _timer?.cancel();
    _countdownTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB9CAE0),
      child: Scaffold(
        backgroundColor: const Color(0xFFB9CAE0),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 25),
                    child: const Text(
                      'Get Help',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB9CAE0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color(0x3B1D2429),
                            offset: Offset(0, -3),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 50),
                                      child: ValueListenableBuilder(
                                          valueListenable: _getHelpState,
                                          builder: (context, value, child) {
                                            if (value != true) {
                                              return Text(
                                                'You can send another help request after 10 minutes',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontFamily: 'Poppings',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            }
                                            else {
                                              return Text(
                                                'Are you sure you want to send help request?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontFamily: 'Poppings',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            }
                                          }
                                      )
                                  ),
                                )
                              ],
                            ),
                            Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional
                                        .fromSTEB(0, 16, 10, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(
                                            builder: (context) => UserHome()));
                                      },
                                      child: const Text(
                                        'Cancel', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.grey,
                                          minimumSize: Size(170, 45),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20),
                                          )
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsetsDirectional
                                      .fromSTEB(0, 16, 0, 0),
                                    child: ValueListenableBuilder(
                                      valueListenable: _getHelpState,
                                      builder: (context, value, child) {
                                        return ElevatedButton(
                                          onPressed: value != true
                                              ? () {}
                                              : () async {
                                            final userSnapshot = await FirebaseFirestore
                                                .instance.collection('user').
                                            doc(FirebaseAuth.instance
                                                .currentUser!.uid).get();
                                            String userToken = userSnapshot
                                                .data()!['Token'];

                                            QuerySnapshot snapshot = await FirebaseFirestore
                                                .instance.collection(
                                                'government')
                                                .where(
                                                'Token', isNotEqualTo: null)
                                                .get();
                                            List<
                                                DocumentSnapshot> docsList = snapshot
                                                .docs;
                                            List<String> tokenList = [];

                                            docsList.forEach((doc) {
                                              dynamic data = doc.data();
                                              String? token = data['Token']
                                                  ?.toString();
                                              if (token != null) {
                                                if (token != userToken) {
                                                  tokenList.add(token);
                                                }
                                              }
                                            });

                                            print(tokenList.toString());

                                            final body = "Get Help Request.";
                                            final title = "Get Help";
                                            print(body);

                                            Map<String,
                                                dynamic> Notifications = {
                                              'Title': title,
                                              'Description': body,
                                              'Sender Civil ID': userSnapshot
                                                  .data()!['Civil ID'],
                                              'Sender Device Token': userSnapshot
                                                  .data()!['Token'],
                                              'Date and Time': DateTime.now()
                                                  .toString(),
                                              'Location': userSnapshot
                                                  .data()!['Location'],
                                              'Area': userSnapshot
                                                  .data()!['Area'],
                                              'Block': userSnapshot
                                                  .data()!['Block'],
                                            };
                                            db.push().set(Notifications);

                                            CollectionReference userRef = FirebaseFirestore
                                                .instance.collection(
                                                'userNotifications');
                                            userRef.doc()
                                                .set({
                                              'Title': title,
                                              'Description': body,
                                              'Sender Civil ID': userSnapshot.data()!['Civil ID'],
                                              'Sender Device Token': userSnapshot.data()!['Token'],
                                              'Date and Time': DateTime.now().toString(),
                                              'Location': userSnapshot.data()!['Location'],
                                              'Area': userSnapshot.data()!['Area'],
                                              'Block': userSnapshot.data()!['Block'],
                                            })
                                                .then((value) =>
                                                print("Notification Added"))
                                                .catchError((error) =>
                                                print(
                                                    "Failed to add notification: $error"));
                                            await sendPushMsg(
                                                tokenList, title, body);

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        'Your request has been successfully sent'),
                                                  );
                                                }
                                            );

                                            final getHelpTime = DateTime.now()
                                                .add(
                                                const Duration(minutes: 10));
                                            (await SharedPreferences
                                                .getInstance()).setInt(
                                                'get_help_time', getHelpTime
                                                .millisecondsSinceEpoch);

                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(
                                                builder: (context) =>
                                                    UserHome()));
                                          },
                                          child:
                                          // Text("send"),
                                          ValueListenableBuilder<int>(
                                              valueListenable: _timeLeft,
                                              builder:
                                                  (context, timeLeft, child) {
                                                return Text(
                                                  _getButtonLabel(
                                                      value == true, timeLeft),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }),
                                          style: ElevatedButton.styleFrom(
                                              primary: value == true
                                                  ? const Color(
                                                  0xff02165c)
                                                  : const Color(
                                                  0xff91b2de),
                                              minimumSize: Size(170, 45),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(20),
                                              )
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ],
            )),

      ),
    );
  }

  // String location = 'Null, Press Button';
  // String Address = 'search';
  // String Area = 'search';
  //
  // Future<Position> _getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best,
  //       forceAndroidLocationManager: true);
  // }
  //
  // Future<String> GetAddressFromLatLong(Position position) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   Address =
  //   'Street: ${place.street}, Area: ${place.locality}, Governorate: ${place
  //       .administrativeArea} Country: ${place.country}';
  //   return Address;
  // }
  //
  // Future<String> GetAreaFromLatLong(Position position) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   Area = 'Area: ${place.locality}';
  //   return Area;
  // }
}

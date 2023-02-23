import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  String? mtoken = ' ';
  late DatabaseReference db;
  String? _currentAddress;
  Position? _currentPosition;
  late TextEditingController controller;
  Timer? _timer;
  final ValueNotifier<bool> _getHelpState = ValueNotifier<bool>(false);
  final firestore = FirebaseFirestore.instance;

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

  //
  void sendPushMessage(String body, String title) async{
    final getHelpTime = DateTime.now().add(const Duration(minutes: 10));
    (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
    try{
      await http.post(
        Uri.parse('http://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA5mkL_iM:APA91bGr7zS4Zx5IwwGrK0H9otabN8EKJr-pHxmgq2_ptDN1uINDTsOxsQDLSeZURLOFYu8fpAZy47TfKG5Rp-BGvbzXkC-jStzwmy45DRhf4dQdfIRAru--jcWL5kcTMjvvOOlul_pg',
        },
        body: jsonEncode(
          <String, dynamic>{
            "priority" : "high",
            "data" : <String, dynamic>{
              "click-action" : "FLUTTER_NOTIFICATION_CLICK",
              "status" : "done",
              "body" : body,
              "title" : title,
            },
            "notification" : <String, dynamic>{
              "title" : title,
              "body" : body,
              "android_channel_id" : "pushnotification",
            },
            "to" : '',
      }
      )
      );
    }catch (e){
      print(e);
    }
  }

  isCurrentUser() async{
    var snapshot = await FirebaseFirestore.instance
        .collection("user").
    doc(FirebaseAuth.instance.currentUser!.uid);
    final userDocSnapshot = await snapshot.get();
    if(userDocSnapshot.exists){
      return true;
    }
    else{
      return false;
    }
  }

  // void initInfo() async{
  //   await FirebaseFirestore.instance.collection('userTokens').doc('users1').set()
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseDatabase.instance.ref().child('Notifications');
    controller = TextEditingController();
    _init();
  }

  Future _init() async {
    final getHelpTime = (await SharedPreferences.getInstance()).getInt('get_help_time');
    if (getHelpTime != null) {
      final duration = getHelpTime - DateTime.now().millisecondsSinceEpoch;
      if (duration > 0) {
        _timer = Timer(Duration(milliseconds: duration), _handleTimeout);
        return;
      }
    }

    _getHelpState.value = true;
  }

  void _handleTimeout() {
    _getHelpState.value = true;
    _timer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB9CAE0),
      child: Scaffold(
        backgroundColor: const Color(0xFFB9CAE0),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 60, 10, 20),
                    child: const Text(
                      'Get Help',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                                      child: Text(
                                        'Are you sure you want to send help request?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Poppings',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                  children:[
                                    Padding (
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 10, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => UserHome()));
                                        },
                                        child: const Text('Cancel', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                        style: ElevatedButton.styleFrom(primary: Colors.grey,
                                            minimumSize: Size(170, 45),
                                            padding: EdgeInsets.symmetric(horizontal: 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            )
                                        ),
                                      ),
                                    ),
                                    Padding (padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                      child: ValueListenableBuilder(
                                        valueListenable: _getHelpState,
                                        builder: (context, value, child) {
                                          return ElevatedButton(
                                            onPressed: value != true ? () {} : () async {
                                              // DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('government').
                                              // doc(FirebaseAuth.instance.currentUser!.uid).get();
                                              // String token = snapshot['Token'];
                                              // print(token);
                                              final body = "Get Help Request";
                                              final title = "Get Help";
                                              print(body);

                                              sendPushMessage(body, title);

                                              Position position = await _getGeoLocationPosition();
                                              location = 'Lat: ${position.latitude} , Long: ${position.longitude}';

                                              String address = await GetAddressFromLatLong(position);

                                              final snap = await FirebaseFirestore.instance.collection('user').
                                              doc(FirebaseAuth.instance.currentUser!.uid).get();

                                              Map<String, dynamic> Notifications = {
                                                'Title': title,
                                                'Description': body,
                                                'Sender Civil ID': snap.data()!['Civil ID'],
                                                'Date and Time': DateTime.now().toString(),
                                                'Location': address.toString(),
                                              };
                                              db.push().set(Notifications);

                                              CollectionReference userRef = FirebaseFirestore.instance.collection(
                                                  'Notifications');
                                              userRef.doc()
                                                  .set({
                                                'Title': title,
                                                'Description': body,
                                                'Sender Civil ID': snap.data()!['Civil ID'],
                                                'Date and Time': DateTime.now().toString(),
                                                'Location': address.toString(),
                                              })
                                                  .then((value) => print("Notification Added"))
                                                  .catchError((error) =>
                                                  print("Failed to add notification: $error"));

                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Text('Your request has been successfully sent'),
                                                    );
                                                  }
                                              );
                                              Navigator.pushReplacement(context, MaterialPageRoute(
                                                  builder: (context) => UserHome()));

                                            },
                                            child: const Text('Send', style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: value == true ? const Color(
                                                    0xff02165c) : const Color(
                                                    0xff91b2de), minimumSize: Size(170, 45),
                                                padding: EdgeInsets.symmetric(horizontal: 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
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
                    )
                )

              ],
            )),

      ),
    );

  }

  String location ='Null, Press Button';
  String Address = 'search';
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
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true);
  }

  Future<String> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = 'Street: ${place.street}, Area: ${place.locality}, Governorate: ${place.administrativeArea} Country: ${place.country}';
    return Address;
  }

}


// import 'package:flutter/material.dart';
// import 'package:untitled2/UserHome.dart';
// import 'package:untitled2/services/firestore_service.dart';
// import 'package:untitled2/services/localNotification.dart';
// import 'package:untitled2/services/location_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'utils/utils.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
//
// class GetHelp extends StatelessWidget {
//   const GetHelp({Key? key}) : super(key: key);
//
//   static const String _title = 'Orion';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // navigatorKey: navigatorKey,
//       home: Scaffold(
//         body: const GetHelpWidget(),
//       ),
//     );
//   }
// }
//
// class GetHelpWidget extends StatefulWidget {
//   const GetHelpWidget({Key? key}) : super(key: key);
//
//   @override
//   State<GetHelpWidget> createState() => _GetHelpWidgetState();
// }
//
// class _GetHelpWidgetState extends State<GetHelpWidget> {
//   late final localNotification _notificationsPlugin;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _notificationsPlugin = localNotification();
//     _notificationsPlugin.initialize();
//     // localNotification.initialize(_notificationsPlugin);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // FirebaseAuth.instance.signOut();
//     return Container(
//       color: const Color(0x6FE8D298),
//       child: Scaffold(
//         body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.all(10),
//                 ),
//                 Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.fromLTRB(10, 75, 10, 20),
//                     child: const Text(
//                       'Get Help',
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     )),
//                 Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
//                     child: Container(
//                         width: double.infinity,
//                         height: 240,
//                         decoration: BoxDecoration(
//                           color: const Color(0x6FE8D298),
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 5,
//                               color: Color(0x3B1D2429),
//                               offset: Offset(0, -3),
//                             )
//                           ],
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(0),
//                             bottomRight: Radius.circular(0),
//                             topLeft: Radius.circular(16),
//                             topRight: Radius.circular(16),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Flexible(
//                                     child: Padding(
//                                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
//                                       child: Text(
//                                         'Are you sure you want to send help request?',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 20,
//                                           fontFamily: 'Poppings',
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Row(children: [
//                                 Padding(
//                                   padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                                   child: ElevatedButton(
//                                     onPressed: _send,
//                                     child: const Text(
//                                       'Send',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     style: ElevatedButton.styleFrom(
//                                         primary: const Color(0xA121732E),
//                                         minimumSize: Size(170, 45),
//                                         padding: EdgeInsets.symmetric(horizontal: 50),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(20),
//                                         )),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                                   child: ElevatedButton(
//                                     onPressed: () async {
//                                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome()));
//                                     },
//                                     child: const Text(
//                                       'Cancel',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     style: ElevatedButton.styleFrom(
//                                         primary: const Color(0x9D151515),
//                                         minimumSize: Size(170, 45),
//                                         padding: EdgeInsets.symmetric(horizontal: 50),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(20),
//                                         )),
//                                   ),
//                                 )
//                               ]),
//                             ],
//                           ),
//                         )))
//               ],
//             )),
//       ),
//     );
//   }
//
//   void _send() async {
//     // You can move this code to the right place
//     // You are able to change the time on below line, currently 5 minutes
//     final getHelpTime = DateTime.now().add(const Duration(minutes: 5));
//     (await SharedPreferences.getInstance()).setInt('get_help_time', getHelpTime.millisecondsSinceEpoch);
//     if (await LocationService().checkAndRequestPermissionWithDialog(context)) {
//       Utils.showLoader(context: context);
//       final position = await LocationService().determinePosition();
//       await FirestoreService.instance.saveLocation(latitude: position.latitude, longitude: position.longitude);
//       Utils.showLoader(context: context, isShow: false);
//       _openSuccessDialog();
//     }
//   }
//
//   void _openSuccessDialog() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('Your request has been successfully sent.'),
//           );
//         });
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome()));
//     _notificationsPlugin.showNotification(id: 0, title: 'Get Help', body: 'Get Help Message Sent');
//   }
// }

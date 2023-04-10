// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:firebase_messaging/firebase_messaging.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:untitled2/EditProfile.dart';
// // // // import 'package:untitled2/Profile/Profile.dart';
// // // // import 'package:untitled2/GetHelp.dart';
// // // // import 'package:http/http.dart';
// // // // import 'package:untitled2/UserLogin.dart';
// // // // import 'package:untitled2/ReportAProblem.dart';
// // // //
// // // //
// // // // class UserHome extends StatelessWidget {
// // // //   const UserHome({Key? key}) : super(key: key);
// // // //
// // // //   static const String _title = 'Orion';
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       home: Scaffold(
// // // //           resizeToAvoidBottomInset: false,
// // // //         backgroundColor: const Color(0xFFB9CAE0),
// // // //         body: const UserHomeWidget(),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // class UserHomeWidget extends StatefulWidget {
// // // //   const UserHomeWidget({Key? key}) : super(key: key);
// // // //   @override
// // // //   State<UserHomeWidget> createState() => _UserHomeWidgetState();
// // // // }
// // // //
// // // // class _UserHomeWidgetState extends State<UserHomeWidget> {
// // // //
// // // //   final ButtonStyle flatButtonStyle = TextButton.styleFrom(
// // // //     primary: Colors.black,
// // // //     minimumSize: Size(350, 45),
// // // //     padding: EdgeInsets.symmetric(horizontal: 16.0),
// // // //     shape: const RoundedRectangleBorder(
// // // //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
// // // //     ),
// // // //     backgroundColor: const Color(0xFFB9CAE0),
// // // //   );
// // // //
// // // //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// // // //
// // // //   void getToken() async{
// // // //     try{
// // // //       final token = await _firebaseMessaging.getToken();
// // // //       FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).set(
// // // //           {'Token' : token}, SetOptions(merge: true)
// // // //       );
// // // //     } catch(e){
// // // //       print(e.toString());
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     // TODO: implement initState
// // // //     super.initState();
// // // //     getToken();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Container(
// // // //       color: const Color(0xFFB9CAE0),
// // // //       child: Scaffold(
// // // //         backgroundColor: const Color(0xFFB9CAE0),
// // // //         resizeToAvoidBottomInset: false,
// // // //         body: Padding(
// // // //             padding: const EdgeInsets.all(10),
// // // //             child: ListView(
// // // //               children: <Widget>[
// // // //                 Container(
// // // //                   alignment: Alignment.center,
// // // //                   padding: const EdgeInsets.all(10),
// // // //                 ),
// // // //                 Container(
// // // //                     alignment: Alignment.center,
// // // //                     padding: const EdgeInsets.fromLTRB(10, 65, 10, 10),
// // // //                     child: const Text(
// // // //                       'How Can Orion Help You?',
// // // //                       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // //                     )),
// // // //                 SingleChildScrollView(
// // // //                   child: Row(
// // // //                       children:[
// // // //                         Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
// // // //                           child: ElevatedButton(
// // // //                             onPressed: () {
// // // //                               Navigator.pushReplacement(context, MaterialPageRoute(
// // // //                                   builder: (context) => GetHelp()));
// // // //                             },
// // // //                             child: const Text('Get Help', style: TextStyle(
// // // //                               color: Colors.white,
// // // //                               fontSize: 20,
// // // //                               fontWeight: FontWeight.bold,
// // // //                             ),
// // // //                             ),
// // // //                             style: ElevatedButton.styleFrom(primary: const Color(
// // // //                                 0xff02165c), minimumSize: Size(170, 45),
// // // //                                 padding: EdgeInsets.symmetric(horizontal: 50),
// // // //                                 shape: RoundedRectangleBorder(
// // // //                                   borderRadius: BorderRadius.circular(20),
// // // //                                 )
// // // //                             ),
// // // //                           ),
// // // //                         )
// // // //                       ]
// // // //                   ),
// // // //
// // // //                 ),
// // // //                 SingleChildScrollView(
// // // //                   child: Row(
// // // //                       children:[
// // // //                         Padding (padding: const EdgeInsets.fromLTRB(72, 15, 10, 10),
// // // //                           child: ElevatedButton(
// // // //                             onPressed: () {
// // // //                               // Navigator.pushReplacement(context, MaterialPageRoute(
// // // //                               //     builder: (context) => ReportAProblem()));
// // // //                             },
// // // //                             child: const Text('Report a Problem', style: TextStyle(
// // // //                               color: Colors.white,
// // // //                               fontSize: 20,
// // // //                               fontWeight: FontWeight. bold,
// // // //                             ),
// // // //                             ),
// // // //                             style: ElevatedButton.styleFrom(primary: const Color(
// // // //                                 0xff02165c), minimumSize: Size(170, 45),
// // // //                                 padding: EdgeInsets.symmetric(horizontal: 50),
// // // //                                 shape: RoundedRectangleBorder(
// // // //                                   borderRadius: BorderRadius.circular(20),
// // // //                                 )
// // // //                             ),
// // // //                           ),
// // // //                         )
// // // //                       ]
// // // //                   ),
// // // //                 ),
// // // //                 SingleChildScrollView(
// // // //                   child: Row(
// // // //                     children: [
// // // //                       Padding(
// // // //                         padding: const EdgeInsets.fromLTRB(20, 110, 10, 10),
// // // //                         child: ElevatedButton.icon(
// // // //                           icon: Icon( // <-- Icon
// // // //                             Icons.logout,
// // // //                             size: 24.0,
// // // //                             color: Colors.black,
// // // //                           ),
// // // //                           label: Text(
// // // //                             'Log Out',
// // // //                             style: TextStyle(
// // // //                               fontWeight: FontWeight.bold,
// // // //                               fontSize: 20,
// // // //                             ),
// // // //
// // // //                           ),
// // // //                           style: flatButtonStyle,
// // // //                           onPressed: () {
// // // //                             FirebaseAuth.instance.signOut();
// // // //                             onPressed: () {
// // // //                               Navigator.push(
// // // //                                   context,
// // // //                                   MaterialPageRoute(
// // // //                                       builder: (context) => UserLogin()));
// // // //                             };
// // // //                           },
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 )
// // // //
// // // //                 // Padding(
// // // //                 //     padding: const EdgeInsets.fromLTRB(10, 175, 0, 0),
// // // //                 //   child: Row(
// // // //                 //     mainAxisSize:MainAxisSize.min,
// // // //                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 //     children: [
// // // //                 //       Container(
// // // //                 //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
// // // //                 //         child: ElevatedButton(
// // // //                 //           onPressed:() {
// // // //                 //             Navigator.pushReplacement(context, MaterialPageRoute(
// // // //                 //                 builder: (context) => EditProfile()));
// // // //                 //           },
// // // //                 //           style: ElevatedButton.styleFrom(
// // // //                 //               primary: Colors.indigo,
// // // //                 //               padding: EdgeInsets.symmetric(horizontal: 50),
// // // //                 //               shape: RoundedRectangleBorder(
// // // //                 //                 borderRadius: BorderRadius.circular(20),
// // // //                 //               )
// // // //                 //           ), // <-- Text
// // // //                 //           child: Container(
// // // //                 //             width: 70,
// // // //                 //             height: 60,
// // // //                 //             child: Column(
// // // //                 //               mainAxisAlignment: MainAxisAlignment.center,
// // // //                 //               children: [
// // // //                 //                 Text("Edit Profile",
// // // //                 //                   style: TextStyle(
// // // //                 //                     fontWeight: FontWeight.bold,
// // // //                 //                   ),
// // // //                 //                 ),
// // // //                 //                 Icon(
// // // //                 //                   Icons.edit,
// // // //                 //                   size: 25.0,
// // // //                 //                   color: Colors.white,
// // // //                 //                 )
// // // //                 //               ],
// // // //                 //             ),
// // // //                 //           ),
// // // //                 //
// // // //                 //         ),
// // // //                 //       ),
// // // //                 //       // Container(
// // // //                 //       //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
// // // //                 //       //   child: ElevatedButton(
// // // //                 //       //     onPressed:() {
// // // //                 //       //       FirebaseAuth.instance.signOut();
// // // //                 //       //     },
// // // //                 //       //     style: ElevatedButton.styleFrom(
// // // //                 //       //         primary: Colors.indigo,
// // // //                 //       //         padding: EdgeInsets.symmetric(horizontal: 50),
// // // //                 //       //         shape: RoundedRectangleBorder(
// // // //                 //       //           borderRadius: BorderRadius.circular(20),
// // // //                 //       //         )
// // // //                 //       //     ), // <-- Text
// // // //                 //           // child: Container(
// // // //                 //           //   width: 70,
// // // //                 //           //   height: 60,
// // // //                 //           //   child: Column(
// // // //                 //           //     mainAxisAlignment: MainAxisAlignment.center,
// // // //                 //           //     children: [
// // // //                 //           //       Text("Log Out",
// // // //                 //           //         style: TextStyle(
// // // //                 //           //           fontWeight: FontWeight.bold,
// // // //                 //           //         ),
// // // //                 //           //       ),
// // // //                 //           //       Icon(
// // // //                 //           //         Icons.logout_sharp,
// // // //                 //           //         size: 25.0,
// // // //                 //           //         color: Colors.white,
// // // //                 //           //       )
// // // //                 //           //
// // // //                 //           //     ],
// // // //                 //           //   ),
// // // //                 //           // ),
// // // //                 //         // ),
// // // //                 //       // )
// // // //                 //     ],
// // // //                 //   ),
// // // //                 // ),
// // // //               ],
// // // //
// // // //             )
// // // //         ),
// // // //       ),
// // // //     );
// // // //
// // // //   }
// // // // }
// // //
// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:firebase_messaging/firebase_messaging.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// // // import 'package:geocoding/geocoding.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:untitled2/EditProfile.dart';
// // // import 'package:untitled2/Profile/Profile.dart';
// // // import 'package:untitled2/GetHelp.dart';
// // // import 'package:http/http.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:untitled2/ReportProblem.dart';
// // // import 'package:untitled2/services/NotificationService.dart';
// // //
// // //
// // // class Screen extends StatelessWidget {
// // //   const Screen({Key? key}) : super(key: key);
// // //
// // //   static const String _title = 'Orion';
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       home: Scaffold(
// // //         resizeToAvoidBottomInset: false,
// // //         body: const ScreenWidget(),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class ScreenWidget extends StatefulWidget {
// // //   const ScreenWidget({Key? key}) : super(key: key);
// // //   @override
// // //   State<ScreenWidget> createState() => _ScreenWidgetState();
// // // }
// // //
// // // class _ScreenWidgetState extends State<ScreenWidget> {
// // //   final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
// // //   final List<BluetoothDevice> _devicesList = [];
// // //
// // //   void _addDeviceTolist(BluetoothDevice device) {
// // //     if (!_devicesList.contains(device)) {
// // //       setState(() {
// // //         _devicesList.add(device);
// // //       });
// // //     }
// // //   }
// // //
// // //   Future initBleList() async {
// // //     await Permission.bluetooth.request();
// // //     await Permission.bluetoothConnect.request();
// // //     await Permission.bluetoothScan.request();
// // //     await Permission.bluetoothAdvertise.request();
// // //     flutterBlue.connectedDevices.asStream().listen((devices) {
// // //       for (var device in devices) {
// // //         _addDeviceTolist(device);
// // //       }
// // //     });
// // //     flutterBlue.scanResults.listen((scanResults) {
// // //       for (var result in scanResults) {
// // //         _addDeviceTolist(result.device);
// // //       }
// // //     });
// // //     flutterBlue.startScan();
// // //   }
// // //
// // //   ListView _buildListViewOfDevices() {
// // //     List<Widget> containers = [];
// // //     for (BluetoothDevice device in _devicesList.where((element) => element.name.isNotEmpty)) {
// // //       containers.add(
// // //         SizedBox(
// // //           height: 60,
// // //           child: Row(
// // //             children: <Widget>[
// // //               Expanded(child: Column(children: <Widget>[Text(device.name), Text(device.id.toString())])),
// // //               ElevatedButton(
// // //                 child: const Text('Connect', style: TextStyle(color: Colors.white)),
// // //                 onPressed: () async {},
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       );
// // //     }
// // //     return ListView(padding: const EdgeInsets.all(8), children: <Widget>[...containers]);
// // //   }
// // //
// // //   @override
// // //   void initState() {
// // //     // TODO: implement initState
// // //     super.initState();
// // //     initBleList();
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // FirebaseAuth.instance.signOut();
// // //     return Container(
// // //       // color: const Color(0xFFB9CAE0),
// // //       // child: Scaffold(
// // //       //   backgroundColor: const Color(0xFFB9CAE0),
// // //       //   resizeToAvoidBottomInset: false,
// // //       //   body: Padding(
// // //       //       padding: const EdgeInsets.all(10),
// // //       //       child: ListView(
// // //       //         children: <Widget>[
// // //       //           Container(
// // //       //             alignment: Alignment.center,
// // //       //             padding: const EdgeInsets.all(10),
// // //       //           ),
// // //       //           Container(
// // //       //               alignment: Alignment.center,
// // //       //               padding: const EdgeInsets.fromLTRB(10, 65, 10, 10),
// // //       //               child: const Text(
// // //       //                 'How Can Orion Help You?',
// // //       //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // //       //               )),
// // //       //           SingleChildScrollView(
// // //       //             child: Row(
// // //       //                 children:[
// // //       //                   Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
// // //       //                     child: ElevatedButton(
// // //       //                       onPressed: () async{
// // //       //                         Navigator.pushReplacement(context, MaterialPageRoute(
// // //       //                             builder: (context) => GetHelp()));
// // //       //                       },
// // //       //                       child: const Text('Get Help', style: TextStyle(
// // //       //                         color: Colors.white,
// // //       //                         fontSize: 20,
// // //       //                         fontWeight: FontWeight.bold,
// // //       //                       ),
// // //       //                       ),
// // //       //                       style: ElevatedButton.styleFrom(primary: const Color(
// // //       //                           0xff02165c), minimumSize: Size(170, 45),
// // //       //                           padding: EdgeInsets.symmetric(horizontal: 50),
// // //       //                           shape: RoundedRectangleBorder(
// // //       //                             borderRadius: BorderRadius.circular(20),
// // //       //                           )
// // //       //                       ),
// // //       //                     ),
// // //       //                   )
// // //       //                 ]
// // //       //             ),
// // //       //
// // //       //           ),
// // //       //           SingleChildScrollView(
// // //       //             child: Row(
// // //       //                 children:[
// // //       //                   Padding (padding: const EdgeInsets.fromLTRB(72, 15, 10, 10),
// // //       //                     child: ElevatedButton(
// // //       //                       onPressed: () {
// // //       //                         Navigator.pushReplacement(context, MaterialPageRoute(
// // //       //                             builder: (context) => ReportAProblem()));
// // //       //                       },
// // //       //                       child: const Text('Report a Problem', style: TextStyle(
// // //       //                         color: Colors.white,
// // //       //                         fontSize: 20,
// // //       //                         fontWeight: FontWeight. bold,
// // //       //                       ),
// // //       //                       ),
// // //       //                       style: ElevatedButton.styleFrom(primary: const Color(
// // //       //                           0xff02165c), minimumSize: Size(170, 45),
// // //       //                           padding: EdgeInsets.symmetric(horizontal: 50),
// // //       //                           shape: RoundedRectangleBorder(
// // //       //                             borderRadius: BorderRadius.circular(20),
// // //       //                           )
// // //       //                       ),
// // //       //                     ),
// // //       //                   )
// // //       //                 ]
// // //       //             ),
// // //       //           ),
// // //       //           SingleChildScrollView(
// // //       //             child: Row(
// // //       //               children: [
// // //       //                 Padding(
// // //       //                   padding: const EdgeInsets.fromLTRB(20, 110, 10, 10),
// // //       //                   child: ElevatedButton.icon(
// // //       //                     icon: Icon( // <-- Icon
// // //       //                       Icons.logout,
// // //       //                       size: 24.0,
// // //       //                       color: Colors.black,
// // //       //                     ),
// // //       //                     label: Text(
// // //       //                       'Log Out',
// // //       //                       style: TextStyle(
// // //       //                         fontWeight: FontWeight.bold,
// // //       //                         fontSize: 20,
// // //       //                       ),
// // //       //
// // //       //                     ),
// // //       //                     style: flatButtonStyle,
// // //       //                     onPressed: () {
// // //       //                       FirebaseAuth.instance.signOut();
// // //       //                     },
// // //       //                   ),
// // //       //                 ),
// // //       //               ],
// // //       //             ),
// // //       //           )
// // //       //
// // //       //           // Padding(
// // //       //           //     padding: const EdgeInsets.fromLTRB(10, 175, 0, 0),
// // //       //           //   child: Row(
// // //       //           //     mainAxisSize:MainAxisSize.min,
// // //       //           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //       //           //     children: [
// // //       //           //       Container(
// // //       //           //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
// // //       //           //         child: ElevatedButton(
// // //       //           //           onPressed:() {
// // //       //           //             Navigator.pushReplacement(context, MaterialPageRoute(
// // //       //           //                 builder: (context) => EditProfile()));
// // //       //           //           },
// // //       //           //           style: ElevatedButton.styleFrom(
// // //       //           //               primary: Colors.indigo,
// // //       //           //               padding: EdgeInsets.symmetric(horizontal: 50),
// // //       //           //               shape: RoundedRectangleBorder(
// // //       //           //                 borderRadius: BorderRadius.circular(20),
// // //       //           //               )
// // //       //           //           ), // <-- Text
// // //       //           //           child: Container(
// // //       //           //             width: 70,
// // //       //           //             height: 60,
// // //       //           //             child: Column(
// // //       //           //               mainAxisAlignment: MainAxisAlignment.center,
// // //       //           //               children: [
// // //       //           //                 Text("Edit Profile",
// // //       //           //                   style: TextStyle(
// // //       //           //                     fontWeight: FontWeight.bold,
// // //       //           //                   ),
// // //       //           //                 ),
// // //       //           //                 Icon(
// // //       //           //                   Icons.edit,
// // //       //           //                   size: 25.0,
// // //       //           //                   color: Colors.white,
// // //       //           //                 )
// // //       //           //               ],
// // //       //           //             ),
// // //       //           //           ),
// // //       //           //
// // //       //           //         ),
// // //       //           //       ),
// // //       //           //       // Container(
// // //       //           //       //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
// // //       //           //       //   child: ElevatedButton(
// // //       //           //       //     onPressed:() {
// // //       //           //       //       FirebaseAuth.instance.signOut();
// // //       //           //       //     },
// // //       //           //       //     style: ElevatedButton.styleFrom(
// // //       //           //       //         primary: Colors.indigo,
// // //       //           //       //         padding: EdgeInsets.symmetric(horizontal: 50),
// // //       //           //       //         shape: RoundedRectangleBorder(
// // //       //           //       //           borderRadius: BorderRadius.circular(20),
// // //       //           //       //         )
// // //       //           //       //     ), // <-- Text
// // //       //           //           // child: Container(
// // //       //           //           //   width: 70,
// // //       //           //           //   height: 60,
// // //       //           //           //   child: Column(
// // //       //           //           //     mainAxisAlignment: MainAxisAlignment.center,
// // //       //           //           //     children: [
// // //       //           //           //       Text("Log Out",
// // //       //           //           //         style: TextStyle(
// // //       //           //           //           fontWeight: FontWeight.bold,
// // //       //           //           //         ),
// // //       //           //           //       ),
// // //       //           //           //       Icon(
// // //       //           //           //         Icons.logout_sharp,
// // //       //           //           //         size: 25.0,
// // //       //           //           //         color: Colors.white,
// // //       //           //           //       )
// // //       //           //           //
// // //       //           //           //     ],
// // //       //           //           //   ),
// // //       //           //           // ),
// // //       //           //         // ),
// // //       //           //       // )
// // //       //           //     ],
// // //       //           //   ),
// // //       //           // ),
// // //       //         ],
// // //       //
// // //       //       )
// // //       //   ),
// // //       // ),
// // //     );
// // //
// // //   }
// // // }
// //
// // import 'dart:io';
// //
// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// //
// // class Screen extends StatelessWidget{
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Home(),
// //     );
// //   }
// // }
// //
// //
// // class Home extends StatefulWidget{
// //   @override
// //   _HomeState createState() => _HomeState();
// // }
// //
// // class _HomeState extends State<Home> {
// //
// //   List<CameraDescription>? cameras; //list out the camera available
// //   CameraController? controller; //controller for camera
// //   XFile? image; //for caputred image
// //
// //   @override
// //   void initState() {
// //     loadCamera();
// //     super.initState();
// //   }
// //
// //   loadCamera() async {
// //     cameras = await availableCameras();
// //     if(cameras != null){
// //       controller = CameraController(cameras![0], ResolutionPreset.max);
// //       //cameras[0] = first camera, change to 1 to another camera
// //
// //       controller!.initialize().then((_) {
// //         if (!mounted) {
// //           return;
// //         }
// //         setState(() {});
// //       });
// //     }else{
// //       print("NO any camera found");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return  Scaffold(
// //       appBar: AppBar(
// //         title: Text("Live Camera Preview"),
// //         backgroundColor: Colors.redAccent,
// //       ),
// //       body: Container(
// //           child: Column(
// //               children:[
// //                 Container(
// //                     height:300,
// //                     width:400,
// //                     child: controller == null?
// //                     Center(child:Text("Loading Camera...")):
// //                     !controller!.value.isInitialized?
// //                     Center(
// //                       child: CircularProgressIndicator(),
// //                     ):
// //                     CameraPreview(controller!)
// //                 ),
// //
// //
// //
// //                 Container( //show captured image
// //                   padding: EdgeInsets.all(30),
// //                   child: image == null?
// //                   Text("No image captured"):
// //                   Image.file(File(image!.path), height: 300,),
// //                   //display captured image
// //                 )
// //               ]
// //           )
// //       ),
// //
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async{
// //           try {
// //             if(controller != null){ //check if contrller is not null
// //               if(controller!.value.isInitialized){ //check if controller is initialized
// //                 image = await controller!.takePicture(); //capture image
// //                 setState(() {
// //                   //update UI
// //                 });
// //               }
// //             }
// //           } catch (e) {
// //             print(e); //show error
// //           }
// //         },
// //         child: Icon(Icons.camera),
// //       ),
// //
// //     );
// //   }
// // }
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import "package:flutter_webrtc/flutter_webrtc.dart";
// import 'package:http/http.dart' as http;
//
// class P2PVideo extends StatefulWidget {
//   const P2PVideo({Key? key}) : super(key: key);
//
//   @override
//   _P2PVideoState createState() => _P2PVideoState();
// }
//
// class _P2PVideoState extends State<P2PVideo> {
//   RTCPeerConnection? _peerConnection;
//   final _localRenderer = RTCVideoRenderer();
//
//   MediaStream? _localStream;
//
//   RTCDataChannelInit? _dataChannelDict;
//   RTCDataChannel? _dataChannel;
//   String transformType = "none";
//
//   // MediaStream? _localStream;
//   bool _inCalling = false;
//
//   DateTime? _timeStart;
//
//   bool _loading = false;
//
//   void _onTrack(RTCTrackEvent event) {
//     print("TRACK EVENT: ${event.streams.map((e) => e.id)}, ${event.track.id}");
//     if (event.track.kind == "video") {
//       print("HERE");
//       _localRenderer.srcObject = event.streams[0];
//     }
//   }
//
//   void _onDataChannelState(RTCDataChannelState? state) {
//     switch (state) {
//       case RTCDataChannelState.RTCDataChannelClosed:
//         print("Camera Closed!!!!!!!");
//         break;
//       case RTCDataChannelState.RTCDataChannelOpen:
//         print("Camera Opened!!!!!!!");
//         break;
//       default:
//         print("Data Channel State: $state");
//     }
//   }
//
//   Future<bool> _waitForGatheringComplete(_) async {
//     print("WAITING FOR GATHERING COMPLETE");
//     if (_peerConnection!.iceGatheringState ==
//         RTCIceGatheringState.RTCIceGatheringStateComplete) {
//       return true;
//     } else {
//       await Future.delayed(Duration(seconds: 1));
//       return await _waitForGatheringComplete(_);
//     }
//   }
//
//   void _toggleCamera() async {
//     if (_localStream == null) throw Exception('Stream is not initialized');
//
//     final videoTrack = _localStream!
//         .getVideoTracks()
//         .firstWhere((track) => track.kind == 'video');
//     await Helper.switchCamera(videoTrack);
//   }
//
//   Future<void> _negotiateRemoteConnection() async {
//     return _peerConnection!
//         .createOffer()
//         .then((offer) {
//       return _peerConnection!.setLocalDescription(offer);
//     })
//         .then(_waitForGatheringComplete)
//         .then((_) async {
//       var des = await _peerConnection!.getLocalDescription();
//       var headers = {
//         'Content-Type': 'application/json',
//       };
//       var request = http.Request(
//         'POST',
//         Uri.parse(
//             'http://192.168.0.1:8080/offer'), // CHANGE URL HERE TO LOCAL SERVER
//       );
//       request.body = json.encode(
//         {
//           "sdp": des!.sdp,
//           "type": des.type,
//           "video_transform": transformType,
//         },
//       );
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//
//       String data = "";
//       print(response);
//       if (response.statusCode == 200) {
//         data = await response.stream.bytesToString();
//         var dataMap = json.decode(data);
//         print(dataMap);
//         await _peerConnection!.setRemoteDescription(
//           RTCSessionDescription(
//             dataMap["sdp"],
//             dataMap["type"],
//           ),
//         );
//       } else {
//         print(response.reasonPhrase);
//       }
//     });
//   }
//
//   Future<void> _makeCall() async {
//     setState(() {
//       _loading = true;
//     });
//     var configuration = <String, dynamic>{
//       'sdpSemantics': 'unified-plan',
//     };
//
//     //* Create Peer Connection
//     if (_peerConnection != null) return;
//     _peerConnection = await createPeerConnection(
//       configuration,
//     );
//
//     _peerConnection!.onTrack = _onTrack;
//     // _peerConnection!.onAddTrack = _onAddTrack;
//
//     //* Create Data Channel
//     _dataChannelDict = RTCDataChannelInit();
//     _dataChannelDict!.ordered = true;
//     _dataChannel = await _peerConnection!.createDataChannel(
//       "chat",
//       _dataChannelDict!,
//     );
//     _dataChannel!.onDataChannelState = _onDataChannelState;
//     // _dataChannel!.onMessage = _onDataChannelMessage;
//
//     final mediaConstraints = <String, dynamic>{
//       'audio': false,
//       'video': {
//         'mandatory': {
//           'minWidth':
//           '500', // Provide your own width, height and frame rate here
//           'minHeight': '500',
//           'minFrameRate': '30',
//         },
//         // 'facingMode': 'user',
//         'facingMode': 'environment',
//         'optional': [],
//       }
//     };
//
//     try {
//       var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       // _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
//       _localStream = stream;
//       // _localRenderer.srcObject = _localStream;
//
//       stream.getTracks().forEach((element) {
//         _peerConnection!.addTrack(element, stream);
//       });
//
//       print("NEGOTIATE");
//       await _negotiateRemoteConnection();
//     } catch (e) {
//       print(e.toString());
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _inCalling = true;
//       _loading = false;
//     });
//   }
//
//   Future<void> _stopCall() async {
//     try {
//       // await _localStream?.dispose();
//       await _dataChannel?.close();
//       await _peerConnection?.close();
//       _peerConnection = null;
//       _localRenderer.srcObject = null;
//     } catch (e) {
//       print(e.toString());
//     }
//     setState(() {
//       _inCalling = false;
//     });
//   }
//
//   Future<void> initLocalRenderers() async {
//     await _localRenderer.initialize();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     initLocalRenderers();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           return SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: ConstrainedBox(
//                       // height: MediaQuery.of(context).size.width > 500
//                       //     ? 500
//                       //     : MediaQuery.of(context).size.width - 20,
//                       constraints: BoxConstraints(maxHeight: 500),
//                       // width: MediaQuery.of(context).size.width > 500
//                       //     ? 500
//                       //     : MediaQuery.of(context).size.width - 20,
//                       child: AspectRatio(
//                         aspectRatio: 1,
//                         child: Stack(
//                           children: [
//                             Positioned.fill(
//                               child: Container(
//                                 color: Colors.black,
//                                 child: _loading
//                                     ? Center(
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 4,
//                                   ),
//                                 )
//                                     : Container(),
//                               ),
//                             ),
//                             Positioned.fill(
//                               child: RTCVideoView(
//                                 _localRenderer,
//                                 // mirror: true,
//                               ),
//                             ),
//                             _inCalling
//                                 ? Align(
//                               alignment: Alignment.bottomRight,
//                               child: InkWell(
//                                 onTap: _toggleCamera,
//                                 child: Container(
//                                   height: 50,
//                                   width: 50,
//                                   color: Colors.black26,
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.cameraswitch,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                                 : Container(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Wrap(
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text("Transformation: "),
//                             DropdownButton(
//                               value: transformType,
//                               onChanged: (value) {
//                                 setState(() {
//                                   transformType = value.toString();
//                                 });
//                               },
//                               items: ["none", "edges", "cartoon", "rotate"]
//                                   .map(
//                                     (e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(
//                                     e,
//                                   ),
//                                 ),
//                               )
//                                   .toList(),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(child: Container()),
//                   InkWell(
//                     onTap: _loading
//                         ? () {}
//                         : _inCalling
//                         ? _stopCall
//                         : _makeCall,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: _loading
//                             ? Colors.amber
//                             : _inCalling
//                             ? Colors.red
//                             : Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         child: _loading
//                             ? Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircularProgressIndicator(),
//                         )
//                             : Text(
//                           _inCalling ? "STOP" : "START",
//                           style: TextStyle(
//                             fontSize: 24,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
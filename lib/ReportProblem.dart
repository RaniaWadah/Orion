import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/UserHome.dart';
import 'package:untitled2/services/localNotification.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:image_cropper/image_cropper.dart';
import 'package:untitled2/services/image_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:untitled2/services/NotificationService.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class ReportAProblem extends StatelessWidget {
  const ReportAProblem({Key? key}) : super(key: key);

  static const String _title = 'Orion';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: const ReportAProblemWidget(),
      ),
    );
  }
}

class ReportAProblemWidget extends StatefulWidget {
  const ReportAProblemWidget({Key? key}) : super(key: key);
  @override
  State<ReportAProblemWidget> createState() => _ReportAProblemWidgetState();
}

class _ReportAProblemWidgetState extends State<ReportAProblemWidget> {
  final formKey = GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String token = 'cH1jckoWToE:APA91bERLybvnYFwyUz4mB5dz2DXoqAygjObRnQjzEZ-klIemoyCwN59hjbXHnB5ryXSdMEaew60sBAsctJ1ELWRmdMLz3l0fpjCKoPZqYzA13zskfm_z8TEG2Zdq0H57N7k3mbutbY3';
  String? mtoken = ' ';
  late DatabaseReference db;
  String? _currentAddress;
  Position? _currentPosition;
  bool isButtonActive = true;
  Timer? _countdownTimer;
  final ValueNotifier<int> _timeLeft = ValueNotifier<int>(0);
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  late TextEditingController controller;
  TextEditingController categoryController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? image;
  File? photo;
  String? imageUrl;
  final imageHelper  = ImageHelper();
  List<XFile>? imageList = [];
  List<String>? pathList = [];
  String selectedImagePath = '';
  bool _isDropdownEnabled = true;
  bool isDropdownEnabled = true;

  String disabled = 'No Category Selected';

  bool isValueEmpty = true;
  bool isImageEmpty = true;
  Timer? _timer;
  Duration _remainingDuration = Duration();

  final List<String> items = [
    '',
    'Accident',
    'Crime',
    'Traffic',
    'Fire',
  ];


  String? selectedValue;

  // late final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final ValueNotifier<bool> _problemState = ValueNotifier<bool>(false);
  final firestore = FirebaseFirestore.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  int _remainingSeconds = 0;

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

  Future<void> messageHandler() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //
    // });

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
    else if(!isEmpty && imageList.length == 1){
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
              'body': body + '\nImage Attached.\nSent from '+ userSnapshot.data()!['Area'].toString() + ", "
                  + userSnapshot.data()!['Block'].toString() + ".",
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
    else if(!isEmpty && imageList.length > 1){
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
              'body': body + '\nImages Attached.\nSent from '+ userSnapshot.data()!['Area'].toString() + ", "
                  + userSnapshot.data()!['Block'].toString() + ".",
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

  void initInfo() async{
    // await FirebaseFirestore.instance.collection('userTokens').doc('users1').set()
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseDatabase.instance.ref().child('userNotifications');
    controller = TextEditingController();
    _init();
    controller.addListener(() {
      final isButtonActive = controller.text.isNotEmpty;
      setState(() =>
      this.isButtonActive = isButtonActive);
    });
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
  //   final getHelpTime = (await SharedPreferences.getInstance()).getInt(
  //       'problem_time');
  //   if (getHelpTime != null) {
  //     final duration = getHelpTime - DateTime
  //         .now()
  //         .millisecondsSinceEpoch;
  //     if (duration > 0) {
  //       _timer = Timer(Duration(milliseconds: duration), _handleTimeout);
  //
  //       _remainingDuration = Duration(milliseconds: duration);
  //
  //       // Update remaining duration every second
  //       Timer.periodic(Duration(seconds: 1), (_) {
  //         if (_remainingDuration.inSeconds > 0) {
  //           if (mounted) {
  //             setState(() {
  //               _remainingDuration -= Duration(seconds: 1);
  //             });
  //           }
  //         }
  //       });
  //       return;
  //     }
  //   }
  //   _problemState.value = true;
  // }
  //
  // void _handleTimeout() {
  //   _problemState.value = true;
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
    (await SharedPreferences.getInstance()).getInt('problem_time');
    if (getHelpTime != null) {
      final duration = getHelpTime - DateTime.now().millisecondsSinceEpoch;
      if (duration > 0) {
        _timeLeft.value = duration;
        _timer = Timer(Duration(milliseconds: duration), _handleTimeout);
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _timeLeft.value = _timeLeft.value - 1000;
        });
        return;
      }
    }

    _problemState.value = true;
  }

  void _handleTimeout() {
    _problemState.value = true;
    _timer?.cancel();
    _countdownTimer?.cancel();
  }

  String _getButtonLabel(bool enabled, int timeLeft) {
    if (enabled) {
      return 'Submit Problem';
    }

    if (timeLeft <= 0) {
      return '00 : 00';
    }

    if (timeLeft <= 1000) {
      return '00 : 01';
    }

    final minute = ((timeLeft / 1000) ~/ 60).toString().padLeft(2, '0');
    final second = (((timeLeft / 1000) % 60).toInt()).toString().padLeft(2, '0');
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
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFB9CAE0),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                ),
                ValueListenableBuilder(
                    valueListenable: _problemState,
                    builder: (context, value, child) {
                      if (value != true) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 25),
                          child: const
                          Text(
                            'You can submit another problem after 10 minutes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppings',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }
                      else{
                        return Container();
                      }
                    }
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                    child: const Text(
                      'Report a Problem',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  height: 70,
                  child: Column(
                    children: [
                      Row(
                        children: <Widget> [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 5, 5),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                height: 50.0,
                                width: 250.0,
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children: const [
                                      Icon(
                                        Icons.list,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'Select Problem Category',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: _isDropdownEnabled
                                      ? (value) {
                                    setState(() {
                                      selectedValue = value as String;
                                      print(selectedValue);
                                      isValueEmpty = false;
                                    });
                                  }
                                      : null,
                                  disabledHint: Text(
                                    disabled,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down_outlined),
                                  iconSize: 30,
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 160,
                                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 3,
                                      color: const Color(0xfa34a0fa),
                                    ),
                                    color: const Color(0xFFB9CAE0),
                                  ),
                                  buttonElevation: 2,
                                  itemHeight: 40,
                                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownWidth: 273,
                                  dropdownPadding: const EdgeInsets.only(left: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFB9CAE0),
                                  ),
                                  dropdownElevation: 8,
                                  scrollbarRadius: const Radius.circular(40),
                                  scrollbarThickness: 6,
                                  scrollbarAlwaysShow: true,
                                  offset: const Offset(-20, 0),
                                ),
                              ),
                            ),
                          ),


                          // IconButton( // clear dropdown button
                          //     onPressed: () => null,
                          //     icon: Icon(Icons.clear))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 141, 5),
                  child: SizedBox(
                    height: 90,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 45,
                      // width: 240,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Enter Another Category',
                          labelText: 'Other Problem Category',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        // enabled: isValueEmpty == true,
                        controller: otherController,
                        onChanged: (value) {
                          setState(() {
                            _isDropdownEnabled = value.isEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                  child: SizedBox(
                    height: 120,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 250,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Enter a Description of the Problem',
                          labelText: 'Problem Description',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        minLines: 5,
                        maxLines: 10,
                        controller: descriptionController,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          imageList!.isEmpty ? Container()
                              : Container(
                              height: MediaQuery.of(context).size.height *0.28,
                              decoration: BoxDecoration(
                              ),
                              child: GridView.count(
                            crossAxisCount: 2,
                            children: List.generate(imageList!.length, (index){
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                          File(imageList![index].path),
                                          fit: BoxFit.fill),

                                      Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Container(
                                            color: Color.fromRGBO(255, 255, 244, 0.5),
                                            child: IconButton(
                                                icon: Icon(Icons.delete,
                                                  color: Colors.red[500],
                                                ),
                                                onPressed: (){
                                                  setState(() {
                                                    imageList!.removeAt(index);
                                                    pathList!.removeAt(index);
                                                    // pathList!.removeAt(index);
                                                  });
                                                }
                                            ),
                                          )
                                      )
                                    ],

                                  ),

                                ),
                              );
                            }),
                          )
                      ),
                      Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 7, 8, 15),
                              child: const Text('Add Image:', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              ),
                            ),

                            Padding (padding: const EdgeInsets.fromLTRB(17, 5, 5, 15),
                              child: ElevatedButton.icon(
                                onPressed: () async{
                                  selectImage();
                                  // setState(() {
                                  //
                                  // });
                                },
                                icon: Icon( // <-- Icon
                                  Icons.add,
                                  size: 35.0,
                                  color: Colors.white,
                                ),
                                label: Text(''),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: const Color(
                                      0xff02165c),
                                  padding: EdgeInsets.fromLTRB(23, 15, 15, 15),
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(100),
                                  // )
                                ),// <-- Text
                              ),
                            )
                          ]
                      ),
                    ],
                  ),
                ),

                Row(
                    children:[
                      Padding (padding: const EdgeInsets.fromLTRB(68, 20, 10, 0),
                        child: ValueListenableBuilder(
                          valueListenable: _problemState,
                          builder: (context, value, child) {
                            return ElevatedButton(
                              onPressed: value != true ? () {} : () async {
                                if(otherController.text.isEmpty &&
                                    descriptionController.text.isEmpty &&
                                    (isValueEmpty || selectedValue == '') && imageList!.isEmpty){
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text('You have to fill in at least one field'),
                                        );
                                      }
                                  );
                                }
                                else{
                                  final userSnapshot = await FirebaseFirestore.instance.collection('user').
                                  doc(FirebaseAuth.instance.currentUser!.uid).get();
                                  String userToken = userSnapshot.data()!['Token'];

                                  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('government')
                                      .where('Token', isNotEqualTo: null).get();
                                  List<DocumentSnapshot> docsList = snapshot.docs;
                                  List<String> tokenList = [];

                                  docsList.forEach((doc) {
                                    dynamic data = doc.data();
                                    String? token = data['Token']?.toString();
                                    if (token != null) {
                                      if(token != userToken){
                                        tokenList.add(token);
                                      }
                                    }
                                  });

                                  print(tokenList.toString());

                                  String cat = 'Report a Problem';
                                  String? title;
                                  if(isValueEmpty){
                                    title = cat + " - "+ otherController.text.toString();
                                  }
                                  else if(otherController.text.isEmpty){
                                    title = cat + " - "+ selectedValue!;
                                  }
                                  String? t;
                                  if(isValueEmpty){
                                    t = otherController.text.toString();
                                  }
                                  else if(otherController.text.isEmpty){
                                    t = selectedValue!;
                                  }

                                  String body = descriptionController.text.toString();

                                  Map<String, dynamic> Notifications = {
                                    'Title': 'Report a Problem',
                                    'Category': t,
                                    'Description': body,
                                    'Image': pathList,
                                    'Sender Civil ID': userSnapshot.data()!['Civil ID'],
                                    'Sender Device Token': userSnapshot.data()!['Token'],
                                    'Date and Time': DateTime.now().toString(),
                                    'Location': userSnapshot.data()!['Location'],
                                    'Area': userSnapshot.data()!['Area'],
                                    'Block': userSnapshot.data()!['Block'],
                                  };
                                  db.push().set(Notifications);

                                  CollectionReference userRef = FirebaseFirestore.instance.collection(
                                      'userNotifications');
                                  userRef.doc()
                                      .set({
                                    'Title': 'Report a Problem',
                                    'Category': t,
                                    'Description': body,
                                    'Image': pathList,
                                    'Sender Civil ID': userSnapshot.data()!['Civil ID'],
                                    'Sender Device Token': userSnapshot.data()!['Token'],
                                    'Date and Time': DateTime.now().toString(),
                                    'Location': userSnapshot.data()!['Location'],
                                    'Area': userSnapshot.data()!['Area'],
                                    'Block': userSnapshot.data()!['Block'],
                                  })
                                      .then((value) => print("Notification Added"))
                                      .catchError((error) =>
                                      print("Failed to add notification: $error"));

                                  await sendPushMsgPlb(tokenList, title!, body, imageList);

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text('Your problem has been successfully submitted'),
                                        );
                                      }
                                  );

                                  final problemTime = DateTime.now().add(const Duration(minutes: 10));
                                  (await SharedPreferences.getInstance()).setInt('problem_time', problemTime.millisecondsSinceEpoch);

                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => UserHome()));
                                }
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
                              // child: const Text('Submit Problem', style: TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 20,
                              //   fontWeight: FontWeight.bold,
                              //
                              // ),
                              // ),
                              style: ElevatedButton.styleFrom(
                                  primary: value == true ? const Color(
                                      0xff02165c) : const Color(
                                      0xff91b2de), minimumSize: Size(260, 47),
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              ),

                            );
                          },
                        ),
                      )
                    ]
                ),
                Row(
                    children:[
                      Padding (padding: const EdgeInsets.fromLTRB(68, 10, 10, 0),
                        child: ElevatedButton(
                              onPressed: () async {
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => UserHome()));
                                },
                              child: const Text('Cancel', style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,

                              ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey, minimumSize: Size(260, 45),
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              ),

                            ),
                      )
                    ]
                ),
              ],
            )),

      ),
    );
  }

  Future selectImage(){
    return showDialog(
        context: this.context,
        builder: (BuildContext context){
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                  height: 160,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        children: [
                          Text('Select Image From:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async{
                                    selectedImagePath = await selectImageFromGallery();
                                    print('Image Path: ');
                                    print(selectedImagePath);
                                    if(selectedImagePath != ''){
                                      // pathList!.add(selectedImagePath);
                                      isImageEmpty = false;
                                      Navigator.pop(context);
                                      setState(() {
                                      });
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text('No Image Selected'),
                                            );
                                          }
                                      );
                                    }
                                  },
                                  child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                              children: [
                                                Image.asset('images/gallery.jpg', height: 60, width: 60),
                                                Text('Gallery',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ]
                                          )
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    selectedImagePath = await selectImageFromCamera();
                                    print('Image Path: ');
                                    print(selectedImagePath);
                                    if(selectedImagePath != ''){
                                      // pathList!.add(selectedImagePath);
                                      isImageEmpty = false;
                                      Navigator.pop(context);
                                      setState(() {

                                      });
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text('No Image Captured'),
                                            );
                                          }
                                      );
                                    }
                                  },
                                  child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                              children: [
                                                Image.asset('images/camera.jpg', height: 60, width: 60),
                                                Text('Camera',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ]
                                          )
                                      )
                                  ),
                                ),
                              ]
                          )
                        ],
                      )
                  )
              )
          );
        }
    );
  }

  selectImageFromGallery() async{
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 33) {
        await Permission.storage.request();
        var permissionStatus = await Permission.storage.status;

        if(permissionStatus.isGranted){
          XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
          // var img = File(file!.path);
          if(file != null){
            // var snapshot = await FirebaseStorage.instance.ref()
            //     .child('images/imageName')
            //     .putFile(img);
            // var downloadUrl = await snapshot.ref.getDownloadURL();
            // setState(() {
            //   imageUrl = downloadUrl;
            // });
            photo = File(file.path);
            uploadFile();

            imageList!.add(file);
            pathList!.add(file.path);
            setState(() {
              imageList;
            });
            return file.path;
          }
          else{
            return '';
          }
        }
      }  else {
        await Permission.photos.request();
        var permissionStatus = await Permission.photos.status;

        if(permissionStatus.isGranted){
          XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
          // var img = File(file!.path);
          if(file != null){
            // var snapshot = await FirebaseStorage.instance.ref()
            //     .child('images/imageName')
            //     .putFile(img);
            // var downloadUrl = await snapshot.ref.getDownloadURL();
            // setState(() {
            //   imageUrl = downloadUrl;
            // });
            photo = File(file.path);
            uploadFile();

            imageList!.add(file);
            pathList!.add(file.path);
            setState(() {
              imageList;
            });
            return file.path;
          }
          else{
            return '';
          }
        }
      }
    }

  }

  selectImageFromCamera() async{
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 33) {
        await Permission.storage.request();
        var permissionStatus = await Permission.storage.status;

        if(permissionStatus.isGranted){
          XFile? file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100);
          if(file != null){
            photo = File(file.path);
            uploadFile();

            imageList!.add(file);
            pathList!.add(file.path);
            setState(() {
              imageList;
            });
            return file.path;
          }
          else{
            return '';
          }
        }
      }  else {
        await Permission.photos.request();
        var permissionStatus = await Permission.photos.status;

        if(permissionStatus.isGranted){
          XFile? file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100);
          if(file != null){
            photo = File(file.path);
            uploadFile();

            imageList!.add(file);
            pathList!.add(file.path);
            setState(() {
              imageList;
            });
            return file.path;
          }
          else{
            return '';
          }
        }
      }
    }

  }

  selectMultiImage() async{
    List<XFile>? list = await ImagePicker().pickMultiImage(maxWidth: 200, maxHeight: 200);
    if(list.isNotEmpty){
      imageList!.addAll(list);
    }
    setState(() {

    });
  }

  Future<void> uploadFile() async {
    if (photo == null) return;
    final fileName = Path.basename(photo!.path);
    final destination = 'files/$fileName';
    try {
      final Reference ref = FirebaseStorage.instance.ref(destination).child('file/');
      final TaskSnapshot uploadTask = await ref.putFile(photo!);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('user').
      doc(FirebaseAuth.instance.currentUser!.uid).set(
          {'imageUrl' : downloadUrl}, SetOptions(merge: true)
      );
    } catch (e) {
      print('error occurred');
    }
  }

}

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/GiveAlarm.dart';
import 'package:untitled2/GovHome.dart';
import 'package:untitled2/Identify.dart';
import 'package:untitled2/ProvideSafetyMessage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/foundation.dart';




class StartRecording extends StatelessWidget {
  const StartRecording({Key? key}) : super(key: key);

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
        body: const StartRecordingWidget(),
      ),
      // routes: {
      //   "View": (_) => ViewNotifications(),
      // },
    );
  }
}

class StartRecordingWidget extends StatefulWidget {
  const StartRecordingWidget({Key? key}) : super(key: key);

  @override
  State<StartRecordingWidget> createState() => _StartRecordingWidgetState();
}

class _StartRecordingWidgetState extends State<StartRecordingWidget> {
  Future getData(url) async {
    http.Response Response = await http.get(Uri.parse(url));
    return Response.body;
  }
  bool record = false;
  bool isRecorded = false;
  bool _isVisible = true;
  bool _isTaskComplete = false;

  void _hideButton() {
    setState(() {
      _isVisible = false;
    });
  }
  late DatabaseReference db;
  bool isRecording = false;
  XFile? videoFile;
  File? vid;
  var Data;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black,
    minimumSize: Size(350, 45),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: const Color(0xFFB9CAE0),
  );

  selectVideoFromCamera() async{
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 33) {
        await Permission.storage.request();
        var permissionStatus = await Permission.storage.status;

        if(permissionStatus.isGranted){
          XFile? file = await ImagePicker().pickVideo(source: ImageSource.camera);
          if(file != null){
            setState(() {
              videoFile = file;
            });
            vid = File(file.path);
            uploadFile();
            isRecorded = true;
            _isVisible = true;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Video has been recorded'),
                  );
                }
            );
          }
          else{
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('No video has been recorded'),
                  );
                }
            );
            return '';
          }
        }
      }  else {
        await Permission.photos.request();
        var permissionStatus = await Permission.photos.status;

        if(permissionStatus.isGranted){
          XFile? file = await ImagePicker().pickVideo(source: ImageSource.camera);
          if(file != null){
            setState(() {
              videoFile = file;
            });
            vid = File(file.path);
            uploadFile();
            isRecorded = true;
            _isVisible = true;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Video has been recorded'),
                  );
                }
            );
          }
          else{
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('No video has been recorded'),
                  );
                }
            );
            return '';
          }
        }
      }
    }

  }

  Future<void> uploadFile() async {
    if (vid == null) return;
    final fileName = Path.basename(vid!.path);
    final destination = 'files/$fileName';
    try {
      final Reference ref = FirebaseStorage.instance.ref(destination).child('file/');
      final TaskSnapshot uploadTask = await ref.putFile(vid!);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      final govSnapshot = await FirebaseFirestore.instance.collection('government').
      doc(FirebaseAuth.instance.currentUser!.uid).get();
                Map<String,
                    dynamic> Recordings = {
                  'Date and Time': DateTime.now().toString(),
                  'Video': downloadUrl,
                  'Location': govSnapshot.data()!['Location'],
                };
                db.push().set(Recordings);

                CollectionReference userRef = FirebaseFirestore
                    .instance.collection(
                    'Recordings');
                userRef.doc()
                    .set({
                  'Date and Time': DateTime.now().toString(),
                  'Video': downloadUrl,
                  'Location': govSnapshot.data()!['Location'],
                });

    } catch (e) {
      print('error occurred');
    }
  }

  @override
  void initState(){
    super.initState();
    db = FirebaseDatabase.instance.ref().child('Recordings');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFB9CAE0),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.05, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 90, 10, 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Container(
                                  width: 95,
                                  height: 95,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isTaskComplete = true;
                                      });
                                      Data = await getData('http://192.168.0.221:5000/record');
                                      var DecodedData = jsonDecode(Data);
                                      print(DecodedData);

                                    },
                                    child: Icon( // <-- Icon
                                      Icons.video_camera_back_sharp,
                                      size: 38.0,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(
                                            0xff02165c),
                                        padding: EdgeInsets.fromLTRB(18.5, 24, 20, 20),
                                        // padding: EdgeInsets.symmetric(horizontal: 50),
                                        shape: CircleBorder(),
                                    ), // <-- Text
                                  ),
                                ),
                              ),

                            ]),
                      ),
                      _isTaskComplete?
                      Visibility(
                        visible: _isVisible,
                        child: Padding (padding: const EdgeInsets.fromLTRB(5, 25, 10, 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              _hideButton();
                              Data = await getData('http://192.168.0.221:5000/display');
                              var DecodedData = jsonDecode(Data);
                              print(DecodedData);
                            },
                            child: const Text('Display Video', style: TextStyle(
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
                      ):
                          Container(),
                      // isRecorded?
                      // Visibility(
                      //   visible: _isVisible,
                      //   child: Padding (padding: const EdgeInsets.fromLTRB(5, 25, 10, 5),
                      //     child: ElevatedButton(
                      //       onPressed: () async{
                      //         final fileName = Path.basename(vid!.path);
                      //         final destination = 'files/$fileName';
                      //         try {
                      //           final Reference ref = FirebaseStorage.instance.ref(destination).child('file/');
                      //           final TaskSnapshot uploadTask = await ref.putFile(vid!);
                      //           final String downloadUrl = await uploadTask.ref.getDownloadURL();
                      //
                      //           final govSnapshot = await FirebaseFirestore.instance.collection('government').
                      //           doc(FirebaseAuth.instance.currentUser!.uid).get();
                      //           Map<String,
                      //               dynamic> Recordings = {
                      //             'Date and Time': DateTime.now().toString(),
                      //             'Video': downloadUrl,
                      //             'Location': govSnapshot.data()!['Location'],
                      //           };
                      //           db.push().set(Recordings);
                      //
                      //           CollectionReference userRef = FirebaseFirestore
                      //               .instance.collection(
                      //               'Recordings');
                      //           userRef.doc()
                      //               .set({
                      //             'Date and Time': DateTime.now().toString(),
                      //             'Video': downloadUrl,
                      //             'Location': govSnapshot.data()!['Location'],
                      //           });
                      //           showDialog(
                      //               context: context,
                      //               builder: (context) {
                      //                 return AlertDialog(
                      //                   content: Text('Video has been saved'),
                      //                 );
                      //               }
                      //           );
                      //
                      //         } catch (e) {
                      //           print('error occurred');
                      //         }
                      //         _hideButton();
                      //       },
                      //       child: const Text('Save Video', style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //       ),
                      //       style: ElevatedButton.styleFrom(primary: const Color(
                      //           0xff02165c), minimumSize: Size(170, 45),
                      //           padding: EdgeInsets.symmetric(horizontal: 50),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(20),
                      //           )
                      //       ),
                      //     ),
                      //   ),
                      // ):
                      //     Container(),
                      Padding (padding: const EdgeInsets.fromLTRB(3, 20, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                builder: (context) =>
                                    GovHome()));
                          },
                          child: const Text('Home', style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          style: ElevatedButton.styleFrom(primary: const Color(
                              0xff02165c), minimumSize: Size(205, 45),
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      ),

                      IconTheme(
                        data: IconThemeData(size: 22.0, color: Colors.white),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 131, 0, 0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Container(
                                        width: 90,
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CheckRecordings()));
                                          },
                                          child: Icon( // <-- Icon
                                            Icons.video_collection_sharp,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(
                                                  0xff02165c),
                                              padding: EdgeInsets.fromLTRB(20, 13, 20, 20),
                                              // padding: EdgeInsets.symmetric(horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ), // <-- Text
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Container(
                                        width: 90,
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => GiveAlarm()));
                                          },
                                          child: Icon( // <-- Icon
                                            Icons.alarm_add_sharp,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(
                                                  0xff02165c),
                                              padding: EdgeInsets.fromLTRB(20, 13, 20, 20),
                                              // padding: EdgeInsets.symmetric(horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ), // <-- Text
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Container(
                                        width: 90,
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SpeakerPage()));
                                          },
                                          child: Icon( // <-- Icon
                                            Icons.keyboard_voice_sharp,
                                            size: 35.0,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(
                                                  0xff02165c),
                                              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                              // padding: EdgeInsets.symmetric(horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ), // <-- Text
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Container(
                                        width: 90,
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const Identify()));
                                          },
                                          child: Icon( // <-- Icon
                                            Icons.add_a_photo_sharp,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(
                                                  0xff02165c),
                                              padding: EdgeInsets.fromLTRB(20, 13, 20, 20),
                                              // padding: EdgeInsets.symmetric(horizontal: 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              )
                                          ), // <-- Text
                                        ),
                                      ),
                                    ),
                                  ]
                              ),

                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
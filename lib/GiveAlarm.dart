import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/GovHome.dart';
import 'package:untitled2/Identify.dart';
import 'package:untitled2/ProvideSafetyMessage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled2/StartRecording.dart';


class GiveAlarm extends StatelessWidget {
  const GiveAlarm({Key? key}) : super(key: key);

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
        body: const GiveAlarmWidget(),
      ),
    );
  }
}

class GiveAlarmWidget extends StatefulWidget {
  const GiveAlarmWidget({Key? key}) : super(key: key);

  @override
  State<GiveAlarmWidget> createState() => _GiveAlarmWidgetState();
}

class _GiveAlarmWidgetState extends State<GiveAlarmWidget> {
  bool turnOn = false;
  bool turnOff = false;
  String? token = '';
  String? mtoken = ' ';
  late DatabaseReference db;
  bool isSwitched = false;
  var Data;
  AudioPlayer? player;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black,
    minimumSize: Size(350, 45),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: const Color(0xFFB9CAE0),
  );

  Future getData(url) async {
    http.Response Response = await http.get(Uri.parse(url));
    return Response.body;
  }

  Future<void> playSound() async {
    await player!.setAsset('audio/alarm.mp3');
    player!.play();
    await player!.setLoopMode(LoopMode.all);
  }

  Future<void> stopSound() async {
    player!.stop();
  }



  @override
  void initState(){
    super.initState();
    db = FirebaseDatabase.instance.ref().child('Alarm');
    player = AudioPlayer();

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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            isSwitched ?

                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(-0.3, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      22, 5, 30, 22),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '\nAlarm system is turned on',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                ),
                              ),
                            )
                                :
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(-0.3, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      22, 5, 30, 22),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '\nAlarm system is turned off',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 25, 10, 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              SizedBox(
                                width: 150,
                                height: 110,

                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Switch(
                                    value: isSwitched,
                                    activeColor: const Color(0xff02165c),
                                    onChanged: (value) async{
                                      if(value == true){
                                        await playSound();
                                        String body = "Alarm system has been turned on";
                                        Map<String,
                                            dynamic> Notifications = {
                                          'Description': body,
                                          'Date and Time': DateTime.now().toString(),
                                        };
                                        db.push().set(Notifications);

                                        CollectionReference userRef = FirebaseFirestore
                                            .instance.collection(
                                            'Alarm');
                                        userRef.doc()
                                            .set({
                                          'Description': body,
                                          'Date and Time': DateTime.now().toString(),
                                        });
                                      }
                                      else{
                                        await stopSound();
                                      }
                                      setState(() {
                                        isSwitched = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]),
                      ),
                            Padding (padding: const EdgeInsets.fromLTRB(5, 5, 10, 10),
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
                                    0xff02165c), minimumSize: Size(170, 45),
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
                              padding: EdgeInsetsDirectional.fromSTEB(0, 153, 0, 0),
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
                                                    builder: (context) => const StartRecording()));
                                          },
                                          child: Icon( // <-- Icon
                                            Icons.video_camera_back_sharp,
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
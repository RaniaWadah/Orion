import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:translator/translator.dart';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/GiveAlarm.dart';
import 'package:untitled2/GovHome.dart';
import 'package:untitled2/Identify.dart';
import 'package:untitled2/StartRecording.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/Track.dart';

class SpeakerPage extends StatefulWidget {
  @override
  _SpeakerPageState createState() => _SpeakerPageState();
}

class _SpeakerPageState extends State<SpeakerPage> {
  var languages = ['Arabic', 'Urdu', 'Hindi', 'Persian', 'Filipino', 'Chinese', 'Japanese', 'Korean', 'Turkish', 'French', 'Spanish', 'Italian', 'Ukrainian', 'Russian', 'Swedish', 'Armenian'];
  var originLanguage = 'English';
  var destinationLanguage = '';
  var output = '';
  String text = 'Press the mic to start providing messages';

  stt.SpeechToText? _speech;
  bool _isListening = false;
  // bool isMicListening = false;
  // String _text = "Press the mic to start providing messages";
  double _confidence = 1.0;
  late DatabaseReference db;

  final translator = GoogleTranslator();
  // final input = "";

  String? token = '';
  String? mtoken = ' ';

  TextEditingController controller = TextEditingController();

  Future Getdata(url) async {
    http.Response Response = await http.get(Uri.parse(url));
    return Response.body;
  }
  Future<void> translate(String dest, String input) async{
    GoogleTranslator translator = new GoogleTranslator();
    var translation = await translator.translate(input, from: getLanguageCode(originLanguage), to: dest);
    setState(() {
      output = translation.text.toString();
    });
    print(translation.text.toString());

    if(dest == '--'){
      output = 'Fail to translate';
    }
  }

  String getLanguageCode(String language){
    if(language == "English"){
      return "en";
    }
    else if(language == "Hindi"){
      return "hi";
    }
    else if(language == "Persian"){
      return "fa";
    }
    else if(language == "Arabic"){
      return "ar";
    }
    else if(language == "Urdu"){
      return "ur";
    }
    else if(language == "Chinese"){
      return "zh";
    }
    else if(language == "Japanese"){
      return "ja";
    }
    else if(language == "Korean"){
      return "ko";
    }
    else if(language == "Filipino"){
      return "fil";
    }
    else if(language == "French"){
      return "fr";
    }
    else if(language == "Italian"){
      return "it";
    }
    else if(language == "Spanish"){
      return "es";
    }
    else if(language == "Turkish"){
      return "tr";
    }
    else if(language == "Russian"){
      return "ru";
    }
    else if(language == "Armenian"){
      return "hy";
    }
    else if(language == "Ukrainian"){
      return "uk";
    }
    else if(language == "Swedish"){
      return "sv";
    }
    return 'en';
  }


  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
    }
  }
  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }
  Future<void> _listen() async {
    if (!_isListening) {
      bool avail = await _speech!.initialize();
      if (avail) {
        setState(() {
          _isListening = true;
        });
        _speech!.listen(onResult: (value) {
          setState(() {
            text = value.recognizedWords;
            if (value.hasConfidenceRating && value.confidence > 0) {
              _confidence = value.confidence;
            }
          });
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech!.stop();
      await translate(getLanguageCode(destinationLanguage), controller.text.trim().toString());
      print(controller.text.trim().toString());
      speak();
      if(controller.text.trim().toString() != "Press the mic to start providing messages" && controller.text.trim().toString() != ""){
        print(controller.text.trim().toString());
        Map<String,
            dynamic> Notifications = {
          'Message': controller.text.trim().toString(),
          'Date and Time': DateTime.now()
              .toString(),
        };
        db.push().set(Notifications);

        CollectionReference userRef = FirebaseFirestore
            .instance.collection(
            'Speaker');
        userRef.doc()
            .set({
          'Message': controller.text.trim().toString(),
          'Date and Time': DateTime.now().toString(),
        });
      }

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

    final String defaultLanguage = 'en-US';

  TextToSpeech tts = TextToSpeech();

  // String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2
  String? voice;

  void speak() {
    tts.setVolume(volume);
    tts.setRate(rate);
    tts.setPitch(pitch);
    tts.speak(output);
  }
  @override
  void initState(){
    super.initState();
    _speech = stt.SpeechToText();
    db = FirebaseDatabase.instance.ref().child('Speaker');
    listenForPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: const Color(0xff02165c),
          endRadius: 500,
          duration: Duration(milliseconds: 2000),
          repeatPauseDuration: Duration(milliseconds: 100),
          repeat: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 40), // Add padding here
            child: SizedBox(
              width: 75,
              height: 75,
              child: FloatingActionButton(
                backgroundColor: const Color(0xff02165c),
                child: Icon(_isListening? Icons.mic : Icons.mic_none,
                  size: 40,
                ),
                onPressed: () async{
                  await _listen();
                },
              ),
            ),
          ),
        ),

        body: Container(
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
                                !_isListening ?
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(-0.3, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          22, 5, 30, 22),
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '\nSpeaker is turned off',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                )
                                    : Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(-0.3, 0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          22, 5, 30, 22),
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '\nSpeaker is turned on',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextField(
                                    readOnly: true, // disable editing
                                    enabled: false,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 20, left: 33),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xff02165c),
                                      ),
                                      border: InputBorder.none, // remove border
                                      fillColor: Colors.transparent, // remove background color
                                      filled: true, // fill the container with the background color
                                      hintText: text,
                                    ),
                                    controller: controller..text = '${text.toString()}',// add hint text
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(75, 125, 10, 10),
                            child: Row(
                              children: <Widget>[
                                const Text('Speaker Language',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xfa34a0fa),
                                  width: 3,
                                ),
                              ),
                              child: DropdownButton(
                                focusColor: Colors.white,
                                iconDisabledColor: Colors.black,
                                iconEnabledColor: Colors.black,
                                hint: Text(
                                  destinationLanguage, style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                ),
                                dropdownColor: Color(0xFFB9CAE0),
                                icon: Icon(Icons.arrow_drop_down, size: 28,),
                                items: languages.map((String downDownStringItem){
                                  return DropdownMenuItem(
                                    child: Text(downDownStringItem,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    value: downDownStringItem,
                                  );
                                }).toList(),
                                onChanged: (String? value){
                                  setState(() {
                                    destinationLanguage = value!;
                                  });
                                },
                              ),
                            ),

                            ],
                            ),
                          ),
                          Padding (padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ElevatedButton(
                              onPressed: () {
                                messages();
                              },
                              child: const Text('View Messages', style: TextStyle(
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
                          Padding (padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  0xff02165c), minimumSize: Size(240, 45),
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              ),
                            ),
                          ),
                          IconTheme(
                            data: IconThemeData(size: 22.0, color: Colors.white),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
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
                                                          builder: (context) => const Track()));
                                                },
                                                child: Icon( // <-- Icon
                                                  Icons.location_searching,
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
                                                          builder: (context) => const GiveAlarm()));
                                                },
                                                child: Icon( // <-- Icon
                                                  Icons.alarm_add_sharp,
                                                  size: 35.0,
                                                  color: Colors.white,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary: const Color(
                                                        0xff02165c),
                                                    padding: EdgeInsets.fromLTRB(20, 11, 20, 20),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
  void messages() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Speaker').
    where('Message', isNotEqualTo: null).get();

    List<DocumentSnapshot> docsList = snapshot.docs;
    List<String> messageList = [];

    docsList.forEach((doc) {
      dynamic data = doc.data();
      String? message = data['Message']?.toString();
      if (message != null) {
        messageList.add(message);
      }
    });

    print(messageList.toString());

    showDialog(
        context: this.context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                    height: 300,
                    // width: 1000,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            children: [
                              Expanded(
                                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance.collection('Speaker').snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData || messageList.isEmpty) {
                                      return Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Text(
                                          'No provided messages',
                                          style: TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                    else{
                                      return Column(
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(-0.3, 0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  5, 5, 5, 5),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Messages provided using the speaker:',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 20, fontWeight: FontWeight.bold),
                                                  )
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: snapshot.data!.docs.map((document) {
                                                var msg = document['Message'].toString();
                                                return Center(
                                                    child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                              child: Text(msg,
                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                );
                                              }
                                              ).toList(),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),

                              ),
                              Row(
                                children: [
                                  Padding(padding: const EdgeInsets.fromLTRB(
                                      70, 30, 10, 0),
                                    child: ElevatedButton(
                                      child: const Text(
                                        'OK', style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,

                                      ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(170, 45),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                        ),
                                        primary: const Color(
                                            0xff02165c),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]
                        )
                    )
                )
            );
          }
          );
        }
    );
  }
}

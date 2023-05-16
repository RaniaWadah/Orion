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
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/GiveAlarm.dart';
import 'package:untitled2/GovHome.dart';
import 'package:untitled2/ProvideSafetyMessage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as Path;
import 'package:untitled2/StartRecording.dart';
import 'package:untitled2/Track.dart';
import 'package:untitled2/services/image_helper.dart';




class Identify extends StatelessWidget {
  const Identify({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        body: const IdentifyWidget(),
      ),
    );
  }
}

class IdentifyWidget extends StatefulWidget {
  const IdentifyWidget({Key? key}) : super(key: key);

  @override
  State<IdentifyWidget> createState() => _IdentifyWidgetState();
}

class _IdentifyWidgetState extends State<IdentifyWidget> {
  Future getData(url) async {
    http.Response Response = await http.get(Uri.parse(url));
    return Response.body;
  }
  final formKey = GlobalKey<FormState>();
  String token = 'cH1jckoWToE:APA91bERLybvnYFwyUz4mB5dz2DXoqAygjObRnQjzEZ-klIemoyCwN59hjbXHnB5ryXSdMEaew60sBAsctJ1ELWRmdMLz3l0fpjCKoPZqYzA13zskfm_z8TEG2Zdq0H57N7k3mbutbY3';
  String? mtoken = ' ';
  late DatabaseReference db;
  bool isButtonActive = true;
  late TextEditingController controller;
  TextEditingController categoryController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  XFile? image;
  File? photo;
  String? imageUrl;
  final imageHelper  = ImageHelper();
  String selectedImagePath = '';
  bool isDropdownEnabled = true;

  bool isCaptured = false;

  String disabled = 'No Category Selected';

  bool isValueEmpty = true;
  bool isImageEmpty = true;

  bool record = false;
  bool isRecorded = false;
  bool isRecording = false;

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

  @override
  void initState(){
    super.initState();
    db = FirebaseDatabase.instance.ref().child('Images');
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
                        padding: const EdgeInsets.only(top: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            isImageEmpty ? Container()
                                : Container(
                                height: MediaQuery.of(context).size.height *0.28,
                                decoration: BoxDecoration(
                                ),
                                child: Container(
                                  width: 300, // specify the desired width
                                  height: 450, // specify the desired height
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                                selectedImagePath,
                                                width: 200,
                                                height: 200,
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
                                                          selectedImagePath = '';
                                                          isImageEmpty = true;
                                                        });
                                                      }
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                                  isImageEmpty?
                                  Padding (padding: const EdgeInsets.fromLTRB(0, 100, 20, 5),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        selectImage();

                                        },
                                      child: Icon( // <-- Icon
                                        Icons.add_a_photo_sharp,
                                        size: 38.0,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xff02165c),
                                        padding: EdgeInsets.fromLTRB(17.5, 19.5, 20, 20),
                                        shape: CircleBorder(),
                                      ), // <-- Text
                                    ),
                                  )
                                      : Container()
                                ]
                            ),
                        ),

                      !isImageEmpty?
                      Padding (padding: const EdgeInsets.fromLTRB(5, 25, 10, 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              Data = await getData('http://192.168.8.105:5000/recognize');
                              var DecodedData = jsonDecode(Data);
                              print(DecodedData);

                            },
                            child: const Text('Recognize Image', style: TextStyle(
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
                        )
                          :
                      Container(),
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
                              0xff02165c), minimumSize: Size(258, 45),
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
                                      isImageEmpty = false;
                                      Navigator.pop(context);
                                      setState(() {
                                        isImageEmpty = false;
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
                                        isImageEmpty = false;
                                        Navigator.pop(context);
                                        setState(() {
                                          isImageEmpty = false;
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
          if(file != null){
            photo = File(file.path);
            if (photo == null) return;
            final fileName = Path.basename(photo!.path);
            final destination = '$fileName';
            print(destination);
            try {
              final Reference ref = FirebaseStorage.instance.ref(destination);
              final TaskSnapshot uploadTask = await ref.putFile(photo!);
              final String downloadUrl = await uploadTask.ref.getDownloadURL();

              final govSnapshot = await FirebaseFirestore.instance.collection('government').
              doc(FirebaseAuth.instance.currentUser!.uid).get();
              Map<String,
                  dynamic> images = {
                'Date and Time': DateTime.now().toString(),
                'Image': downloadUrl,
                'Location': govSnapshot.data()!['Location'],
              };
              db.push().set(images);

              CollectionReference userRef = FirebaseFirestore
                  .instance.collection(
                  'Images');
              userRef.doc()
                  .set({
                'Date and Time': DateTime.now().toString(),
                'Image': downloadUrl,
                'Location': govSnapshot.data()!['Location'],
              });
              return downloadUrl;

            } catch (e) {
              return '';
            }
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
          if(file != null){
            photo = File(file.path);
            if (photo == null) return;
            final fileName = Path.basename(photo!.path);
            final destination = '$fileName';
            print(destination);
            try {
              final Reference ref = FirebaseStorage.instance.ref(destination);
              final TaskSnapshot uploadTask = await ref.putFile(photo!);
              final String downloadUrl = await uploadTask.ref.getDownloadURL();

              final govSnapshot = await FirebaseFirestore.instance.collection('government').
              doc(FirebaseAuth.instance.currentUser!.uid).get();
              Map<String,
                  dynamic> images = {
                'Date and Time': DateTime.now().toString(),
                'Image': downloadUrl,
                'Location': govSnapshot.data()!['Location'],
              };
              db.push().set(images);

              CollectionReference userRef = FirebaseFirestore
                  .instance.collection(
                  'Images');
              userRef.doc()
                  .set({
                'Date and Time': DateTime.now().toString(),
                'Image': downloadUrl,
                'Location': govSnapshot.data()!['Location'],
              });
              return downloadUrl;

            } catch (e) {
              return '';
            }
          }
          else{
            return '';
          }
        }
      }
    }

  }

  selectImageFromCamera() async {
    var url = Uri.parse('http://192.168.8.105:5000/photo');
    http.Response response = await http.get(url);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imagesRef = storage.ref();
    ListResult listResult = await imagesRef.listAll();
    List<String> fileNames = [];
    List<DateTime?> creationTimes = [];

    await Future.forEach(listResult.items, (Reference imageRef) async {
      FullMetadata metadata = await imageRef.getMetadata();
      if (metadata.contentType == 'image/jpg' || metadata.contentType == 'image/jpeg') {
        fileNames.add(metadata.name);
        creationTimes.add(metadata.timeCreated);
      }
    });
    print(fileNames);
    print(creationTimes);
    List<DateTime?> sortedCreationTimes = List.from(creationTimes);
    sortedCreationTimes.sort((a, b) => b!.compareTo(a!));

    List<String> sortedFileNames = [];
    for (DateTime? time in sortedCreationTimes) {
      int index = creationTimes.indexOf(time);
      sortedFileNames.add(fileNames[index]);
    }

    fileNames.clear();
    fileNames.addAll(sortedFileNames);
    if (creationTimes.isNotEmpty) {
      DateTime? mostRecentTime = creationTimes.first;
      int mostRecentIndex = creationTimes.indexOf(mostRecentTime);
      String mostRecentFileName = fileNames[mostRecentIndex];
      Reference mostRecentImageRef = imagesRef.child(mostRecentFileName);
      String mostRecentImageURL = await mostRecentImageRef.getDownloadURL();
      print('Most recent image: $mostRecentFileName');
      return mostRecentImageURL;
    }
    else{
      return '';
    }
  }

  Future<void> uploadFile() async {
    print(photo);
    if (photo == null) return;
    final fileName = Path.basename(photo!.path);
    final destination = '$fileName';
    print(destination);
    try {
      final Reference ref = FirebaseStorage.instance.ref(destination);
      final TaskSnapshot uploadTask = await ref.putFile(photo!);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      final govSnapshot = await FirebaseFirestore.instance.collection('government').
      doc(FirebaseAuth.instance.currentUser!.uid).get();
      Map<String,
          dynamic> images = {
        'Date and Time': DateTime.now().toString(),
        'Image': downloadUrl,
        'Location': govSnapshot.data()!['Location'],
      };
      db.push().set(images);

      CollectionReference userRef = FirebaseFirestore
          .instance.collection(
          'Images');
      userRef.doc()
          .set({
        'Date and Time': DateTime.now().toString(),
        'Image': downloadUrl,
        'Location': govSnapshot.data()!['Location'],
      });

    } catch (e) {
      print('error occurred');
    }
  }
}
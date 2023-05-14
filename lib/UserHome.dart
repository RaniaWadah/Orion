import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled2/GetHelp.dart';
import 'package:untitled2/ReportProblem.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  static const String _title = 'Orion';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: const UserHomeWidget(),
      ),
    );
  }
}

class UserHomeWidget extends StatefulWidget {
  const UserHomeWidget({Key? key}) : super(key: key);
  @override
  State<UserHomeWidget> createState() => _UserHomeWidgetState();
}

class _UserHomeWidgetState extends State<UserHomeWidget> {

  String? mtoken = ' ';
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black,
    minimumSize: Size(350, 45),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: const Color(0xFFB9CAE0),
  );

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  void getToken() async{
    await _firebaseMessaging.getToken().then(
            (token) {
          setState(() {
            mtoken = token;
          });
          saveToken(token!);
        }
    );
  }

  void saveToken(String? token) async{
    await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'Token' : token}, SetOptions(merge: true)
    );
  }

  void getAddress() async{
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    String address = await GetAddressFromLatLong(position);
    String area = await GetAreaFromLatLong(position);
    String block = await GetBlockFromLatLong(position);

    await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'Location' : address.toString()}, SetOptions(merge: true)
    );
    await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'Area' : area.toString()}, SetOptions(merge: true)
    );

    await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'Block' : block.toString()}, SetOptions(merge: true)
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    getAddress();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB9CAE0),
      child: Scaffold(
        backgroundColor: const Color(0xFFB9CAE0),
        resizeToAvoidBottomInset: false,
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
                    padding: const EdgeInsets.fromLTRB(10, 65, 10, 10),
                    child: const Text(
                      'How Can Orion Help You?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                SingleChildScrollView(
                  child: Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
                          child: ElevatedButton(
                                  onPressed: () async{
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => GetHelp()));
                                  },
                                  child: const Text('Get Help', style: TextStyle(
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
                      ]
                  ),

                ),
                SingleChildScrollView(
                  child: Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(72, 15, 10, 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => ReportAProblem()));
                            },
                            child: const Text('Report a Problem', style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight. bold,
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
                      ]
                  ),
                ),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 110, 10, 10),
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
                  ),
                )
              ],

            )
        ),
      ),
    );

  }

  String location ='Null, Press Button';
  String Address = 'search';
  String Area = 'search';
  String Block = 'search';
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
    Address = 'Street: ${place.street}, Area: ${place.locality}, Governorate: ${place.administrativeArea}, Country: ${place.country}';
    return Address;
  }

  Future<String> GetAreaFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Area = '${place.locality}';
    return Area;
  }

  Future<String> GetBlockFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Block = 'Block 5';
    return Block;
  }

}
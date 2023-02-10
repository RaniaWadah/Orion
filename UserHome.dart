import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/EditProfile.dart';
import 'package:untitled2/Profile/Profile.dart';
import 'package:untitled2/GetHelp.dart';
import 'package:http/http.dart';

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

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black,
    minimumSize: Size(350, 45),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: const Color(0x6FE8D298),
  );

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void getToken() async{
    try{
      final token = await _firebaseMessaging.getToken();
      FirebaseFirestore.instance.collection('users1').
      doc(FirebaseAuth.instance.currentUser!.uid).set(
          {'Token' : token}, SetOptions(merge: true)
      );
    } catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return Container(
      color: const Color(0x6FE8D298),
      child: Scaffold(
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
                    padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: const Text(
                      'How Can Orion Help You?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                SingleChildScrollView(
                  child: Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
                          child: ElevatedButton(
                            onPressed: () {
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

                ),
                SingleChildScrollView(
                  child: Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(72, 15, 10, 10),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Report a Problem', style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight. bold,
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
                ),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 188, 10, 10),
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

                // Padding(
                //     padding: const EdgeInsets.fromLTRB(10, 175, 0, 0),
                //   child: Row(
                //     mainAxisSize:MainAxisSize.min,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                //         child: ElevatedButton(
                //           onPressed:() {
                //             Navigator.pushReplacement(context, MaterialPageRoute(
                //                 builder: (context) => EditProfile()));
                //           },
                //           style: ElevatedButton.styleFrom(
                //               primary: Colors.indigo,
                //               padding: EdgeInsets.symmetric(horizontal: 50),
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(20),
                //               )
                //           ), // <-- Text
                //           child: Container(
                //             width: 70,
                //             height: 60,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Text("Edit Profile",
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Icon(
                //                   Icons.edit,
                //                   size: 25.0,
                //                   color: Colors.white,
                //                 )
                //               ],
                //             ),
                //           ),
                //
                //         ),
                //       ),
                //       // Container(
                //       //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                //       //   child: ElevatedButton(
                //       //     onPressed:() {
                //       //       FirebaseAuth.instance.signOut();
                //       //     },
                //       //     style: ElevatedButton.styleFrom(
                //       //         primary: Colors.indigo,
                //       //         padding: EdgeInsets.symmetric(horizontal: 50),
                //       //         shape: RoundedRectangleBorder(
                //       //           borderRadius: BorderRadius.circular(20),
                //       //         )
                //       //     ), // <-- Text
                //           // child: Container(
                //           //   width: 70,
                //           //   height: 60,
                //           //   child: Column(
                //           //     mainAxisAlignment: MainAxisAlignment.center,
                //           //     children: [
                //           //       Text("Log Out",
                //           //         style: TextStyle(
                //           //           fontWeight: FontWeight.bold,
                //           //         ),
                //           //       ),
                //           //       Icon(
                //           //         Icons.logout_sharp,
                //           //         size: 25.0,
                //           //         color: Colors.white,
                //           //       )
                //           //
                //           //     ],
                //           //   ),
                //           // ),
                //         // ),
                //       // )
                //     ],
                //   ),
                // ),
              ],

            )
        ),
      ),
    );

  }
}
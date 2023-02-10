import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/services/AuthProvider.dart';
import 'Model/model.dart';
import 'package:provider/provider.dart';


final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey : navigatorKey,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: const EditProfileWidget(),
          ),
    );
  }
}

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key}) : super(key: key);

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController civilIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late DatabaseReference db;
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  User? currUser;
  List<UserData> userList = [];
  final ref = FirebaseDatabase.instance.ref().child('users1');
  bool isVisible = true;
  final cUser = FirebaseAuth.instance;
  final CollectionReference data = FirebaseFirestore.instance.collection(
      'users1');
  late FirebaseFirestore firestore;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black,
    minimumSize: Size(350, 45),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    backgroundColor: const Color(0x6FE8D298),
  );

  @override
  void initState() {
    super.initState();
    db = FirebaseDatabase.instance.ref().child('users1');
    firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    super.dispose();
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    civilIDController.dispose();
    passwordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x6FE8D298),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                  child: const Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              Form(
                key: formKey,
                child: Expanded(
                    child: StreamBuilder(
                        stream: data.
                        where("uid", isEqualTo: cUser.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot <QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemBuilder: (context, i) {
                                var data = snapshot.data!.docs[i];
                                return Center(
                                    child: SingleChildScrollView(
                                        child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 20,),
                                              fNameTextField(
                                                  'First Name',
                                                  data['First Name']),
                                              lNameTextField(
                                                  'Last Name', data['Last Name']),
                                              emailTextField(
                                                  'Email', data['Email']),
                                              civilIDTextField(
                                                  'Civil ID', data['Civil ID']),
                                              passwordTextField(
                                                  'Password', data['Password']),
                                              SizedBox(height: 5,),
                                              Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          104, 0, 10, 10),
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                Map<String,
                                                                    String> users1 = {
                                                                  'First Name': fNameController
                                                                      .text,
                                                                  'Last Name': lNameController
                                                                      .text,
                                                                  'Email': emailController
                                                                      .text,
                                                                  'Civil ID': civilIDController
                                                                      .text,
                                                                  'Password': passwordController
                                                                      .text,
                                                                };
                                                                update(users1);
                                                                print(
                                                                    fNameController
                                                                        .text);
                                                                print(
                                                                    lNameController
                                                                        .text);
                                                                print(
                                                                    emailController
                                                                        .text);
                                                                print(
                                                                    civilIDController
                                                                        .text);
                                                                print(
                                                                    passwordController
                                                                        .text);
                                                              }

                                                              else {
                                                                return;
                                                              }
                                                          },
                                                          child: const Text(
                                                            'Update',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                              primary: const Color(
                                                                  0xA121732E),
                                                              minimumSize: Size(
                                                                  170, 45),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 50),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(20),
                                                              )
                                                          )
                                                      ),
                                                    )
                                                  ]
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(20, 30, 10, 10),
                                                    child: ElevatedButton.icon(
                                                      icon: Icon( // <-- Icon
                                                        Icons.logout,
                                                        size: 24.0,
                                                        color: Colors.black,
                                                      ),
                                                      label: Text(
                                                        'Log Out',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 20,
                                                        ),

                                                      ),
                                                      style: flatButtonStyle,
                                                      onPressed: () {
                                                        FirebaseAuth.instance
                                                            .signOut();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]
                                        )
                                    )
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                            );
                          }
                          else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    )
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget fNameTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: fNameController..text = '${placeHolder.toString()}',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This Field is Required';
            }
            return null;
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeHolder,
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              )

          ),
        )
    );
  }

  Widget lNameTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: lNameController..text = '${placeHolder.toString()}',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This Field is Required';
            }
            return null;
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeHolder,
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              )

          ),
        )
    );
  }

  Widget emailTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: emailController..text = '${placeHolder.toString()}',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This Field is Required';
            }
            else if (!value.contains('@')) {
              return 'Please Enter a Valid Email';
            }
            return null;
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeHolder,
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              )

          ),
        )
    );
  }

  Widget civilIDTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: civilIDController..text = '${placeHolder.toString()}',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This Field is Required';
            }
            else if(value != null && value.length < 12){
              return 'Please Enter a Valid Civil ID';
            }
            return null;
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 10),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeHolder,
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              )

          ),
        )
    );
  }

  Widget passwordTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: passwordController..text = '${placeHolder.toString()}',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This Field is Required';
            }
            else if (value != null && value.length < 6) {
              return 'Please Enter a Minimum of Six Characters';
            }
            return null;
          },
          obscureText: isVisible,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: isVisible
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onPressed: () =>
                {
                  setState(() {
                    isVisible = !isVisible;
                  }
                  )
                },
              ),
              contentPadding: EdgeInsets.only(bottom: 10),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeHolder,
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              )

          ),
        )
    );
  }

  Future<bool> isUsernameUnique(String username) async {
    var snapshot = await firestore
        .collection("users1")
        .where("Civil ID", isEqualTo: username)
        .get();
    return !snapshot.docs.isNotEmpty;
  }

  Future update(Map<String, String> users1) async {

    if(await isUsernameUnique(civilIDController.text)){
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        User user = await _auth.currentUser!;

        await user.updateEmail(emailController.text.trim());
        await user.updatePassword(passwordController.text.trim());

        FirebaseDatabase.instance.ref().child('users1').child(
            cUser.currentUser!.uid).update(users1).then(
                (value) {}
        );

        FirebaseFirestore.instance.collection('users1').
        doc(cUser.currentUser!.uid).update(users1);

        AuthCredential credential = EmailAuthProvider.credential(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential).whenComplete(() =>
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        'You have been successfully updated your information.'),
                  );
                }
            ).catchError((e) {
              print(e);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(e.toString()),
                    );
                  }
              );
            }
            )

        );
      }
      on FirebaseAuthException catch (e) {
        print(e);
        if (users1.containsValue(emailController.text)) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('This Email Already Exists.'),
                );
              }
          );
        }
        else {
          return null;
        }
      }
    }
    else{
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('This Username Already Exists.'),
            );
          }
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}


      // final user = FirebaseAuth.instance.currentUser;
      // await user?.updateEmail(emailController.text.trim());
      // await user?.updatePassword(passwordController.text.trim());

      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text(
      //             'You have been successfully updated your information.'),
      //       );
      //     }
      // );
      // if (!users1.containsValue(emailController.text)) {
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           content: Text(
      //               'You have been successfully updated your information.'),
      //         );
      //       }
      //   );
      // }
      //
    // on FirebaseAuthException catch (e) {
    //   print(e);
    //
    //   if (users1.containsValue(emailController.text)) {
    //     // emailController.clear();
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return AlertDialog(
    //             content: Text('This Account Already Exists.'),
    //           );
    //         }
    //     );
    //   }
    //   else {
    //     return null;
    //   }
    // }
  // }

// }

import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Model/model.dart';
import 'package:untitled2/UserLogin.dart';


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
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late DatabaseReference db;
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  User? currUser;
  List<UserData> userList = [];
  bool isVisible = true;
  final cUser = FirebaseAuth.instance;
  final CollectionReference data = FirebaseFirestore.instance.collection(
      'user');
  bool _isVisible = true;
  final firestore = FirebaseFirestore.instance;
  String initialCountry = 'KW';

  bool isEmailValid(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    civilIDController.dispose();
    usernameController.dispose();
    phoneController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB9CAE0),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: const Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              Form(
                key: formKey,
                child: Expanded(
                    child: StreamBuilder(
                        stream: data.where(
                            'uid', isEqualTo: cUser.currentUser!.uid)
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
                                              SizedBox(height: 15,),
                                              civilIDTextField(
                                                  'Civil ID', data['Civil ID']),
                                              fNameTextField(
                                                  'First Name',
                                                  data['First Name']),
                                              lNameTextField(
                                                  'Last Name',
                                                  data['Last Name']),
                                              usernameTextField(
                                                  'Username', data['Username']),
                                              emailTextField(
                                                  'Email', data['Email']),

                                              phoneTextField('Phone Number', data['Phone Number']),
                                              SizedBox(height: 5,),
                                              Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          78, 0, 10, 5),
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                            if (formKey
                                                                .currentState!
                                                                .validate()) {
                                                              showDialog(
                                                                context: context,
                                                                builder: (
                                                                    BuildContext context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Password'),
                                                                    content: TextFormField(
                                                                      obscureText: _isVisible,
                                                                      decoration: InputDecoration(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .lock_outline_sharp),
                                                                        hintText: 'Enter your Password',
                                                                        labelText: 'Password',
                                                                        labelStyle: TextStyle(
                                                                          fontSize: 15,
                                                                        ),
                                                                        border: OutlineInputBorder(),
                                                                        errorStyle: TextStyle(
                                                                            color: Colors
                                                                                .redAccent,
                                                                            fontSize: 10
                                                                        ),
                                                                        suffixIcon: IconButton(
                                                                          icon: _isVisible
                                                                              ? Icon(
                                                                              Icons
                                                                                  .visibility_off)
                                                                              : Icon(
                                                                              Icons
                                                                                  .visibility),
                                                                          onPressed: () =>
                                                                          {
                                                                            setState(() {
                                                                              _isVisible =
                                                                              !_isVisible;
                                                                            }
                                                                            )
                                                                          },
                                                                        ),
                                                                      ),
                                                                      controller: passwordController,
                                                                      validator: (
                                                                          value) {
                                                                        if (value ==
                                                                            null ||
                                                                            value
                                                                                .isEmpty) {
                                                                          return 'This Field is Required';
                                                                        }
                                                                        return null;
                                                                      },
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: Text(
                                                                            'Cancel'),
                                                                        onPressed: () {
                                                                          Navigator
                                                                              .of(
                                                                              context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text(
                                                                            'Done'),
                                                                        onPressed: () async {
                                                                          QuerySnapshot snapshot = await FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                              'user')
                                                                              .where(
                                                                              'Civil ID',
                                                                              isEqualTo: civilIDController
                                                                                  .text)
                                                                              .get();

                                                                          try {
                                                                            await FirebaseAuth
                                                                                .instance
                                                                                .signInWithEmailAndPassword(
                                                                              email: snapshot
                                                                                  .docs[0]['Email']
                                                                                  .toString(),
                                                                              password: passwordController
                                                                                  .text,
                                                                            );
                                                                            try {
                                                                              Map<
                                                                                  String,
                                                                                  String> users1 = {
                                                                                'Civil ID': civilIDController
                                                                                    .text,
                                                                                'First Name': fNameController
                                                                                    .text,
                                                                                'Last Name': lNameController
                                                                                    .text,
                                                                                'Username': usernameController
                                                                                    .text,
                                                                                'Email': emailController
                                                                                    .text,
                                                                              };
                                                                              update(
                                                                                  users1);
                                                                              print(
                                                                                  fNameController
                                                                                      .text);
                                                                              print(
                                                                                  lNameController
                                                                                      .text);
                                                                              print(
                                                                                  civilIDController
                                                                                      .text);
                                                                              print(
                                                                                  emailController
                                                                                      .text);
                                                                              print(
                                                                                  usernameController
                                                                                      .text);
                                                                              // Do something with the text
                                                                              Navigator
                                                                                  .of(
                                                                                  context)
                                                                                  .pop();
                                                                            }
                                                                            on FirebaseAuthException catch (e) {
                                                                              if (e
                                                                                  .code ==
                                                                                  'email-already-in-use') {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        context) {
                                                                                      return AlertDialog(
                                                                                        content: Text(
                                                                                            'This Email Already Exists'),
                                                                                      );
                                                                                    }

                                                                                );
                                                                              }
                                                                              else {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        context) {
                                                                                      return AlertDialog(
                                                                                        content: Text(
                                                                                            e
                                                                                                .message
                                                                                                .toString()),
                                                                                      );
                                                                                    }

                                                                                );
                                                                              }
                                                                            }
                                                                          }
                                                                          on FirebaseAuthException catch (e) {
                                                                            if (e
                                                                                .code ==
                                                                                'wrong-password') {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (
                                                                                      context) {
                                                                                    return AlertDialog(
                                                                                      content: Text(
                                                                                          'The password is invalid'),
                                                                                    );
                                                                                  }

                                                                              );
                                                                            }
                                                                            else {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (
                                                                                      context) {
                                                                                    return AlertDialog(
                                                                                      content: Text(
                                                                                          e
                                                                                              .message
                                                                                              .toString()),
                                                                                    );
                                                                                  }

                                                                              );
                                                                            }
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }

                                                            else {
                                                              return;
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Save Changes',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                              primary: const Color(
                                                                  0xff02165c),
                                                              minimumSize: Size(
                                                                  170, 45),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 50),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(
                                                                    20),
                                                              )
                                                          )
                                                      ),
                                                    )
                                                  ]
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  verifyEmail(
                                                      emailController.text
                                                          .trim()); //forgot password screen
                                                },
                                                child: const Text(
                                                    'Change Password'),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        20, 15, 10, 20),
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
                                                        onPressed:
                                                            () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
                                                                      UserLogin()));
                                                        };
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
          enabled: false,
          controller: fNameController..text = '${placeHolder.toString()}',
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(width: 3, color: Colors.black26), //<-- SEE HERE
                borderRadius: BorderRadius.circular(20),
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

  Widget lNameTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          enabled: false,
          controller: lNameController..text = '${placeHolder.toString()}',
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(width: 3, color: Colors.black26), //<-- SEE HERE
                borderRadius: BorderRadius.circular(20),
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

  Widget emailTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: emailController..text = '${placeHolder.toString()}',
          validator: (value) {
            if (!isEmailValid(value!)) {
              return 'Please Enter a Valid Email';
            }
            return null;
          },
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                borderRadius: BorderRadius.circular(20),
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

  Widget usernameTextField(String labelText, String placeHolder) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: usernameController..text = '${placeHolder.toString()}',
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                borderRadius: BorderRadius.circular(20),
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

  Widget phoneTextField(String labelText, String placeHolder) {
    return SizedBox(
      height: 90,
      child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.only(bottom: 20),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              errorStyle: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10
              ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: placeHolder,

            ),
            controller: phoneController..text = '${placeHolder.toString()}',
      keyboardType: TextInputType.phone,

            validator: (value) {
              if(value == null || value.isEmpty) {
                return 'This Field is Required';
              }
              else if(value != null && (value.length < 8 || value.length > 8)){
                return 'Phone Number must Have 8 Numbers';
              }
              else if(value != null && !isNumeric(value)){
                return 'Phone Number must Contain Numbers Only';
              }
              return null;
            },
      ),
    );
  }
    Widget civilIDTextField(String labelText, String placeHolder) {
    return SizedBox(
      height: 90,
      child: TextFormField(
            enabled: false,
            controller: civilIDController..text = '${placeHolder.toString()}',
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(width: 3, color: Colors.black26), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(20),
                ),
                // filled: true,
                // fillColor: Colors.black26,
                contentPadding: EdgeInsets.only(bottom: 20),
                labelText: labelText,
                labelStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),

                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: placeHolder,


            ),
      ),
    );
  }


  Future<bool> isCivilIDUnique(String civilID) async {
    var snapshot = await firestore
        .collection("Users").doc(cUser.currentUser!.uid).collection(
        'Information')
        .where("Civil ID", isEqualTo: civilID)
        .get();
    return !snapshot.docs.isNotEmpty;
  }

  Future<bool> isUsernameUnique(String username) async {
    var snapshot = await firestore
        .collection("user")
        .where("Username", isEqualTo: username)
        .get();
    return !snapshot.docs.isNotEmpty;
  }

  Future update(Map<String, String> users1) async {
    if(await isCivilIDUnique(civilIDController.text)){
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        User user = await _auth.currentUser!;

        await user.updateEmail(emailController.text.trim());
        await user.updatePassword(passwordController.text.trim());

        FirebaseDatabase.instance.ref().child('user').child(
            cUser.currentUser!.uid).update(users1).then(
                (value) {}
        );

        FirebaseFirestore.instance.collection('user').
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
                        'You have been successfully updated your information'),
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
                  content: Text('This Email Already Exists'),
                );
              }
          );
        }
        else {
          return null;
        }
      }
    }

    else if (!await isCivilIDUnique(civilIDController.text)){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('This Civil ID Already Exists'),
            );
          }
      );
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future verifyEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
          .whenComplete(() {
        print('Password Change Email Sent');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    'Password Change Email sent, please check your email'),
              );
            }

        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      });

      final FirebaseAuth _auth = FirebaseAuth.instance;
      User user = await _auth.currentUser!;
    }
    on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          }
      );
    }
  }
}
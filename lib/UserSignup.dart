import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/HomePage.dart';
import 'package:untitled2/UserLogin.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';





final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class UserSignup extends StatelessWidget {
  const UserSignup({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey : navigatorKey,
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
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return HomePageWidget();
              }
              else{
                return UserSignupWidget();
              }
            }
        )
      ),
    );
  }
}

class UserSignupWidget extends StatefulWidget {
  const UserSignupWidget({Key? key}) : super(key: key);

  @override
  State<UserSignupWidget> createState() => _UserSignupWidgetState();
}

class _UserSignupWidgetState extends State<UserSignupWidget> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController civilIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  late DatabaseReference db;
  late CollectionReference users;
  late User? currentUser;
  late CollectionReference userRef;
  final firestore = FirebaseFirestore.instance;
  String initialCountry = 'KW';
  PhoneNumber number = PhoneNumber(isoCode: 'KW');

  final formKey = GlobalKey<FormState>();
  bool isVisible = true;
  bool _isVisible = true;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool isEmailValid(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  void initState(){
    super.initState();
    db = FirebaseDatabase.instance.ref().child('user');
    users = FirebaseFirestore.instance.collection('user');
    currentUser = FirebaseAuth.instance.currentUser;
    userRef = FirebaseFirestore.instance.collection('user');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB9CAE0),
      child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: const Text(
                          '',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.person),
                          hintText: 'Enter your Civil ID',
                          labelText: 'Civil ID',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: civilIDController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          else if(value != null && value.length < 12){
                            return 'Civil ID must have 12 Numbers';
                          }
                          else if(value != null && !isNumeric(value)){
                            return 'Civil ID must Contain Numbers Only';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.person),
                          hintText: 'Enter your First Name',
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: fNameController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.person),
                          hintText: 'Enter your Last Name',
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: lNameController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.person),
                          hintText: 'Enter your Username',
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: usernameController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.email_sharp),
                          hintText: 'Enter your Email',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: emailController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          else if(!isEmailValid(value)){
                            return 'Please Enter a Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        obscureText: isVisible,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.lock_outline_sharp),
                          hintText: 'Enter your Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                          suffixIcon: IconButton(
                            icon: isVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () => {
                              setState((){
                                isVisible =! isVisible;
                              }
                              )
                            },
                          ),
                        ),
                        controller: passwordController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          else if(value != null && value.length < 6){
                            return 'Please Enter a Minimum of Six Characters';
                          }
                          return null;
                        },
                      ),
                    ),

                    Row(
                        children:[
                          Padding (padding: const EdgeInsets.fromLTRB(110, 15, 10, 0),
                              child: ElevatedButton(
                                child: const Text('Sign Up', style: TextStyle(
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
                                onPressed: () async{
                                  if(formKey.currentState!.validate()){
                                    Map<String, String> users = {
                                      'Civil ID': civilIDController.text,
                                      'First Name': fNameController.text,
                                      'Last Name': lNameController.text,
                                      'Username': usernameController.text,
                                      'Email': emailController.text,
                                    };
                                    db.push().set(users);
                                    print(fNameController.text);
                                    print(lNameController.text);
                                    print(emailController.text);
                                    print(civilIDController.text);

                                    signUp(users);
                                  }

                                  else{
                                    return;
                                  }

                                },
                              )
                          )
                        ]
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Already Signed Up?'), Padding(padding: const EdgeInsets.fromLTRB(0, 10, 5, 5)),
                        TextButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserLogin()));//signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ))
        ),
    );
  }


  Future<bool> isCivilIDUnique(String civilID) async {
    var snapshot = await firestore
        .collection("user")
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

  Future signUp(Map<String, String> users) async{
    if(await isCivilIDUnique(civilIDController.text) && await isUsernameUnique(usernameController.text)){
      try{
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),);

        final userRef = firestore.collection('user');

        firestore.collection('user').
        doc(userCredential.user?.uid).set({
          'Civil ID': civilIDController.text,
          'First Name': fNameController.text,
          'Last Name': lNameController.text,
          'Username': usernameController.text,
          'Email': emailController.text,
          'uid': userCredential.user?.uid,
        });

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('You have been successfully signed up'),
              );
            }
        );
        if (!users.containsValue(emailController.text)) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('You have been successfully signed up'),
                );
              }
          );
        }
      }
      on FirebaseAuthException catch(e) {
        print(e);

        if (users.containsValue(emailController.text)) {
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
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(e.toString()),
                );
              }
          );
        }
      }
    }
    else if (!await isCivilIDUnique(civilIDController.text) && await isUsernameUnique(usernameController.text)){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('This Civil ID Already Exists'),
            );
          }
      );
    }
    else if (!await isUsernameUnique(usernameController.text) && await isCivilIDUnique(civilIDController.text)){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('This Username Already Exists'),
            );
          }
      );
    }
    else if(!await isCivilIDUnique(civilIDController.text) && !await isUsernameUnique(usernameController.text)){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Civil ID and Username Already Exist'),
            );
          }
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'KW');
    setState(() {
      this.number = number;
    });
  }
}

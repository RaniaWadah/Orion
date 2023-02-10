import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/HomePage.dart';
import 'package:untitled2/UserLogin.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


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
          backgroundColor: const Color(0x6FE8D298),
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
  TextEditingController confirmPassController = TextEditingController();
  late DatabaseReference db;
  late CollectionReference users;
  late User? currentUser;
  late CollectionReference userRef;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users1');
  late FirebaseFirestore firestore;

  final formKey = GlobalKey<FormState>();
  bool isVisible = true;
  bool _isVisible = true;

  @override
  void initState(){
    super.initState();
    db = FirebaseDatabase.instance.ref().child('users1');
    users = FirebaseFirestore.instance.collection('users1');
    currentUser = FirebaseAuth.instance.currentUser;
    userRef = FirebaseFirestore.instance.collection('users1');
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x6FE8D298),
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
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your First Name',
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your Last Name',
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email_sharp),
                          hintText: 'Enter your Email',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
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
                          else if(!value.contains('@')){
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
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your Civil ID',
                          labelText: 'Civil ID',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
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
                            return 'Please Enter a Valid Civil ID';
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
                          icon: Icon(Icons.lock_outline_sharp),
                          hintText: 'Enter your Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 55,
                      child: TextFormField(
                        obscureText: _isVisible,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline_sharp),
                          hintText: 'Re-enter your Password',
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                          suffixIcon: IconButton(
                            icon: _isVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () => {
                              setState((){
                                _isVisible =! _isVisible;
                              }
                              )
                            },
                          ),
                        ),
                        controller: confirmPassController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                        children:[
                          Padding (padding: const EdgeInsets.fromLTRB(110, 10, 10, 5),
                              child: ElevatedButton(
                                child: const Text('Sign Up', style: TextStyle(
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
                                onPressed: () async{
                                  if(formKey.currentState!.validate()){
                                    // signUp();
                                    Map<String, String> users1 = {
                                      'First Name': fNameController.text,
                                      'Last Name': lNameController.text,
                                      'Email': emailController.text,
                                      'Civil ID': civilIDController.text,
                                      'Password': passwordController.text,
                                      'Confirm Password': confirmPassController.text,
                                    };
                                    db.push().set(users1);
                                    print(fNameController.text);
                                    print(lNameController.text);
                                    print(emailController.text);
                                    print(civilIDController.text);
                                    print(passwordController.text);
                                    print(confirmPassController.text);

                                    signUp(users1);
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
  Future<bool> isUsernameUnique(String civilID) async {
    var snapshot = await firestore
        .collection("users1")
        .where("Civil ID", isEqualTo: civilID)
        .get();
    return !snapshot.docs.isNotEmpty;
  }

  Future signUp(Map<String, String> users1) async{
    if(await isUsernameUnique(civilIDController.text)){
      try{
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),);
        //     .then((value) =>
        // ref.child(value.user!.uid.toString()).set({
        //   'First Name': fNameController.text,
        //   'Last Name': lNameController.text,
        //   'Email': emailController.text,
        //   'Username': usernameController.text,
        //   'Password': passwordController.text,
        //   'Confirm Password': confirmPassController.text,
        //   'uid': value.user!.uid.toString(),
        // })
        // );
        print(userCredential.user?.uid);
        CollectionReference userRef = FirebaseFirestore.instance.collection('users1');
        // userRef.add({
        //   'First Name': fNameController.text,
        //   'Last Name': lNameController.text,
        //   'Email': emailController.text,
        //   'Username': usernameController.text,
        //   'Password': passwordController.text,
        //   'uid': userCredential.user?.uid,
        // }).then((value) => print("User Added"))
        //     .catchError((error) => print("Failed to add user: $error"));

        userRef.doc(userCredential.user?.uid)
            .set({
          'First Name': fNameController.text,
          'Last Name': lNameController.text,
          'Email': emailController.text,
          'Civil ID': civilIDController.text,
          'Password': passwordController.text,
          'uid': userCredential.user?.uid,
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('You have been successfully signed up.'),
              );
            }
        );
        if (!users1.containsValue(emailController.text)) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('You have been successfully signed up.'),
                );
              }
          );
        }
      }
      on FirebaseAuthException catch(e) {
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         content: Text(e.message.toString()),
        //       );
        //     }
        // );
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
              content: Text('This Civil ID Already Exists.'),
            );
          }
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

}

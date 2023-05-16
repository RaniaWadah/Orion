import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/GetXPackage/GetXHelper.dart';
import 'package:untitled2/HomePage.dart';
import 'package:untitled2/UserForgotPass.dart';
import 'package:untitled2/UserSignup.dart';
import 'package:get/get.dart';


GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
class UserLogin extends StatelessWidget {


  const UserLogin({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
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
        body:
        StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center (child: CircularProgressIndicator());
              }
              else if(snapshot.hasError){
                return Center (child: Text('Something Went Wrong'));
              }
              else if(snapshot.hasData){
                return HomePageWidget();
              }
              else{
                return UserLoginWidget();
              }
            }
        )
      ),
    );
  }
}

class UserLoginWidget extends StatefulWidget {
  const UserLoginWidget({Key? key}) : super(key: key);


  @override
  State<UserLoginWidget> createState() => _UserLoginWidgetState();
}

class _UserLoginWidgetState extends State<UserLoginWidget> {
  TextEditingController controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isVisible = true;
  final GetXHelper getXHelper = Get.put(GetXHelper());

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    passwordController.dispose();
    super.dispose();
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
                      padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                      child: const Text(
                        '',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 90,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        onChanged: (text){
                          getXHelper.checkText(text);
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.person),
                          hintText: 'Enter your Username or Civil ID',
                          labelText: 'Username or Civil ID',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: controller,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        obscureText: _isVisible,
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
                        controller: passwordController,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(110, 10, 10, 0),
                            child: ElevatedButton(
                              onPressed: () async{
                                if(!formKey.currentState!.validate()){
                                  return;
                                }
                                else {
                                  if(getXHelper.login() == 1){
                                    final String civilID = controller.text.trim();
                                    final String password = passwordController.text.trim();

                                    if(civilID.isEmpty || password.isEmpty){
                                      print('This Field is Required');
                                    }
                                    else {
                                      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('user')
                                          .where('Civil ID', isEqualTo: civilID).get();
                                      if(snapshot.size != 0){
                                        try{
                                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                                            email: snapshot.docs[0]['Email'].toString(),
                                            password: password,
                                          );
                                          print(controller.text);
                                          print(passwordController.text);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text('You have been successfully logged in.'),
                                                );
                                              }
                                          );
                                        }
                                        on FirebaseAuthException catch (e) {
                                          if (e.code == 'wrong-password') {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text('The password is invalid'),
                                                  );
                                                }

                                            );
                                          }
                                          else{
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
                                      else{
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text('Civil ID is invalid'),
                                              );
                                            }

                                        );
                                      }
                                    }
                                    navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                  }
                                  else if(getXHelper.login() == 2){
                                    final String username = controller.text.trim();
                                    final String password = passwordController.text.trim();

                                    if(username.isEmpty || password.isEmpty){
                                      print('This Field is Required');
                                    }
                                    else {
                                      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('user')
                                          .where('Username', isEqualTo: username).get();
                                      if(snapshot.size != 0){
                                        try{
                                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                                            email: snapshot.docs[0]['Email'].toString(),
                                            password: password,
                                          );
                                          print(controller.text);
                                          print(passwordController.text);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text('You have been successfully logged in.'),
                                                );
                                              }
                                          );
                                        }
                                        on FirebaseAuthException catch (e) {
                                          if (e.code == 'wrong-password') {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text('The password is invalid'),
                                                  );
                                                }

                                            );
                                          }
                                          else{
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
                                      else{
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text('Username is invalid'),
                                              );
                                            }

                                        );
                                      }
                                    }
                                    navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                  }
                                  else if(getXHelper.login() == 0){
                                    return;
                                  }
                                }
                              },
                              child: const Text('Login', style: TextStyle(
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
                            )
                        )
                      ]
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserForgotPassWidget()));//forgot password screen
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Do not Have an Account?'),
                      TextButton(
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserSignup()));//signup screen
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
}



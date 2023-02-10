import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/UserForgotPass.dart';
import 'package:untitled2/HomePage.dart';
import 'package:untitled2/UserSignup.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
class UserLogin extends StatelessWidget {


  const UserLogin({Key? key}) : super(key: key);

  static const String _title = 'Orion';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  TextEditingController civilIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isVisible = true;
  final userRef = FirebaseFirestore.instance.collection('users1');

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    civilIDController.dispose();
    passwordController.dispose();
    super.dispose();
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
                      padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
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
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      obscureText: _isVisible,
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
                  Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(110, 15, 10, 10),
                            child: ElevatedButton(
                              onPressed: () async{
                                if(!formKey.currentState!.validate()){
                                  return;
                                }
                                else {
                                  final String civilID = civilIDController.text.trim();
                                  final String password = passwordController.text.trim();
                                  if(civilID.isEmpty || password.isEmpty){
                                    print('This Field is Required');
                                  }
                                  else {
                                    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users1')
                                        .where('Civil ID', isEqualTo: civilID).get();
                                    try{
                                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: snapshot.docs[0]['Email'].toString(),
                                        password: password,
                                      );
                                      print(civilIDController.text);
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
                                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                }
                              },
                              child: const Text('Login', style: TextStyle(
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
                            )
                        )
                      ]
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserForgotPass()));//forgot password screen
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


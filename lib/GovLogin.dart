import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/GovHome.dart';
import 'package:untitled2/GovForgotPass.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class GovLogin extends StatelessWidget {
  const GovLogin({Key? key}) : super(key: key);

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
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return GovHomeWidget();
              }
              else{
                return GovLoginWidget();
              }
            }
        )
      ),
    );
  }
}

class GovLoginWidget extends StatefulWidget {
  const GovLoginWidget({Key? key}) : super(key: key);

  @override
  State<GovLoginWidget> createState() => _GovLoginWidgetState();
}

class _GovLoginWidgetState extends State<GovLoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController IDController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isVisible = true;
  String? val = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    IDController.dispose();
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
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 90,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: Icon(Icons.person),
                          hintText: 'Enter your ID',
                          labelText: 'ID',
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                          errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10
                          ),
                        ),
                        controller: IDController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                            onPressed: () =>
                            {
                              setState(() {
                                _isVisible = !_isVisible;
                              }
                              )
                            },
                          ),
                        ),
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(110, 10, 10, 0),
                            child: ElevatedButton(
                              child: const Text('Login', style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(
                                      0xff02165c),
                                  minimumSize: Size(170, 45),
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                              ),
                              onPressed: () async {
                                if(!formKey.currentState!.validate()){
                                  return;
                                }
                                else {
                                  final String ID = IDController.text.trim();
                                  final String password = passwordController.text.trim();
                                  if(ID.isEmpty || password.isEmpty){
                                    print('This Field is Required');
                                  }
                                  else {
                                    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('government')
                                        .where('ID', isEqualTo: ID).get();
                                    if(snapshot.size != 0){
                                      try{
                                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: snapshot.docs[0]['Email'].toString(),
                                          password: password,
                                        );
                                        print(IDController.text);
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
                                        if(e.code == 'wrong-password'){
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
                                              content: Text('ID is invalid'),
                                            );
                                          }

                                      );
                                    }

                                  }
                                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                }
                              },
                            )
                        )
                      ]
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (
                                  context) => const GovForgotPassWidget())); //forgot password screen
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ))
      ),
    );
  }

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),);
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
}

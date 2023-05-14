import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserForgotPassWidget extends StatefulWidget {
  const UserForgotPassWidget({Key? key}) : super(key: key);

  @override
  State<UserForgotPassWidget> createState() => _UserForgotPassWidgetState();
}

class _UserForgotPassWidgetState extends State<UserForgotPassWidget> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const String _title = 'Orion';

  bool isEmailValid(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        body: Container(
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
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 60),
                        child: const Text(
                          '',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 90,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Color(0xfa34a0fa)), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
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
                          keyboardType: TextInputType.emailAddress,
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
                    ),
                    Row(
                      children:[
                        Padding (padding: const EdgeInsets.fromLTRB(75, 10, 10, 15),
                            child: ElevatedButton(
                              onPressed: () {
                                if(!formKey.currentState!.validate()){
                                  return;
                                }
                                else{
                                  verifyEmail();
                                }
                              },
                              child: const Text('Reset Password', style: TextStyle(
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
                      ],
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    );

  }
  Future verifyEmail() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
        print('Password Reset Email Sent');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Password Reset Email sent, please check your email'),
              );
            }

        );

      final FirebaseAuth _auth = FirebaseAuth.instance;
      User user = await _auth.currentUser!;

    }
    on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('This Email Does not Exist.\nNo user found for that email'),
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
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
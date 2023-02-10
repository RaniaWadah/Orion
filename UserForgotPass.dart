import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserForgotPass extends StatelessWidget {
  const UserForgotPass({Key? key}) : super(key: key);

  static const String _title = 'Orion';

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
        body: const UserForgotPassWidget(),
      ),
    );
  }
}

class UserForgotPassWidget extends StatefulWidget {
  const UserForgotPassWidget({Key? key}) : super(key: key);

  @override
  State<UserForgotPassWidget> createState() => _UserForgotPassWidgetState();
}

class _UserForgotPassWidgetState extends State<UserForgotPassWidget> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
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
                      'Forgot Password',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
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
                Row(
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(75, 15, 10, 10),
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
                              0xA121732E), minimumSize: Size(170, 45),
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
              content: Text('Password Reset Email sent, please check your email.'),
            );
          }

      );
    }
    on FirebaseAuthException catch (e){
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
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
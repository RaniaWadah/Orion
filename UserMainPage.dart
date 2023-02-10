import 'package:flutter/material.dart';
import 'package:untitled2/UserLogin.dart';
import 'package:untitled2/UserSignup.dart';


class UserMainPage extends StatelessWidget {
  const UserMainPage({Key? key}) : super(key: key);

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
        body: const UserWidget(),
      ),
    );
  }
}

class UserWidget extends StatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x6FE8D298),
      child: Padding(
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
                    'Do You Wish to Login or Sign Up?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Row(
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserLogin()));
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
                      ),
                    )
                  ]
              ),
              Row(
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(110, 15, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserSignup()));
                        },
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
                      ),
                    )
                  ]
              ),
            ],
          )),
    );
  }
}
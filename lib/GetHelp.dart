import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled2/UserHome.dart';
import 'package:untitled2/services/localNotification.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class GetHelp extends StatelessWidget {
  const GetHelp({Key? key}) : super(key: key);

  static const String _title = 'Orion';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: navigatorKey,
      home: Scaffold(
        body: const GetHelpWidget(),
      ),
    );
  }
}

class GetHelpWidget extends StatefulWidget {
  const GetHelpWidget({Key? key}) : super(key: key);
  @override
  State<GetHelpWidget> createState() => _GetHelpWidgetState();
}

class _GetHelpWidgetState extends State<GetHelpWidget> {
  late final localNotification _notificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationsPlugin = localNotification();
    _notificationsPlugin.initialize();
    // localNotification.initialize(_notificationsPlugin);
  }
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return Container(
      color: const Color(0x6FE8D298),
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 75, 10, 20),
                    child: const Text(
                      'Get Help',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          color: const Color(0x6FE8D298),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color(0x3B1D2429),
                              offset: Offset(0, -3),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                                      child: Text(
                                        'Are you sure you want to send help request?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Poppings',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                  children:[
                                    Padding (padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text('Your request has been successfully sent.'),
                                                );
                                              }
                                          );
                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => UserHome()));
                                          _notificationsPlugin.showNotification(
                                              id: 0, title: 'Get Help', body: 'Get Help Message Sent');
                                        },
                                        child: const Text('Send', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
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
                                    ),
                                    Padding (
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => UserHome()));
                                        },
                                        child: const Text('Cancel', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                        style: ElevatedButton.styleFrom(primary: const Color(
                                            0x9D151515), minimumSize: Size(170, 45),
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
                          ),
                        )
                    )
                )

              ],
            )),

      ),
    );

  }
}
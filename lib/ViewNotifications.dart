import 'package:flutter/material.dart';
import 'package:untitled2/FullContent.dart';


class ViewNotifications extends StatelessWidget {
  const ViewNotifications({Key? key}) : super(key: key);

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
        body: const ViewNotificationsWidget(),
      ),
    );
  }
}

class ViewNotificationsWidget extends StatefulWidget {
  const ViewNotificationsWidget({Key? key}) : super(key: key);
  @override
  State<ViewNotificationsWidget> createState() => _ViewNotificationsWidgetState();
}

class _ViewNotificationsWidgetState extends State<ViewNotificationsWidget> {

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
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
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Row(
                  children:[
                    Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('User location has been successfully sent to the drone to be flown.'),
                                );
                              }

                          );
                        },
                        child: const Text('Send Location', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45)),
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
                                  builder: (context) => const FullContent()));
                        },
                        child: const Text('Full Content', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                        ),
                        style: ElevatedButton.styleFrom(primary: const Color(
                            0xA121732E), minimumSize: Size(170, 45)),
                      ),
                    )
                  ]
              ),
            ],
          )),
    );
  }
}
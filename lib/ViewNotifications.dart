// import 'package:flutter/material.dart';
// import 'package:untitled2/FullContent.dart';
//
//
// class ViewNotifications extends StatelessWidget {
//   const ViewNotifications({Key? key}) : super(key: key);
//
//   static const String _title = 'Orion';
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.0),
//     child: AppBar(
//           title: Container(
//             width: 200,
//             alignment: Alignment.center,
//             child: Image.asset('images/Orion.png'),
//           ),
//           backgroundColor: const Color(0xFFB9CAE0),
//           elevation: 0.0,
//           titleSpacing: 10.0,
//           centerTitle: true,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         ),
//         body: const ViewNotificationsWidget(),
//       ),
//     );
//   }
// }
//
// class ViewNotificationsWidget extends StatefulWidget {
//   const ViewNotificationsWidget({Key? key}) : super(key: key);
//   @override
//   State<ViewNotificationsWidget> createState() => _ViewNotificationsWidgetState();
// }
//
// class _ViewNotificationsWidgetState extends State<ViewNotificationsWidget> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFB9CAE0),
//       child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: ListView(
//             children: <Widget>[
//               Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.all(10),
//               ),
//               Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
//                   child: const Text(
//                     'Notifications',
//                     style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                   )),
//               Row(
//                   children:[
//                     Padding (padding: const EdgeInsets.fromLTRB(110, 50, 10, 10),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   content: Text('User location has been successfully sent to the drone to be flown.'),
//                                 );
//                               }
//
//                           );
//                         },
//                         child: const Text('Send Location', style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//
//                         ),
//                         ),
//                         style: ElevatedButton.styleFrom(primary: const Color(
//                             0xff02165c), minimumSize: Size(170, 45)),
//                       ),
//                     )
//                   ]
//               ),
//               Row(
//                   children:[
//                     Padding (padding: const EdgeInsets.fromLTRB(110, 15, 10, 10),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const FullContent()));
//                         },
//                         child: const Text('Full Content', style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//
//                         ),
//                         ),
//                         style: ElevatedButton.styleFrom(primary: const Color(
//                             0xff02165c), minimumSize: Size(170, 45)),
//                       ),
//                     )
//                   ]
//               ),
//             ],
//           )),
//     );
//   }
// }

import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/GovHome.dart';
import 'Noti_details.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';


class ButtonTimerModel extends ChangeNotifier {
  Map<int, bool> _isButtonDisabledMap = {};

  bool isButtonDisabled(int index) {
    return _isButtonDisabledMap[index] ?? false;
  }

  void setButtonDisabled(int index, bool isDisabled) {
    _isButtonDisabledMap[index] = isDisabled;
    notifyListeners();
  }
}

class ViewNotifications extends StatefulWidget {
  const ViewNotifications({super.key});

  @override
  State<ViewNotifications> createState() => _ViewNotificationsState();
}

class _ViewNotificationsState extends State<ViewNotifications> with AutomaticKeepAliveClientMixin<ViewNotifications>{
  @override
  bool get wantKeepAlive => true;
  final newRecordRef = FirebaseDatabase.instance.ref().child('userNotifications');
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
  FirebaseFirestore.instance.collection("userNotifications").snapshots();
  Timer? _timer;
  final ValueNotifier<bool> _sendLocationState = ValueNotifier<bool>(false);
  Timer? _countdownTimer;
  final ValueNotifier<int> _timeLeft = ValueNotifier<int>(0);

  // late SharedPreferences _prefs;

  Future _init() async {
    final sendLocationTime = (await SharedPreferences.getInstance()).getInt('send_location_time');
    if (sendLocationTime != null) {
      final duration = sendLocationTime - DateTime
          .now()
          .millisecondsSinceEpoch;
      if (duration > 0) {
        _timeLeft.value = duration;
        _timer = Timer(Duration(milliseconds: duration), _handleTimeout);
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _timeLeft.value = _timeLeft.value - 1000;
        });
        return;
      }
    }

    _sendLocationState.value = true;
  }

  void _handleTimeout() {
    _sendLocationState.value = true;
    _timer?.cancel();
    _countdownTimer?.cancel();
  }

  String _getButtonLabel(bool enabled, int timeLeft) {
    if (enabled) {
      return 'Send';
    }

    if (timeLeft <= 0) {
      return '00 : 00';
    }

    if (timeLeft <= 1000) {
      return '00 : 01';
    }

    final minute = ((timeLeft / 1000) ~/ 60).toString().padLeft(2, '0');
    final second = (((timeLeft / 1000) % 60).toInt()).toString().padLeft(
        2, '0');
    return '$minute : $second';
  }

  @override
  void initState() {
    super.initState();
    _init();
    // SharedPreferences.getInstance().then((prefs) {
    //   setState(() {
    //     _prefs = prefs;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _countdownTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
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
          child: Column(
            children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(5, 20, 10, 22),
              child: const Text('Notifications',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              Expanded(
                child: ChangeNotifierProvider(
                  create: (context) => ButtonTimerModel(),
                  child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('userNotifications')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          child: CircularProgressIndicator(),
                                          height: 50.0,
                                          width: 50.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                              default:
                                List<DocumentSnapshot> documents = snapshot.data!.docs;
                                // List<bool> _buttonDisabledList = List.generate(documents.length, (_) => false);

                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: documents.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ListTile(
                                      leading: Icon(Icons.crisis_alert),
                                      title: Text(
                                        documents[index]['Title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 220,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                              StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState) {
                                                  return Consumer<ButtonTimerModel>(
                                                    builder: (context, buttonTimerModel, child) {
                                                      final isButtonDisabled = buttonTimerModel.isButtonDisabled(index);
                                                      if (!isButtonDisabled) {
                                                        return ElevatedButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  content: Text(
                                                                    'User location has been successfully sent to the drone to be flown',
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                            buttonTimerModel.setButtonDisabled(index, true);
                                                          },
                                                          child: const Text('Send Location', textAlign: TextAlign.center),
                                                          style: ElevatedButton.styleFrom(
                                                            primary: const Color(0xff02165c),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return ElevatedButton(
                                                          onPressed: () async {
                                                            null;
                                                          },
                                                          child: Countdown(
                                                            seconds: 600,
                                                            build: (_, double time) {
                                                              int minutes = time ~/ 60;
                                                              int seconds = time.toInt() % 60;
                                                              return Text(
                                                                '$minutes : ${seconds.toString().padLeft(2, '0')}',
                                                                textAlign: TextAlign.center,
                                                              );
                                                            },
                                                            interval: const Duration(seconds: 1),
                                                            onFinished: () {
                                                              buttonTimerModel.setButtonDisabled(index, false);
                                                            },
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Colors.grey,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                child: Text("Full Content",
                                                  textAlign: TextAlign.center,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color(0xff02165c),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => details(index: index)
                                                      )
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                            }
                          },
                        );
                      }),
                ),
              ),
              Padding (padding: const EdgeInsets.fromLTRB(3, 15, 10, 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GovHome(),
                        ));
                  },
                  child: const Text('Home', style: TextStyle(
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
                ),
              ),
            ],
          ),
        )));
  }
}

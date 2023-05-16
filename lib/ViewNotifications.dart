import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/GovHome.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:untitled2/CheckRecordings.dart';
import 'package:untitled2/GiveAlarm.dart';
import 'package:untitled2/Identify.dart';
import 'package:untitled2/ProvideSafetyMessage.dart';
import 'package:untitled2/StartRecording.dart';
import 'package:untitled2/Track.dart';

enum ItemState {
  solved,
  inProgress,
  notSolved
}

class ButtonTimerModel extends ChangeNotifier {
  Map<int, bool> _isButtonDisabledMap = {};
  Map<int, ItemState> _itemStateMap = {}; // new map to track item states

  bool isButtonDisabled(int index) {
    return _isButtonDisabledMap[index] ?? false;
  }

  void setButtonDisabled(int index, bool isDisabled, ItemState? itemState) {
    _isButtonDisabledMap[index] = isDisabled;
    if (itemState != null) { // set item state if provided
      _itemStateMap[index] = itemState;
    }
    notifyListeners();
  }

  ItemState getItemState(int index) {
    return _itemStateMap[index] ?? ItemState.notSolved; // default state is notSolved
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

  getDateTime(String dateTime){
    DateTime dt = DateTime.parse(dateTime);
    String formattedDate = DateFormat.yMd().add_jm().format(dt);
    return formattedDate;
  }

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

  @override
  void initState() {
    super.initState();
    _init();}

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
        debugShowCheckedModeBanner: false,
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
                                List doc = documents.toList();
                                doc.sort((a, b) {
                                  return b["Date and Time"].compareTo(a["Date and Time"]);
                                });

                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: doc.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {
                                          return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setState) {
                                                return Consumer <
                                                    ButtonTimerModel>(
                                                    builder: (context,
                                                        buttonTimerModel, child) {
                                                      print(buttonTimerModel
                                                          .getItemState(index));
                                                      if (buttonTimerModel
                                                          .getItemState(index) ==
                                                          ItemState.notSolved) {
                                                        return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                            child: Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .crisis_alert,
                                                                    color: Colors
                                                                        .red[500],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 6,),
                                                                  Expanded(
                                                                    child:
                                                                    Text(
                                                                      'Not Resolved',
                                                                      textAlign: TextAlign
                                                                          .left,
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .red[500],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 1),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                    doc[index]['Title'] ==
                                                                        'Report a Problem'
                                                                        ?
                                                                    Text(
                                                                      'Problem Reported on ' +
                                                                          getDateTime(
                                                                              doc[index]['Date and Time']),
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    )
                                                                        :
                                                                    Text(
                                                                      'Help Requested on ' +
                                                                          getDateTime(
                                                                              doc[index]['Date and Time']),
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,),
                                                                  Expanded(
                                                                    child:
                                                                    StatefulBuilder(
                                                                      builder: (
                                                                          BuildContext context,
                                                                          StateSetter setState) {
                                                                        return Consumer <
                                                                            ButtonTimerModel>(
                                                                          builder: (
                                                                              context,
                                                                              buttonTimerModel,
                                                                              child) {
                                                                            final isButtonDisabled = buttonTimerModel
                                                                                .isButtonDisabled(
                                                                                index);
                                                                            if (!isButtonDisabled) {
                                                                              return ElevatedButton(
                                                                                onPressed: () async {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        context) {
                                                                                      return AlertDialog(
                                                                                        content: Text(
                                                                                          'User location has been successfully sent to the drone to be flown',
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                  buttonTimerModel
                                                                                      .setButtonDisabled(
                                                                                      index,
                                                                                      true,
                                                                                      ItemState
                                                                                          .inProgress);
                                                                                },
                                                                                child: const Text(
                                                                                    'Send Drone',
                                                                                    textAlign: TextAlign
                                                                                        .center),
                                                                                style: ElevatedButton
                                                                                    .styleFrom(
                                                                                  primary: const Color(
                                                                                      0xff02165c),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        20),
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
                                                                                  build: (
                                                                                      _,
                                                                                      double time) {
                                                                                    int minutes = time ~/
                                                                                        60;
                                                                                    int seconds = time
                                                                                        .toInt() %
                                                                                        60;
                                                                                    return Text(
                                                                                      '$minutes : ${seconds
                                                                                          .toString()
                                                                                          .padLeft(
                                                                                          2,
                                                                                          '0')}',
                                                                                      textAlign: TextAlign
                                                                                          .center,
                                                                                    );
                                                                                  },
                                                                                  interval: const Duration(
                                                                                      seconds: 1),
                                                                                  onFinished: () {
                                                                                    buttonTimerModel
                                                                                        .setButtonDisabled(
                                                                                        index,
                                                                                        false,
                                                                                        ItemState
                                                                                            .inProgress);
                                                                                  },
                                                                                ),
                                                                                style: ElevatedButton
                                                                                    .styleFrom(
                                                                                  primary: Colors
                                                                                      .grey,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        20),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                    child: StatefulBuilder(
                                                                        builder: (
                                                                            BuildContext context,
                                                                            StateSetter setState) {
                                                                          return Consumer <
                                                                              ButtonTimerModel>(
                                                                              builder: (
                                                                                  context,
                                                                                  buttonTimerModel,
                                                                                  child) {
                                                                                return ElevatedButton(
                                                                                  child: Text(
                                                                                    "Full Content",
                                                                                    textAlign: TextAlign
                                                                                        .center,
                                                                                  ),
                                                                                  style: ElevatedButton
                                                                                      .styleFrom(
                                                                                    primary: const Color(
                                                                                        0xff02165c),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          20),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    final state = Provider
                                                                                        .of<
                                                                                        ButtonTimerModel>(
                                                                                        context,
                                                                                        listen: false);
                                                                                    print(
                                                                                        buttonTimerModel
                                                                                            .getItemState(
                                                                                            index));
                                                                                    bool solved = await Navigator
                                                                                        .push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (
                                                                                                context) =>
                                                                                                details(
                                                                                                    index: index,
                                                                                                    isDisabled: buttonTimerModel
                                                                                                        .isButtonDisabled(
                                                                                                        index),
                                                                                                    itemState: state
                                                                                                        .getItemState(
                                                                                                        index))
                                                                                        )
                                                                                    );

                                                                                    if (solved ==
                                                                                        true) {
                                                                                      buttonTimerModel
                                                                                          .setButtonDisabled(
                                                                                          index,
                                                                                          true,
                                                                                          ItemState
                                                                                              .solved);
                                                                                    }
                                                                                  },
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                    ),

                                                                  ),
                                                                ]
                                                            )
                                                        );
                                                      }
                                                      else if (buttonTimerModel
                                                          .getItemState(index) ==
                                                          ItemState.inProgress) {
                                                        return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                            child: Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .crisis_alert,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 6,),
                                                                  Expanded(
                                                                    child:
                                                                    Text(
                                                                      'In Progress',
                                                                      textAlign: TextAlign
                                                                          .left,
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 1),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                    doc[index]['Title'] ==
                                                                        'Report a Problem'
                                                                        ?
                                                                    Text(
                                                                      'Problem Reported on ' +
                                                                          getDateTime(
                                                                              doc[index]['Date and Time']),
                                                                      // doc[index]['Date and Time'],
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    )
                                                                        :
                                                                    Text(
                                                                      'Help Requested on ' +
                                                                          getDateTime(
                                                                              doc[index]['Date and Time']),
                                                                      // doc[index]['Date and Time'],
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,),
                                                                  Expanded(
                                                                    child:
                                                                    StatefulBuilder(
                                                                      builder: (
                                                                          BuildContext context,
                                                                          StateSetter setState) {
                                                                        return Consumer <
                                                                            ButtonTimerModel>(
                                                                          builder: (
                                                                              context,
                                                                              buttonTimerModel,
                                                                              child) {
                                                                            final isButtonDisabled = buttonTimerModel
                                                                                .isButtonDisabled(
                                                                                index);
                                                                            if (!isButtonDisabled) {
                                                                              return ElevatedButton(
                                                                                onPressed: () async {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        context) {
                                                                                      return AlertDialog(
                                                                                        content: Text(
                                                                                          'User location has been successfully sent to the drone to be flown',
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                  buttonTimerModel
                                                                                      .setButtonDisabled(
                                                                                      index,
                                                                                      true,
                                                                                      ItemState
                                                                                          .inProgress);
                                                                                },
                                                                                child: const Text(
                                                                                    'Send Drone',
                                                                                    textAlign: TextAlign
                                                                                        .center),
                                                                                style: ElevatedButton
                                                                                    .styleFrom(
                                                                                  primary: const Color(
                                                                                      0xff02165c),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        20),
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
                                                                                  build: (
                                                                                      _,
                                                                                      double time) {
                                                                                    int minutes = time ~/
                                                                                        60;
                                                                                    int seconds = time
                                                                                        .toInt() %
                                                                                        60;
                                                                                    return Text(
                                                                                      '$minutes : ${seconds
                                                                                          .toString()
                                                                                          .padLeft(
                                                                                          2,
                                                                                          '0')}',
                                                                                      textAlign: TextAlign
                                                                                          .center,
                                                                                    );
                                                                                  },
                                                                                  interval: const Duration(
                                                                                      seconds: 1),
                                                                                  onFinished: () {
                                                                                    buttonTimerModel
                                                                                        .setButtonDisabled(
                                                                                        index,
                                                                                        false,
                                                                                        ItemState
                                                                                            .inProgress);
                                                                                  },
                                                                                ),
                                                                                style: ElevatedButton
                                                                                    .styleFrom(
                                                                                  primary: Colors
                                                                                      .grey,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        20),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                    child: StatefulBuilder(
                                                                        builder: (
                                                                            BuildContext context,
                                                                            StateSetter setState) {
                                                                          return Consumer <
                                                                              ButtonTimerModel>(
                                                                              builder: (
                                                                                  context,
                                                                                  buttonTimerModel,
                                                                                  child) {

                                                                                return ElevatedButton(
                                                                                  child: Text(
                                                                                    "Full Content",
                                                                                    textAlign: TextAlign
                                                                                        .center,
                                                                                  ),
                                                                                  style: ElevatedButton
                                                                                      .styleFrom(
                                                                                    primary: const Color(
                                                                                        0xff02165c),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          20),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    final state = Provider
                                                                                        .of<
                                                                                        ButtonTimerModel>(
                                                                                        context,
                                                                                        listen: false);
                                                                                    print(
                                                                                        buttonTimerModel
                                                                                            .getItemState(
                                                                                            index));
                                                                                    bool solved = await Navigator
                                                                                        .push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (
                                                                                                context) =>
                                                                                                details(
                                                                                                    index: index,
                                                                                                    isDisabled: buttonTimerModel
                                                                                                        .isButtonDisabled(
                                                                                                        index),
                                                                                                    itemState: state
                                                                                                        .getItemState(
                                                                                                        index))
                                                                                        )
                                                                                    );

                                                                                    if (solved ==
                                                                                        true) {
                                                                                      buttonTimerModel
                                                                                          .setButtonDisabled(
                                                                                          index,
                                                                                          true,
                                                                                          ItemState
                                                                                              .solved);
                                                                                    }
                                                                                  },
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                    ),

                                                                  ),
                                                                ]
                                                            )
                                                        );
                                                      }
                                                     else {
                                                        return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                            child: Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .crisis_alert,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 6,),
                                                                  Expanded(
                                                                    child:
                                                                    Text(
                                                                      'Resolved',
                                                                      textAlign: TextAlign
                                                                          .left,
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 1),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                    doc[index]['Title'] ==
                                                                        'Report a Problem'
                                                                        ?
                                                                    Text(
                                                                      'Problem Reported on ' +
                                                                          getDateTime(
                                                                              doc[index]['Date and Time']),
                                                                      // doc[index]['Date and Time'],
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    )
                                                                        :
                                                                    Text(
                                                                      'Help Requested on ' +
                                                                          getDateTime(
                                                                              doc[index]['Date and Time']),
                                                                      // doc[index]['Date and Time'],
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,),
                                                                  Expanded(
                                                                    child:
                                                                    StatefulBuilder(
                                                                      builder: (
                                                                          BuildContext context,
                                                                          StateSetter setState) {
                                                                        return Consumer <
                                                                            ButtonTimerModel>(
                                                                          builder: (
                                                                              context,
                                                                              buttonTimerModel,
                                                                              child) {
                                                                            final isButtonDisabled = buttonTimerModel
                                                                                .isButtonDisabled(
                                                                                index);
                                                                            // print(buttonTimerModel.getItemState(index));
                                                                            if (!isButtonDisabled) {
                                                                              return ElevatedButton(
                                                                                onPressed: () async {
                                                                                  // await _updateFlagState(index);
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        context) {
                                                                                      return AlertDialog(
                                                                                        content: Text(
                                                                                          'User location has been successfully sent to the drone to be flown',
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                  buttonTimerModel
                                                                                      .setButtonDisabled(
                                                                                      index,
                                                                                      true,
                                                                                      ItemState
                                                                                          .inProgress);
                                                                                  // print(buttonTimerModel.getItemState(index));
                                                                                },
                                                                                child: const Text(
                                                                                    'Send Drone',
                                                                                    textAlign: TextAlign
                                                                                        .center),
                                                                                style: ElevatedButton
                                                                                    .styleFrom(
                                                                                  primary: const Color(
                                                                                      0xff02165c),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        20),
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
                                                                                  build: (
                                                                                      _,
                                                                                      double time) {
                                                                                    int minutes = time ~/
                                                                                        60;
                                                                                    int seconds = time
                                                                                        .toInt() %
                                                                                        60;
                                                                                    return Text(
                                                                                      '$minutes : ${seconds
                                                                                          .toString()
                                                                                          .padLeft(
                                                                                          2,
                                                                                          '0')}',
                                                                                      textAlign: TextAlign
                                                                                          .center,
                                                                                    );
                                                                                  },
                                                                                  interval: const Duration(
                                                                                      seconds: 1),
                                                                                  onFinished: () {
                                                                                    buttonTimerModel
                                                                                        .setButtonDisabled(
                                                                                        index,
                                                                                        false,
                                                                                        ItemState
                                                                                            .inProgress);
                                                                                  },
                                                                                ),
                                                                                style: ElevatedButton
                                                                                    .styleFrom(
                                                                                  primary: Colors
                                                                                      .grey,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        20),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                    child: StatefulBuilder(
                                                                        builder: (
                                                                            BuildContext context,
                                                                            StateSetter setState) {
                                                                          return Consumer <
                                                                              ButtonTimerModel>(
                                                                              builder: (
                                                                                  context,
                                                                                  buttonTimerModel,
                                                                                  child) {
                                                                                // final isButtonDisabled = buttonTimerModel
                                                                                //     .isButtonDisabled(index);
                                                                                // print(buttonTimerModel.getItemState(index));
                                                                                return ElevatedButton(
                                                                                  child: Text(
                                                                                    "Full Content",
                                                                                    textAlign: TextAlign
                                                                                        .center,
                                                                                  ),
                                                                                  style: ElevatedButton
                                                                                      .styleFrom(
                                                                                    primary: const Color(
                                                                                        0xff02165c),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                          20),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    final state = Provider
                                                                                        .of<
                                                                                        ButtonTimerModel>(
                                                                                        context,
                                                                                        listen: false);
                                                                                    print(
                                                                                        buttonTimerModel
                                                                                            .getItemState(
                                                                                            index));
                                                                                    bool solved = await Navigator
                                                                                        .push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (
                                                                                                context) =>
                                                                                                details(
                                                                                                    index: index,
                                                                                                    isDisabled: buttonTimerModel
                                                                                                        .isButtonDisabled(
                                                                                                        index),
                                                                                                    itemState: state
                                                                                                        .getItemState(
                                                                                                        index))
                                                                                        )
                                                                                    );

                                                                                    if (solved ==
                                                                                        true) {
                                                                                      buttonTimerModel
                                                                                          .setButtonDisabled(
                                                                                          index,
                                                                                          true,
                                                                                          ItemState
                                                                                              .solved);
                                                                                    }
                                                                                  },
                                                                                );
                                                                              }
                                                                          );
                                                                        }
                                                                    ),

                                                                  ),
                                                                ]
                                                            )
                                                        );
                                                        // return  Icon(Icons.crisis_alert,
                                                        //     color: Colors.red[500],
                                                        // );
                                                      }
                                                    }
                                                );
                                              }
                                          );
                                        }
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

class details extends StatefulWidget {
  final int index;
  final bool isDisabled;
  final ItemState itemState;
  details(
      {required this.index, required this.isDisabled, required this.itemState, super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {

  int? i;
  bool? disabled;
  ItemState? state;

  bool isSolved = false;

  @override
  void initState() {
    super.initState();
    i = widget.index;
    disabled = widget.isDisabled;
    state = widget.itemState;
  }


  @override
  Widget build(BuildContext context) {
    print(disabled);
    return Scaffold(
      backgroundColor: Color(0xFFB9CAE0),
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
              Navigator.pop(context, isSolved);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
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
                          return ListView(
                            padding: EdgeInsets.all(20.0),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 40, 8, 25),
                                child: Text(
                                  "${documents[i!]['Title']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              documents[i!]['Title'] == 'Report a Problem'?
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Category: ${documents[i!]['Category']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ):
                              Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Description: ${documents[i!]['Description']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              documents[i!]['Title'] == 'Report a Problem'?
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: documents[i!]['Image']!.isEmpty ? Container()
                                    : Container(
                                    height: MediaQuery.of(context).size.height *0.28,
                                    decoration: BoxDecoration(
                                    ),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      children: List.generate(documents[i!]['Image']!.length, (i){
                                        return Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image.file(
                                                    File(documents[i]['Image']![i]),
                                                    fit: BoxFit.fill),
                                              ],

                                            ),

                                          ),
                                        );
                                      }),
                                    )
                                ),
                              ):
                              Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Sender Civil ID: ${documents[i!]['Sender Civil ID']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Date and Time: ${documents[i!]['Date and Time']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Location: ${documents[i!]['Location']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                      }
                    },
                  );
                }),
          ),
          Padding (padding: const EdgeInsets.fromLTRB(3, 30, 10, 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, isSolved);
              },
              child: const Text('Back', style: TextStyle(
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
          IconTheme(
            data: IconThemeData(size: 22.0, color: Colors.white),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 40),
                    child:
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Container(
                              width: 70,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(disabled!){
                                    print(state);
                                    if(state == ItemState.notSolved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.notSolved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });

                                      // ItemState.notSolved;
                                    }
                                    else if(state == ItemState.inProgress){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });

                                      print(state);
                                    }
                                    else if(state == ItemState.solved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });

                                    }
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Track()));
                                },
                                child: Icon( // <-- Icon
                                  Icons.location_searching,
                                  size: 29.0,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(
                                        0xff02165c),
                                    padding: EdgeInsets.fromLTRB(16, 13, 20, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ), // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Container(
                              width: 70,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(disabled!){
                                    print(state);
                                    if(state == ItemState.notSolved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.notSolved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });

                                      // ItemState.notSolved;
                                    }
                                    else if(state == ItemState.inProgress){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });

                                      print(state);
                                    }
                                    else if(state == ItemState.solved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });

                                    }
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const StartRecording()));
                                },
                                child: Icon( // <-- Icon
                                  Icons.video_camera_back_sharp,
                                  size: 29.0,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(
                                        0xff02165c),
                                    padding: EdgeInsets.fromLTRB(16, 13, 20, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ), // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Container(
                              width: 70,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(disabled!){
                                    if(state == ItemState.notSolved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.notSolved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });
                                    }
                                    else if(state == ItemState.inProgress){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });
                                    }
                                    else if(state == ItemState.solved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckRecordings()));
                                },
                                child: Icon( // <-- Icon
                                  Icons.video_collection_sharp,
                                  size: 29.0,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(
                                        0xff02165c),
                                    padding: EdgeInsets.fromLTRB(16, 13, 20, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ), // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Container(
                              width: 70,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(disabled!){
                                    if(state == ItemState.notSolved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.notSolved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });
                                    }
                                    else if(state == ItemState.inProgress){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                    else if(state == ItemState.solved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const GiveAlarm()));
                                },
                                child: Icon( // <-- Icon
                                  Icons.alarm_add_sharp,
                                  size: 33.0,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(
                                        0xff02165c),
                                    padding: EdgeInsets.fromLTRB(13.5, 12, 20, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ), // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Container(
                              width: 70,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(disabled!){
                                    if(state == ItemState.notSolved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.notSolved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });
                                    }
                                    else if(state == ItemState.inProgress){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                    else if(state == ItemState.solved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SpeakerPage()));
                                },
                                child: Icon( // <-- Icon
                                  Icons.keyboard_voice_sharp,
                                  size: 34.0,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(
                                        0xff02165c),
                                    padding: EdgeInsets.fromLTRB(13.5, 10, 20, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ), // <-- Text
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Container(
                              width: 70,
                              height: 55,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if(disabled!){
                                    if(state == ItemState.notSolved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.notSolved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = false;
                                      });
                                    }
                                    else if(state == ItemState.inProgress){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                    else if(state == ItemState.solved){
                                      final iState = Provider.of<ButtonTimerModel>(context, listen: false);
                                      iState.setButtonDisabled(i!, disabled!, ItemState.solved);
                                      setState(() {
                                        state = iState.getItemState(i!);
                                        isSolved = true;
                                      });
                                    }
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Identify()));
                                },
                                child: Icon( // <-- Icon
                                  Icons.add_a_photo_sharp,
                                  size: 31.0,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(
                                        0xff02165c),
                                    padding: EdgeInsets.fromLTRB(14, 11, 20, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                ), // <-- Text
                              ),
                            ),
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
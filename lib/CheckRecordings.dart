import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class CheckRecordings extends StatelessWidget {
  const CheckRecordings({Key? key}) : super(key: key);


  static const String _title = 'Orion';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      // navigatorKey: navigatorKey,
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
        body: const CheckRecordingsWidget(),
      ),
    );
  }
}

class CheckRecordingsWidget extends StatefulWidget {

  const CheckRecordingsWidget({Key? key}) : super(key: key);

  @override
  State<CheckRecordingsWidget> createState() => _CheckRecordingsWidgetState();
}
class _CheckRecordingsWidgetState extends State<CheckRecordingsWidget> {
  VideoPlayerController? _controller;
  final firestore = FirebaseFirestore.instance;
  final cUser = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB9CAE0),
      child: Scaffold(
        backgroundColor: const Color(0xFFB9CAE0),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Center(child: Text(
                  'Recordings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )
                )
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Recordings').snapshots(),

                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      var url = document['Video'].toString();
                      YoutubePlayerController _controller = YoutubePlayerController(
                          initialVideoId: YoutubePlayer.convertUrlToId(url)!,
                          flags: const YoutubePlayerFlags(
                              useHybridComposition: false,
                              mute: false,
                              autoPlay: false,
                              disableDragSeek: true,
                              loop: false,
                              isLive: false,
                              forceHD: false,
                              enableCaption: false,
                              showLiveFullscreenButton: false,
                          ),
                        );
                      // YoutubePlayerController _controller = YoutubePlayerController(
                      //   initialVideoId: YoutubePlayer.convertUrlToId(url)!,
                      //   flags: YoutubePlayerFlags(
                      //     autoPlay: false,
                      //     mute: true,
                      //     disableDragSeek: false,
                      //     loop: false,
                      //     isLive: false,
                      //     forceHD: false,
                      //   ),
                      // );
                      return Center(
                          child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text('Date and Time: '+ DateTime.fromMicrosecondsSinceEpoch(document['Date and Time'].microsecondsSinceEpoch).toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text('Location: '+ document['Location'].toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  child: YoutubePlayer(
                                    controller: _controller,
                                    showVideoProgressIndicator: true,
                                  ),
                                ),
                              ]
                          )
                      );
                    }
                    ).toList(),
                  );
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}


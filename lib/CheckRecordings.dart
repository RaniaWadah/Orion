// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
//
// class CheckRecordings extends StatelessWidget {
//   const CheckRecordings({Key? key}) : super(key: key);
//
//
//   static const String _title = 'Orion';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       // navigatorKey: navigatorKey,
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
//         body: const CheckRecordingsWidget(),
//       ),
//     );
//   }
// }
//
// class CheckRecordingsWidget extends StatefulWidget {
//
//   const CheckRecordingsWidget({Key? key}) : super(key: key);
//
//   @override
//   State<CheckRecordingsWidget> createState() => _CheckRecordingsWidgetState();
// }
// class _CheckRecordingsWidgetState extends State<CheckRecordingsWidget> {
//   VideoPlayerController? _controller;
//   final firestore = FirebaseFirestore.instance;
//   final cUser = FirebaseAuth.instance;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFB9CAE0),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFB9CAE0),
//         body: Column(
//           children: [
//             Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
//                 child: Center(child: Text(
//                   'Recordings',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 25,
//                   ),
//                 )
//                 )
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance.collection('Recordings').snapshots(),
//
//                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//
//                   return ListView(
//                     children: snapshot.data!.docs.map((document) {
//                       var url = document['Video'].toString();
//                       VideoPlayerController.network(url);
//                       // YoutubePlayerController _controller = YoutubePlayerController(
//                       //     initialVideoId: YoutubePlayer.convertUrlToId(url)!,
//                       //     flags: const YoutubePlayerFlags(
//                       //         useHybridComposition: false,
//                       //         mute: false,
//                       //         autoPlay: false,
//                       //         disableDragSeek: true,
//                       //         loop: false,
//                       //         isLive: false,
//                       //         forceHD: false,
//                       //         enableCaption: false,
//                       //         showLiveFullscreenButton: false,
//                       //     ),
//                       //   );
//                       // YoutubePlayerController _controller = YoutubePlayerController(
//                       //   initialVideoId: YoutubePlayer.convertUrlToId(url)!,
//                       //   flags: YoutubePlayerFlags(
//                       //     autoPlay: false,
//                       //     mute: true,
//                       //     disableDragSeek: false,
//                       //     loop: false,
//                       //     isLive: false,
//                       //     forceHD: false,
//                       //   ),
//                       // );
//                       return Center(
//                           child: Column(
//                               children: <Widget>[
//                                 Padding(
//                                     padding: EdgeInsets.only(top: 20),
//                                     child: Text('Date and Time: '+ document['Date and Time'].toString(),
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     )
//                                 ),
//                                 Padding(
//                                     padding: EdgeInsets.only(bottom: 5),
//                                     child: Text('Location: '+ document['Location'].toString(),
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     )
//                                 ),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width / 1.2,
//                                   child:
//                                   VideoPlayer(_controller!),
//                                 ),
//                               ]
//                           )
//                       );
//                     }
//                     ).toList(),
//                   );
//                 },
//               ),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// //
// // class CheckRecordings extends StatelessWidget {
// //   // Create the initialization Future outside of build
// //   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
// //
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //         future: _initialization,
// //         builder: (context, snapshot) {
// //           // Check for error
// //           if (snapshot.hasError) {
// //             print(snapshot.error);
// //             return Center(
// //               child: Container(
// //                 child: Text(
// //                   "Something went wrong",
// //                   textDirection: TextDirection.ltr,
// //                 ),
// //               ),
// //             );
// //           }
// //
// //           //Once complete, show your application
// //           if (snapshot.connectionState == ConnectionState.done) {
// //             return MaterialApp(
// //               title: 'Flutter Demo',
// //               home: CheckRecordingsScreen(),
// //             );
// //           }
// //
// //           return CircularProgressIndicator();
// //         });
// //   }
// // }
// //
// // class CheckRecordingsScreen extends StatefulWidget {
// //
// //   @override
// //   _CheckRecordingsScreenState createState() => _CheckRecordingsScreenState();
// // }
// //
// // class _CheckRecordingsScreenState extends State<CheckRecordingsScreen> {
// //   VideoPlayerController? _controller;
// //   Future<void>? _initializeVideoPlayerFuture;
// //   FirebaseFirestore firestore = FirebaseFirestore.instance;
// //   String videoUrl =
// //       'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
// //
// //   @override
// //   void initState() {
// //     firestore.collection("Recordings").get().then((QuerySnapshot querySnapshot) => {
// //     querySnapshot.docs.forEach((doc) {
// //     videoUrl = doc["Video"];
// //     _controller = VideoPlayerController.network(videoUrl);
// //     _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
// //     setState(() {});
// //     });
// //     })
// //     });
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller!.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(70.0),
// //         child: AppBar(
// //           title: Container(
// //             width: 200,
// //             alignment: Alignment.center,
// //             child: Image.asset('images/Orion.png'),
// //           ),
// //           backgroundColor: const Color(0xFFB9CAE0),
// //           elevation: 0.0,
// //           titleSpacing: 10.0,
// //           centerTitle: true,
// //           leading: InkWell(
// //             onTap: () {
// //               Navigator.pop(context);
// //             },
// //             child: Icon(
// //               Icons.arrow_back,
// //               color: Colors.black,
// //             ),
// //           ),
// //         ),
// //         ),
// //       body: Container(
// //         color: const Color(0xFFB9CAE0),
// //         child: FutureBuilder(
// //           future: _initializeVideoPlayerFuture,
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.done) {
// //               return Column(
// //                 children: [
// //                   AspectRatio(
// //                     aspectRatio: _controller!.value.aspectRatio,
// //                     child: VideoPlayer(_controller!),
// //                   ),
// //                 ],
// //               );
// //             } else {
// //               return Center(child: CircularProgressIndicator());
// //             }
// //           },
// //         ),
// //       ),
// //       // floatingActionButton: FloatingActionButton(
// //       //   onPressed: () {
// //       //     setState(() {
// //       //       if (_controller!.value.isPlaying) {
// //       //         _controller!.pause();
// //       //       } else {
// //       //         _controller!.play();
// //       //       }
// //       //     });
// //       //   },
// //       //   child: Icon(
// //       //     _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
// //       //   ),
// //       // ),
// //     );
// //   }
// // }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/GovHome.dart';
import 'package:video_player/video_player.dart';

class CheckRecordings extends StatelessWidget {
  const CheckRecordings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        body: const VideoPlayersList(),
      ),
    );
  }
}

class VideoPlayersList extends StatefulWidget {
  const VideoPlayersList({Key? key}) : super(key: key);

  @override
  _VideoPlayersListState createState() => _VideoPlayersListState();
}

class _VideoPlayersListState extends State<VideoPlayersList> {
  Future<List<String>>? futurePaths;
  Future<List<String>>? futureTime;
  Future<List<String>>? futureLocation;

  Future<List<String>> getUrl() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Recordings')
        .where('Video', isNotEqualTo: null).get();
    List<DocumentSnapshot> docsList = snapshot.docs;
    List<String> paths = [];

    docsList.forEach((doc) {
      dynamic data = doc.data();
      String? video = data['Video']?.toString();
      if(video != null) {
        paths.add(video);
      }
    });
    return paths;
  }

  Future<List<String>> getTimestamp() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Recordings')
        .where('Date and Time', isNotEqualTo: null).get();
    List<DocumentSnapshot> docsList = snapshot.docs;
    List<String> paths = [];

    docsList.forEach((doc) {
      dynamic data = doc.data();
      String? timestamp = data['Date and Time']?.toString();
      if(timestamp != null) {
        paths.add(timestamp);
      }
    });
    return paths;
  }

  Future<List<String>> getLocation() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Recordings')
        .where('Location', isNotEqualTo: null).get();
    List<DocumentSnapshot> docsList = snapshot.docs;
    List<String> paths = [];

    docsList.forEach((doc) {
      dynamic data = doc.data();
      String? location = data['Location']?.toString();
      if(location != null) {
        paths.add(location);
      }
    });
    return paths;
  }

  @override
  void initState() {
    super.initState();
    futurePaths = getUrl();
    futureTime = getTimestamp();
    futureLocation = getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB9CAE0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 10, 8),
                child: Center(child: Text(
                  'Recordings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )
                )
            ),
            FutureBuilder(
              future: Future.wait<List<dynamic>>([futureTime!, futureLocation!, futurePaths!]),
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the future is not yet complete, show a loading indicator
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
                } else if (snapshot.hasError) {
                  // If the future completed with an error, show an error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> time = snapshot.data![0];
                  List<String> location = snapshot.data![1];
                  List<String> paths = snapshot.data![2];
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: time.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text('Date and Time: ' + time[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-0.3, 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                                      child: Text('Location: ' + location[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                VideoPlay(
                                  pathh: paths[index],
                                ),
                              ],
                            ),
                          );

                        },
                      ),
                    ],
                  );
                }
              },
            ),

            Padding (padding: const EdgeInsets.fromLTRB(3, 17, 10, 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(
                      builder: (context) =>
                          GovHome()));
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
      ),
    );
  }
}

class VideoPlay extends StatefulWidget {
  String? pathh;

  @override
  _VideoPlayState createState() => _VideoPlayState();

  VideoPlay({
    Key? key,
    this.pathh, // Video from assets folder
  }) : super(key: key);
}

class _VideoPlayState extends State<VideoPlay> {
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.network(widget.pathh!);

    futureController = controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    controller!.addListener(() async{
      if (controller!.value.isInitialized) {
        currentPosition.value = controller!.value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: Stack(children: [
                    Positioned.fill(
                        child: Container(
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(.7),
                                    Colors.transparent
                                  ],
                                  stops: [
                                    0,
                                    .3
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                            child: VideoPlayer(controller!))),

                    Positioned.fill(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onDoubleTap: () async {
                                      Duration? position =
                                      await controller!.position;
                                      setState(() {
                                        controller!.seekTo(Duration(
                                            seconds: position!.inSeconds - 10));
                                      });
                                    },
                                    child: const Icon(
                                      Icons.fast_rewind_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: IconButton(
                                      icon: Icon(
                                        controller!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (controller!.value.isPlaying) {
                                            controller!.pause();
                                          } else {
                                            controller!.play();
                                          }
                                        });
                                      },
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onDoubleTap: () async {
                                      Duration? position =
                                      await controller!.position;
                                      setState(() {
                                        controller!.seekTo(Duration(
                                            seconds: position!.inSeconds + 10));
                                      });
                                    },
                                    child: const Icon(
                                      Icons.fast_forward_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ValueListenableBuilder(
                                    valueListenable: currentPosition,
                                    builder: (context, VideoPlayerValue? videoPlayerValue, w) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              videoPlayerValue!.position.toString()
                                                  .substring(videoPlayerValue.position.toString()
                                                  .indexOf(':') + 1, videoPlayerValue.position
                                                  .toString().indexOf('.')),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22),
                                            ),
                                            const Spacer(),
                                            Text(
                                              videoPlayerValue.duration.toString()
                                                  .substring(videoPlayerValue.duration.toString()
                                                  .indexOf(':') + 1, videoPlayerValue.duration
                                                  .toString().indexOf('.')),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ))
                        ],
                      ),
                    ),
                  ])),
            ),
          );
        }
      },
    );

  }
}
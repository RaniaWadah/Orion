// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CheckRecording extends StatelessWidget {
//   const CheckRecording({Key? key}) : super(key: key);
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
//           backgroundColor: const Color(0x6FE8D298),
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
//   late VideoPlayerController _controller;
//   late ChewieController _chewieController;
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//     _chewieController.videoPlayerController.dispose();
//    _chewieController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0x6FE8D298),
//       child: Scaffold(
//           body: Column(
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
//                     child: Center(child: Text(
//                       'Recordings',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                       ),
//                     )
//                     )
//                 ),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                     stream: FirebaseFirestore.instance.collection('Recordings').snapshots(),
//                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (!snapshot.hasData) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                       return ListView(
//                         children: snapshot.data!.docs.map((document) {
//                           var url = document['Video'].toString();
//                           _chewieController = ChewieController(
//                             videoPlayerController: VideoPlayerController.network(url),
//                             aspectRatio: 16 / 9,
//                             autoInitialize: true,
//                             autoPlay: false,
//                             looping: false,
//                             isLive: false,
//                           );
//                           return Center(
//                               child: Column(
//                                   children: <Widget>[
//                                     Padding(
//                                         padding: EdgeInsets.only(top: 20),
//                                         child: Text('Date and Time: '+ DateTime.fromMicrosecondsSinceEpoch(document['Date and Time'].microsecondsSinceEpoch).toString(),
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                         )
//                                     ),
//                                     Padding(
//                                         padding: EdgeInsets.only(bottom: 5),
//                                         child: Text('Location: '+ document['Location'].toString(),
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                         )
//                                     ),
//                                     Container(
//                                       width: MediaQuery.of(context).size.width / 1.2,
//                                       child: Chewie(
//                                         controller: _chewieController,
//                                       ),
//                                       // child: ChewieController(
//                                       //   videoPlayerController: _controller,
//                                       //   showVideoProgressIndicator: true,
//                                       // ),
//                                     ),
//                                   ]
//                               )
//                           );
//                         }
//                         ).toList(),
//                       );
//                     },
//                   ),
//
//                 ),
//               ]
//           )
//       ),
//     );
//   }
// }

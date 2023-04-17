// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:untitled2/CheckRecordings.dart';
// import 'package:untitled2/GiveAlarm.dart';
// import 'package:untitled2/ProvideSafetyMessage.dart';
// import 'package:untitled2/StartRecording.dart';
// import 'package:untitled2/ViewNotifications.dart';
//
// class details extends StatelessWidget {
//   final int index;
//   details({required this.index, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final buttonTimerModel = Provider.of<ButtonTimerModel>(context);
//     // final isButtonDisabled = buttonTimerModel.isButtonDisabled(1);
//
//     return Scaffold(
//       backgroundColor: Color(0xFFB9CAE0),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.0),
//         child: AppBar(
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
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<Object>(
//                 stream: null,
//                 builder: (context, snapshot) {
//                   return StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('userNotifications')
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       }
//
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.waiting:
//                           return Container(
//                             child: Center(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     child: CircularProgressIndicator(),
//                                     height: 50.0,
//                                     width: 50.0,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         default:
//                           List<DocumentSnapshot> documents = snapshot.data!.docs;
//                           return ListView(
//                             padding: EdgeInsets.all(20.0),
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(8, 40, 8, 25),
//                                 child: Text(
//                                   "${documents[index]['Title']}",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               documents[index]['Title'] == 'Report a Problem'?
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Category: ${documents[index]['Category']}",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ):
//                               Container(),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Description: ${documents[index]['Description']}",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               documents[index]['Title'] == 'Report a Problem'?
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: documents[index]['Image']!.isEmpty ? Container()
//                                     : Container(
//                                     height: MediaQuery.of(context).size.height *0.28,
//                                     decoration: BoxDecoration(
//                                     ),
//                                     child: GridView.count(
//                                       crossAxisCount: 2,
//                                       children: List.generate(documents[index]['Image']!.length, (i){
//                                         return Container(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(2),
//                                             child: Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 Image.file(
//                                                     File(documents[index]['Image']![i]),
//                                                     fit: BoxFit.fill),
//                                               ],
//
//                                             ),
//
//                                           ),
//                                         );
//                                       }),
//                                     )
//                                 ),
//                               ):
//                               Container(),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Sender Civil ID: ${documents[index]['Sender Civil ID']}",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Date and Time: ${documents[index]['Date and Time']}",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Location: ${documents[index]['Location']}",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                       }
//                     },
//                   );
//                 }),
//           ),
//           Padding (padding: const EdgeInsets.fromLTRB(3, 30, 10, 10),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) => ViewNotifications(),
//                 //     ));
//
//               },
//               child: const Text('Back', style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               ),
//               style: ElevatedButton.styleFrom(primary: const Color(
//                   0xff02165c), minimumSize: Size(170, 45),
//                   padding: EdgeInsets.symmetric(horizontal: 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   )
//               ),
//             ),
//           ),
//           IconTheme(
//             data: IconThemeData(size: 22.0, color: Colors.white),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 40),
//                   child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Padding(
//                           padding:
//                           EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                           child: Container(
//                             width: 70,
//                             height: 55,
//                             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => const StartRecording()));
//                               },
//                               child: Icon( // <-- Icon
//                                 Icons.video_camera_back_sharp,
//                                 size: 29.0,
//                                 color: Colors.white,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   primary: const Color(
//                                       0xff02165c),
//                                   padding: EdgeInsets.fromLTRB(16, 13, 20, 20),
//                                   // padding: EdgeInsets.symmetric(horizontal: 50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   )
//                               ), // <-- Text
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                           child: Container(
//                             width: 70,
//                             height: 55,
//                             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => CheckRecordings()));
//                               },
//                               child: Icon( // <-- Icon
//                                 Icons.video_collection_sharp,
//                                 size: 29.0,
//                                 color: Colors.white,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   primary: const Color(
//                                       0xff02165c),
//                                   padding: EdgeInsets.fromLTRB(16, 13, 20, 20),
//                                   // padding: EdgeInsets.symmetric(horizontal: 50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   )
//                               ), // <-- Text
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                           child: Container(
//                             width: 70,
//                             height: 55,
//                             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => const GiveAlarm()));
//                               },
//                               child: Icon( // <-- Icon
//                                 Icons.alarm_add_sharp,
//                                 size: 33.0,
//                                 color: Colors.white,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   primary: const Color(
//                                       0xff02165c),
//                                   padding: EdgeInsets.fromLTRB(13.5, 12, 20, 20),
//                                   // padding: EdgeInsets.symmetric(horizontal: 50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   )
//                               ), // <-- Text
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                           child: Container(
//                             width: 70,
//                             height: 55,
//                             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => SpeakerPage()));
//                               },
//                               child: Icon( // <-- Icon
//                                 Icons.keyboard_voice_sharp,
//                                 size: 34.0,
//                                 color: Colors.white,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   primary: const Color(
//                                       0xff02165c),
//                                   padding: EdgeInsets.fromLTRB(13.5, 10, 20, 20),
//                                   // padding: EdgeInsets.symmetric(horizontal: 50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   )
//                               ), // <-- Text
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                           child: Container(
//                             width: 70,
//                             height: 55,
//                             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                               },
//                               child: Icon( // <-- Icon
//                                 Icons.add_a_photo_sharp,
//                                 size: 31.0,
//                                 color: Colors.white,
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   primary: const Color(
//                                       0xff02165c),
//                                   padding: EdgeInsets.fromLTRB(14, 11, 20, 20),
//                                   // padding: EdgeInsets.symmetric(horizontal: 50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   )
//                               ), // <-- Text
//                             ),
//                           ),
//                         ),
//                       ]
//                   ),
//
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

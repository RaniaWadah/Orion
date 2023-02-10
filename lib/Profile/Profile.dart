// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Profile extends StatefulWidget {
//   const Profile({Key? key}) : super(key: key);
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
// class _ProfileState extends State<Profile>{
//   final ref = FirebaseDatabase.instance.ref('users1');
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: StreamBuilder(
//         stream: ref.child(SessionController().userId.toString()).onValue,
//         builder: (context, AsyncSnapshot snapshot){
//           if(!snapshot.hasData){
//             return Center( child: CircularProgressIndicator());
//           }
//           else if(snapshot.hasData){
//             Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 ListTile(
//                   title: Text(map['First Name']),
//
//                 )
//               ]
//             );
//           }
//           else{
//             return Center( child: Text('Something Went Wrong', style: Theme.of(context).textTheme.subtitle1,));
//           }
//
//         }
//       )
//       ),
//     );
//   }
//
// }
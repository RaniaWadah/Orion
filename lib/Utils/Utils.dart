// import 'package:flutter/material.dart';
// import 'package:untitled2/utils/navigate.dart';
//
// class Utils {
//   static showLoader({BuildContext? context, bool isShow = true}) {
//     context ??= Navigate.navigatorKey.currentContext;
//     if (isShow) {
//       showDialog(
//         barrierDismissible: false,
//         context: context!,
//         builder: (BuildContext context) {
//           return WillPopScope(
//             onWillPop: () async {
//               return false;
//             },
//             child: AlertDialog(
//               content: Row(
//                 children: const [
//                   CircularProgressIndicator(),
//                   SizedBox(width: 20),
//                   Text('Please Wait...'),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     } else {
//       Navigate.pop();
//     }
//   }
// }

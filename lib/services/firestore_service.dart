// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:untitled2/Model/user_model.dart';
// import 'package:intl/intl.dart';
//
// class FirestoreService {
//   FirestoreService._();
//
//   static final instance = FirestoreService._();
//
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   String newDocId({required String path}) => _firestore.collection(path).doc().id;
//
//   /// Check If Document Exists
//   Future<bool> checkIfDocExists(String collectionName, String docId) async {
//     try {
//       var collectionRef = _firestore.collection(collectionName);
//       var doc = await collectionRef.doc(docId).get();
//       return doc.exists;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<void> setData({
//     required String path,
//     required Map<String, dynamic> data,
//     bool merge = false,
//   }) async {
//     final reference = _firestore.doc(path);
//     await reference.set(data, SetOptions(merge: merge));
//   }
//
//   Future<UserModel?> getUser({String? uid}) async {
//     if (uid != null) {
//       final userRef = FirebaseFirestore.instance.collection('user');
//       final doc = await userRef.doc(uid).get();
//       if (doc.data() is Map) {
//         return UserModel().fromJson(doc.data() as Map);
//       }
//     }
//     return null;
//   }
//
//   Future<void> saveLocation({double latitude = 0.0, double longitude = 0.0}) async {
//     final userInfo = await getUser(uid: FirebaseAuth.instance.currentUser!.uid);
//     print('TAG:: saveLocation: userInfo >>>>>>>>>> ${userInfo?.toJson()}');
//
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
//
//     final map = {
//       'Date and Time': formattedDate,
//       'Sender Civil ID': userInfo?.civilID,
//       'Location': "",
//     };
//     print('TAG:: saveLocation: map >>>>>>>>>> $map');
//     CollectionReference ref = FirebaseFirestore.instance.collection('Notifications');
//     await ref.add(map);
//   }
// }

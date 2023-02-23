// import 'base_model.dart';
//
// class UserModel extends BaseModel {
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? token;
//   final String? uid;
//   final String? civilId;
//
//   UserModel({
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.token,
//     this.uid,
//     this.civilId,
//   });
//
//   UserModel copyWith({
//     String? firstName,
//     String? lastName,
//     String? email,
//     String? token,
//     String? uid,
//     String? civilId,
//   }) {
//     return UserModel(
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       email: email ?? this.email,
//       token: token ?? this.token,
//       uid: uid ?? this.uid,
//       civilId: civilId ?? this.civilId,
//     );
//   }
//
//   const UserModel.empty()
//       : firstName = '',
//         lastName = '',
//         email = '',
//         token = '',
//         uid = '',
//         civilId = '';
//
//   UserModel fromJson(Map map) {
//     return UserModel(
//       firstName: stringFromJson(map, 'First Name', defaultVal: ''),
//       lastName: stringFromJson(map, 'Last Name', defaultVal: ''),
//       email: stringFromJson(map, 'Email', defaultVal: ''),
//       token: stringFromJson(map, 'Token', defaultVal: ''),
//       uid: stringFromJson(map, 'uid', defaultVal: ''),
//       civilId: stringFromJson(map, 'Civil ID', defaultVal: ''),
//     );
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return {
//       'First Name': firstName,
//       'Last Name': lastName,
//       'Email': email,
//       'Token': token,
//       'uid': uid,
//       'Civil ID': civilId,
//     };
//   }
// }

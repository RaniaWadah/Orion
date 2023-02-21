import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UserData{
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;

  UserData({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
  });

  // factory UserData.fromDoc(DocumentSnapshot doc) {
  //   return UserData(
  //     firstName: doc['First Name'],
  //     lastName: doc['Last Name'],
  //     email: doc['Email'],
  //     username: doc['Username'],
  //     password: doc['Password'],
  //   );
  // }

    // UserData.fromSnapshot(DataSnapshot dataSnapshot) {
  //   firstName = (dataSnapshot.child("First Name").value.toString());
  //   lastName = (dataSnapshot.child("Last Name").value.toString());
  //   email = (dataSnapshot.child("Email").value.toString());
  //   username = (dataSnapshot.child("Username").value.toString());
  //   password = (dataSnapshot.child("Password").value.toString());
  // }

  UserData.fromJson(Map<dynamic, dynamic> json){
    firstName = json['First Name'];
    lastName = json['Last Name'];
    email = json['Email'];
    username = json['Username'];
    password = json['Password'];
  }
}
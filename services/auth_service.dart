import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<String> get user {
    return auth.authStateChanges()
        .map((User? user) => user!.uid,
    );
  }

  Future getCurrentUser() async{
    return await auth.currentUser!;
  }
}
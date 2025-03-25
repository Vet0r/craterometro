import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String uid = '';
  String name = '';
  String email = '';
  String cpf = '';
  bool isAdmin = false;

  void setUser({
    required String uid,
    required String name,
    required String email,
    required String cpf,
    required bool isAdmin,
  }) {
    this.uid = uid;
    this.name = name;
    this.email = email;
    this.cpf = cpf;
    this.isAdmin = isAdmin;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setUser(
          uid: user.uid,
          name: userDoc['name'],
          email: userDoc['email'],
          cpf: userDoc['cpf'],
          isAdmin: userDoc['isAdmin'],
        );
      }
    }
  }

  void clearUser() {
    uid = '';
    name = '';
    email = '';
    cpf = '';
    isAdmin = false;
    notifyListeners();
  }
}

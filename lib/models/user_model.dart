import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? user;

  setUser(User? val) {
    user = val;
    notifyListeners();
  }

  getUser() {
    return user;
  }

  subscribeToUserChanges() {
    return FirebaseAuth.instance.userChanges();
  }
}

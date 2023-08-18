import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  User? _user;

  void setUser(User? val) {
    _user = val;
    notifyListeners();
  }

  User? getUser() {
    return _user;
  }

  Stream<User?> subscribeToUserChanges() {
    return FirebaseAuth.instance.userChanges();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_fit/constants/shared_prefs_strings.dart';
import 'package:my_fit/utils/shared_prefs_utils.dart';

class LoginModel extends ChangeNotifier {
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    if (googleAuth != null) {
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        var userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        var user = userCredential.user;
        debugPrint(user?.displayName);
        debugPrint(user?.email);
        debugPrint(user?.uid);
        debugPrint(user?.phoneNumber);
        debugPrint(user?.photoURL);
        debugPrint(user?.emailVerified.toString());
        await SharedPrefsUtils.setString(
            SharedPrefsStrings.USER_NAME, user?.displayName ?? '');
        return userCredential;
      }
    }
    return null;
  }
}

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignInProvider extends ChangeNotifier {
  String? username;
  final googleSignin = GoogleSignIn();
  late bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool status) {
    _isSigningIn = status;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignin.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      isSigningIn = false;
    }
  }

  Future<void> logout() async {
    await googleSignin.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  Future<String?> getCurrentUserIdToken() async {
    // await FirebaseAuth.instance.signOut();
    return _getCurrentUserIdToken();
  }

  Future<String> getCurrentUserIdTokenWhenLoggedIn() async {
    final idToken = await _getCurrentUserIdToken();
    return idToken!;
  }

  String getCurrentUserIdWhenLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();
    debugPrint('Signed in anonymously: $idToken');
  }

  Future<String?> _getCurrentUserIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.getIdToken();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  Future<String?> getCurrentUserIdToken() async {
    // await FirebaseAuth.instance.signOut();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    return user.getIdToken();
  }

  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();
    debugPrint('Signed in anonymously: $idToken');
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/login_session.dart';
import 'package:rxdart/rxdart.dart';

final sessionProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap(
    (user) async {
      if (user == null) {
        return null;
      }

      final token = await user.getIdToken();

      return LoginSession(userId: user.uid, token: token);
    },
  ).whereType<LoginSession>();
});

final userIdProvider = StreamProvider((ref) {
  final sessionStream = ref.watch(sessionProvider.stream);
  return sessionStream.map((session) => session.userId);
});

class AuthService {
  Future<LoginSession?> currentSession() async {
    try {
      final session = await _currentSession();
      return session;
    } on FirebaseAuthException {
      await FirebaseAuth.instance.signOut();
    }

    return null;
  }

  Future<LoginSession> currentSessionWhenLoggedIn() async {
    final session = await _currentSession();
    return session!;
  }

  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();
    debugPrint('Signed in anonymously: $idToken');
  }

  Stream<String?> currentUserIdStream() {
    return FirebaseAuth.instance.authStateChanges().map((user) => user?.uid);
  }

  Future<LoginSession?> _currentSession() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final token = await user.getIdToken();

    return LoginSession(userId: user.uid, token: token);
  }
}

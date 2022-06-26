import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/login_session.dart';
import 'package:rxdart/rxdart.dart';

final sessionProvider = StateNotifierProvider<SessionProvider, LoginSession?>(
  (ref) => SessionProvider(),
);

final userIdProvider = Provider((ref) {
  final sessionStream = ref.watch(sessionProvider);
  return sessionStream?.userId;
});

class AuthService {
  Future<LoginSession> currentSessionWhenLoggedIn() async {
    final session = await _currentSession();
    return session!;
  }

  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();
    debugPrint('Signed in anonymously: $idToken');
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

class SessionProvider extends StateNotifier<LoginSession?> {
  SessionProvider() : super(null);

  final _sessionSubject = BehaviorSubject<LoginSession?>();

  StreamSubscription<LoginSession?>? _sessionSubscription;

  @override
  Future<void> dispose() async {
    await _sessionSubject.close();

    await _sessionSubscription?.cancel();

    super.dispose();
  }

  Future<void> setup() async {
    final session = await _currentSession();
    state = session;

    _sessionSubscription = FirebaseAuth.instance.authStateChanges().asyncMap(
      (user) async {
        if (user == null) {
          return null;
        }

        final token = await user.getIdToken();

        return LoginSession(userId: user.uid, token: token);
      },
    ).listen((session) {
      state = session;
    });
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

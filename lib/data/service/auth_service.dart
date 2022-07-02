// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/login_session.dart';
import 'package:rxdart/rxdart.dart';

final sessionProvider = StateNotifierProvider<SessionProvider, LoginSession?>(
  (ref) => SessionProvider(),
);

/// Provider for session as [Stream].
///
/// Used to wait until the session is not null.
final sessionStreamProvider = StreamProvider<LoginSession>((ref) {
  final maybeSession = ref.watch(sessionProvider);

  if (maybeSession == null) {
    return const Stream.empty();
  }

  return Stream.value(maybeSession);
});

final signInAnonymouslyActionProvider = FutureProvider((ref) async {
  final credential = await FirebaseAuth.instance.signInAnonymously();
  final idToken = await credential.user?.getIdToken();
  debugPrint('Signed in anonymously: $idToken');
});

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
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      final token = await user.getIdToken();

      return LoginSession(userId: user.uid, token: token);
    } on FirebaseAuthException {
      // TODO(ide): 本番公開アプリでは強制サインアウトはやめた方がいいかも
      await FirebaseAuth.instance.signOut();
    }

    return null;
  }
}

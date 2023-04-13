// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/link_credential_error.dart';
import 'package:meow_music/data/model/login_session.dart';
import 'package:meow_music/data/model/profile.dart';
import 'package:meow_music/data/model/result.dart';
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

final authActionsProvider = Provider(
  (ref) => AuthActions(),
);

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

    _sessionSubscription = FirebaseAuth.instance
        .authStateChanges()
        .asyncMap(_convertFirebaseUserToLoginSession)
        .listen((session) {
      state = session;
    });
  }

  Future<LoginSession?> _currentSession() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return _convertFirebaseUserToLoginSession(user);
    } on FirebaseAuthException {
      // TODO(ide): Stop signing out in public apps.
      await FirebaseAuth.instance.signOut();
    }

    return null;
  }

  Future<LoginSession?> _convertFirebaseUserToLoginSession(User? user) async {
    if (user == null) {
      return null;
    }

    final token = await user.getIdToken();

    final providerData = user.providerData.firstOrNull;
    final name = providerData?.displayName;
    final photoUrl = providerData?.photoURL;
    final profile =
        providerData != null ? Profile(name: name, photoUrl: photoUrl) : null;

    return LoginSession(
      userId: user.uid,
      token: token,
      nonAnonymousProfile: profile,
    );
  }
}

class AuthActions {
  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();
    debugPrint('Signed in anonymously: $idToken');
  }

  Future<Result<void, LinkCredentialError>> loginWithTwitter({
    required String authToken,
    required String secret,
  }) async {
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authToken,
      secret: secret,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (e) {
      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<Result<void, LinkCredentialError>> linkWithTwitter({
    required String authToken,
    required String secret,
  }) async {
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authToken,
      secret: secret,
    );

    final currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await currentUser.linkWithCredential(twitterAuthCredential);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (e) {
      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

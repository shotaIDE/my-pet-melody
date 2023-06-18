// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/logger/error_reporter.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';
import 'package:my_pet_melody/data/model/delete_account_with_current_session_error.dart';
import 'package:my_pet_melody/data/model/link_credential_error.dart';
import 'package:my_pet_melody/data/model/login_session.dart';
import 'package:my_pet_melody/data/model/profile.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:rxdart/rxdart.dart';

final sessionProvider = StateNotifierProvider<SessionProvider, LoginSession?>(
  (_) => SessionProvider(),
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
  (ref) {
    final errorReporter = ref.watch(errorReporterProvider);

    return AuthActions(errorReporter: errorReporter);
  },
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
        .userChanges()
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
  const AuthActions({required ErrorReporter errorReporter})
      : _errorReporter = errorReporter;

  final ErrorReporter _errorReporter;

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
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when login with Twitter.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when login with Twitter.',
      );

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
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when link with Twitter.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when link with Twitter.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<Result<void, LinkCredentialError>> loginWithFacebook({
    required String accessToken,
  }) async {
    final facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when login with Facebook.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when login with Facebook.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<Result<void, LinkCredentialError>> linkWithFacebook({
    required String accessToken,
  }) async {
    final facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

    final currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await currentUser.linkWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when link with Facebook.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when link with Facebook.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Result<void, LinkCredentialError>> reauthenticateWithTwitter({
    required String authToken,
    required String secret,
  }) async {
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authToken,
      secret: secret,
    );

    final currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await currentUser.reauthenticateWithCredential(twitterAuthCredential);
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

  Future<Result<void, DeleteAccountWithCurrentSessionError>> delete() async {
    final currentUser = FirebaseAuth.instance.currentUser!;

    final providerId = currentUser.providerData.first.providerId;

    final provider = AccountProviderGenerator.fromProviderId(providerId)!;

    try {
      await currentUser.delete();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        return Result.failure(
          DeleteAccountWithCurrentSessionError.needReauthenticate(
            provider: provider,
          ),
        );
      }

      return const Result.failure(
        DeleteAccountWithCurrentSessionError.unrecoverable(),
      );
    } catch (e) {
      return const Result.failure(
        DeleteAccountWithCurrentSessionError.unrecoverable(),
      );
    }

    return const Result.success(null);
  }
}

// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/logger/error_reporter.dart';
import 'package:my_pet_melody/data/logger/event_reporter.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';
import 'package:my_pet_melody/data/model/delete_account_with_current_session_error.dart';
import 'package:my_pet_melody/data/model/google_credential.dart';
import 'package:my_pet_melody/data/model/link_credential_error.dart';
import 'package:my_pet_melody/data/model/login_error.dart';
import 'package:my_pet_melody/data/model/login_session.dart';
import 'package:my_pet_melody/data/model/profile.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:rxdart/rxdart.dart';

final sessionProvider = StateNotifierProvider<SessionProvider, LoginSession?>(
  (ref) {
    final errorReporter = ref.watch(errorReporterProvider);

    return SessionProvider(
      errorReporter: errorReporter,
    );
  },
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

final Provider<AuthActions> authActionsProvider = Provider(
  (ref) {
    final errorReporter = ref.watch(errorReporterProvider);
    final eventReporter = ref.watch(eventReporterProvider);

    return AuthActions(
      errorReporter: errorReporter,
      eventReporter: eventReporter,
    );
  },
);

class SessionProvider extends StateNotifier<LoginSession?> {
  SessionProvider({required ErrorReporter errorReporter})
      : _errorReporter = errorReporter,
        super(null);

  final ErrorReporter _errorReporter;

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

  Future<LoginSession?> _currentSession() {
    final user = FirebaseAuth.instance.currentUser;
    return _convertFirebaseUserToLoginSession(user);
  }

  Future<LoginSession?> _convertFirebaseUserToLoginSession(User? user) async {
    if (user == null) {
      return null;
    }

    final String? token;
    try {
      token = await user.getIdToken();
    } on FirebaseAuthException catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'failed to get id, although logged-in user exists.',
      );

      await FirebaseAuth.instance.signOut();

      return null;
    }

    if (token == null) {
      return null;
    }

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
  const AuthActions({
    required ErrorReporter errorReporter,
    required EventReporter eventReporter,
  })  : _errorReporter = errorReporter,
        _eventReporter = eventReporter;

  final ErrorReporter _errorReporter;
  final EventReporter _eventReporter;

  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();

    debugPrint('Signed in anonymously: $idToken');

    unawaited(
      _eventReporter.continueWithoutLogin(),
    );
  }

  Future<Result<void, LinkCredentialError>> loginWithGoogle(
    GoogleCredential credential,
  ) async {
    final googleAuthCredential = GoogleAuthProvider.credential(
      idToken: credential.idToken,
      accessToken: credential.accessToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when login with Google.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when login with Google.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<Result<void, LinkCredentialError>> linkWithGoogle(
    GoogleCredential credential,
  ) async {
    final googleAuthCredential = GoogleAuthProvider.credential(
      idToken: credential.idToken,
      accessToken: credential.accessToken,
    );

    final currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await currentUser.linkWithCredential(googleAuthCredential);
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when link with Google.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when link with Google.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<Result<void, LoginError>> loginOrLinkWithApple() async {
    final appleProvider = AppleAuthProvider();

    try {
      await FirebaseAuth.instance.signInWithProvider(appleProvider);
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'canceled' || error.code == 'web-context-canceled') {
        return const Result.failure(LoginError.cancelledByUser());
      }

      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LoginError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when login with Apple.',
      );

      return const Result.failure(LoginError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when login with Apple.',
      );

      return const Result.failure(LoginError.unrecoverable());
    }

    return const Result.success(null);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Result<void, LinkCredentialError>> reauthenticateWithGoogle(
    GoogleCredential credential,
  ) async {
    final googleAuthCredential = GoogleAuthProvider.credential(
      idToken: credential.idToken,
      accessToken: credential.accessToken,
    );

    final currentUser = FirebaseAuth.instance.currentUser!;

    try {
      await currentUser.reauthenticateWithCredential(googleAuthCredential);
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'credential-already-in-use') {
        return const Result.failure(LinkCredentialError.alreadyInUse());
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception '
            'when reauthenticate with Google.',
      );

      return const Result.failure(LinkCredentialError.unrecoverable());
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when reauthenticate with Google.',
      );

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
    } on FirebaseAuthException catch (error, stack) {
      if (error.code == 'requires-recent-login') {
        return Result.failure(
          DeleteAccountWithCurrentSessionError.needReauthenticate(
            provider: provider,
          ),
        );
      }

      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled Firebase Auth exception when delete account',
      );

      return const Result.failure(
        DeleteAccountWithCurrentSessionError.unrecoverable(),
      );
    } catch (error, stack) {
      await _errorReporter.send(
        error,
        stack,
        reason: 'unhandled exception when delete account',
      );

      return const Result.failure(
        DeleteAccountWithCurrentSessionError.unrecoverable(),
      );
    }

    return const Result.success(null);
  }
}

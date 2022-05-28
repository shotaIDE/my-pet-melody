import 'dart:async';

import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:rxdart/rxdart.dart';

class AuthUseCase {
  const AuthUseCase({
    required AuthService authService,
    required DatabaseService databaseService,
    required PushNotificationService pushNotificationService,
  })  : _authService = authService,
        _databaseService = databaseService,
        _pushNotificationService = pushNotificationService;

  final AuthService _authService;
  final DatabaseService _databaseService;
  final PushNotificationService _pushNotificationService;

  Future<void> ensureLoggedIn() async {
    final idToken = await _authService.currentSession();
    if (idToken != null) {
      return;
    }

    await _authService.signInAnonymously();
  }

  StreamSubscription<void> storeRegistrationTokenStream() {
    return _authService
        .currentUserIdStream()
        .whereType<String>()
        .listen((userId) async {
      final registrationToken =
          await _pushNotificationService.registrationToken();
      if (registrationToken == null) {
        return;
      }

      await _databaseService.sendRegistrationTokenIfNeeded(
        registrationToken,
        userId: userId,
      );
    });
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:rxdart/rxdart.dart';

final registrationTokenProvider = StreamProvider((ref) {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  final userIdStream = ref.watch(userIdProvider.stream);

  return userIdStream
      .asyncMap((userId) async => pushNotificationService.registrationToken())
      .whereType<String>();
});

class AuthUseCase {
  const AuthUseCase({
    required AuthService authService,
  }) : _authService = authService;

  final AuthService _authService;

  Future<void> ensureLoggedIn() async {
    final idToken = await _authService.currentSession();
    if (idToken != null) {
      return;
    }

    await _authService.signInAnonymously();
  }
}

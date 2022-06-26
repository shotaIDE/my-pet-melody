import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';

final registrationTokenProvider = FutureProvider((ref) {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  // TODO(ide): Sessionが更新されたときに取得し直した方がいい？
  ref.watch(userIdProvider);

  return pushNotificationService.registrationToken();
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

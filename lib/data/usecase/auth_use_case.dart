import 'package:meow_music/data/service/auth_service.dart';

class AuthUseCase {
  const AuthUseCase({required AuthService authService})
      : _service = authService;

  final AuthService _service;

  Future<void> ensureLoggedIn() async {
    final idToken = await _service.getCurrentUserIdToken();
    if (idToken != null) {
      return;
    }

    await _service.signInAnonymously();
  }
}

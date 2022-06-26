import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';

final registrationTokenProvider = FutureProvider((ref) {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  // TODO(ide): Sessionが更新されたときに取得し直した方がいい？
  ref.watch(userIdProvider);

  return pushNotificationService.registrationToken();
});

final ensureLoggedInActionProvider = FutureProvider((ref) async {
  // TODO(ide): 初期化が完了するまで待つ処理、ここに書くの微妙
  await ref.read(sessionProvider.notifier).setup();

  final session = ref.read(sessionProvider);
  if (session != null) {
    return;
  }

  final authService = ref.read(authServiceProvider);
  await authService.signInAnonymously();
});

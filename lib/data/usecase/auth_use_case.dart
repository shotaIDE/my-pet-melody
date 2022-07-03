import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';

final registrationTokenProvider = FutureProvider((ref) async {
  // Gets a registration token each time the session is not null.
  await ref.watch(sessionStreamProvider.future);

  final pushNotificationService = ref.watch(pushNotificationServiceProvider);

  return pushNotificationService.registrationToken();
});

final ensureLoggedInActionProvider = FutureProvider((ref) async {
  // TODO(ide): Not a good idea to write a process here
  //  that waits until initialization is complete.
  await ref.read(sessionProvider.notifier).setup();

  final session = ref.read(sessionProvider);
  if (session != null) {
    return;
  }

  await ref.read(authActionsProvider).signInAnonymously();
});

final signInActionProvider = Provider((ref) {
  final actions = ref.watch(authActionsProvider);

  return actions.signInAnonymously;
});

final signOutActionProvider = Provider((ref) {
  final actions = ref.watch(authActionsProvider);

  // TODO(ide): Reset registration token.

  return actions.signOut;
});

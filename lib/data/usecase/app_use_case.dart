import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/di/service_providers.dart';

final ensureSetupPushNotificationActionProvider = FutureProvider((ref) async {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  await pushNotificationService.setupNotification();
});

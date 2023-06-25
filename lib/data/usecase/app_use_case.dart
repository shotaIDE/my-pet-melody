import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/di/service_providers.dart';

final ensureSetupPushNotificationActionProvider = Provider((ref) {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  return pushNotificationService.setupNotification;
});

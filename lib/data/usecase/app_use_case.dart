import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/service/app_service.dart';
import 'package:my_pet_melody/data/service/push_notification_service.dart';
import 'package:my_pet_melody/data/service/remote_config_service.dart';

final ensureSetupPushNotificationActionProvider = Provider((ref) {
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);
  return pushNotificationService.setupNotification;
});

final shouldUpdateAppProvider = FutureProvider((ref) async {
  final minimumBuildNumber = await ref.watch(minimumBuildNumberProvider.future);
  final currentBuildNumber = await ref.watch(buildNumberProvider.future);
  return currentBuildNumber < minimumBuildNumber;
});

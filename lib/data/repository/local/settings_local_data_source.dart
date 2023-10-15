import 'package:my_pet_melody/data/model/preference_key.dart';
import 'package:my_pet_melody/data/service/preference_service.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource({required PreferenceService preferenceService})
      : _preferenceService = preferenceService;

  final PreferenceService _preferenceService;

  Future<bool> getHasRequestedPushNotificationPermissionAtLeastOnce() async {
    final hasRequested = await _preferenceService.getBool(
      PreferenceKey.hasRequestedPushNotificationPermissionAtLeastOnce,
    );

    return hasRequested ?? false;
  }

  Future<void> setHasRequestedPushNotificationPermissionAtLeastOnce() async {
    await _preferenceService.setBool(
      PreferenceKey.hasRequestedPushNotificationPermissionAtLeastOnce,
      value: true,
    );
  }
}

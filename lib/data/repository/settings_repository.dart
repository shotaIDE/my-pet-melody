import 'package:meow_music/data/repository/local/settings_local_data_source.dart';

class SettingsRepository {
  SettingsRepository({
    required SettingsLocalDataSource localDataSource,
  }) : _local = localDataSource;

  final SettingsLocalDataSource _local;

  bool? _cachedHasRequestedPushNotificationPermissionAtLeastOnce;

  Future<bool> getHasRequestedPushNotificationPermissionAtLeastOnce() async {
    if (_cachedHasRequestedPushNotificationPermissionAtLeastOnce != null) {
      return _cachedHasRequestedPushNotificationPermissionAtLeastOnce!;
    }

    final hasRequested =
        await _local.getHasRequestedPushNotificationPermissionAtLeastOnce();

    _cachedHasRequestedPushNotificationPermissionAtLeastOnce = hasRequested;

    return hasRequested;
  }

  Future<void> setHasRequestedPushNotificationPermissionAtLeastOnce() async {
    await _local.setHasRequestedPushNotificationPermissionAtLeastOnce();

    _cachedHasRequestedPushNotificationPermissionAtLeastOnce = true;
  }
}

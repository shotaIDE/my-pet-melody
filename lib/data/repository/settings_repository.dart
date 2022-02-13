import 'package:meow_music/data/repository/local/settings_local_data_source.dart';

class SettingsRepository {
  SettingsRepository({
    required SettingsLocalDataSource localDataSource,
  }) : _local = localDataSource;

  final SettingsLocalDataSource _local;

  bool? _cachedIsOnboardingFinished;

  Future<bool> getIsOnboardingFinished() async {
    if (_cachedIsOnboardingFinished != null) {
      return _cachedIsOnboardingFinished!;
    }

    final isFinished = await _local.getIsOnboardingFinished();

    _cachedIsOnboardingFinished = isFinished;

    return isFinished;
  }

  Future<void> setIsOnboardingFinished() async {
    await _local.setIsOnboardingFinished();

    _cachedIsOnboardingFinished = true;
  }
}

import 'package:meow_music/data/model/preference_key.dart';
import 'package:meow_music/data/service/preference_service.dart';

class SettingsLocalDataSource {
  Future<bool> getIsOnboardingFinished() async {
    return false;
    final isFinished =
        await PreferenceService.getBool(PreferenceKey.isOnboardingFinished);

    return isFinished ?? false;
  }

  Future<void> setIsOnboardingFinished() async {
    await PreferenceService.setBool(
      PreferenceKey.isOnboardingFinished,
      value: true,
    );
  }
}

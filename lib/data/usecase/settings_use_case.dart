import 'package:meow_music/data/repository/settings_repository.dart';

class SettingsUseCase {
  const SettingsUseCase({required SettingsRepository repository})
      : _repository = repository;

  final SettingsRepository _repository;

  Future<bool> getIsOnboardingFinished() async {
    return _repository.getIsOnboardingFinished();
  }

  Future<void> onOnboardingFinished() async {
    await _repository.setIsOnboardingFinished();
  }
}

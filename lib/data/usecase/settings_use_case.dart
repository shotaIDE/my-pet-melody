// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/repository/settings_repository.dart';

final settingsActionsProvider = Provider((ref) {
  final repository = ref.read(settingsRepositoryProvider);

  return SettingsActions(repository: repository);
});

class SettingsActions {
  const SettingsActions({required SettingsRepository repository})
      : _repository = repository;

  final SettingsRepository _repository;

  Future<bool> getIsOnboardingFinished() async {
    return _repository.getIsOnboardingFinished();
  }

  Future<void> onOnboardingFinished() async {
    await _repository.setIsOnboardingFinished();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';

final isOnboardingFinishedProvider = Provider((ref) {
  final repository = ref.read(settingsRepositoryProvider);

  Future<bool> action() async {
    return repository.getIsOnboardingFinished();
  }

  return action;
});

final finishOnboardingActionProvider = Provider((ref) {
  final repository = ref.read(settingsRepositoryProvider);

  Future<void> action() async {
    await repository.setIsOnboardingFinished();
  }

  return action;
});

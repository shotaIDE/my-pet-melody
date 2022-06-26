import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';

final submissionUseCaseProvider = Provider(
  (ref) => SubmissionUseCase(
    repository: ref.watch(submissionRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    authService: ref.watch(authServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    pushNotificationService: ref.watch(pushNotificationServiceProvider),
  ),
);

final settingsUseCaseProvider = Provider(
  (ref) => SettingsUseCase(
    repository: ref.watch(settingsRepositoryProvider),
  ),
);

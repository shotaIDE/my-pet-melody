import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/usecase/auth_use_case.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';

final authUseCaseProvider = Provider(
  (ref) => AuthUseCase(
    authService: ref.watch(authServiceProvider),
    databaseService: ref.watch(databaseServiceProvider),
    pushNotificationService: ref.watch(pushNotificationServiceProvider),
  ),
);

final pieceUseCaseProvider = Provider(
  (ref) => PieceUseCase(
    authService: ref.watch(authServiceProvider),
    databaseService: ref.watch(databaseServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  ),
);

final submissionUseCaseProvider = Provider(
  (ref) => SubmissionUseCase(
    repository: ref.watch(submissionRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    authService: ref.watch(authServiceProvider),
    databaseService: ref.watch(databaseServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    pushNotificationService: ref.watch(pushNotificationServiceProvider),
  ),
);

final settingsUseCaseProvider = Provider(
  (ref) => SettingsUseCase(
    repository: ref.watch(settingsRepositoryProvider),
  ),
);

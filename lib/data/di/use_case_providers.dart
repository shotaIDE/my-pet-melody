import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/usecase/piece_use_case.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';

final pieceUseCaseProvider = Provider(
  (ref) => PieceUseCase(
    repository: ref.watch(pieceRepositoryProvider),
  ),
);

final submissionUseCaseProvider = Provider(
  (ref) => SubmissionUseCase(
    repository: ref.watch(submissionRepositoryProvider),
    pieceRepository: ref.watch(pieceRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
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

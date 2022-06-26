import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';

final submissionUseCaseProvider = FutureProvider(
  (ref) async {
    final session = await ref.watch(sessionStreamProvider.future);

    return SubmissionUseCase(
      session: session,
      repository: ref.watch(submissionRepositoryProvider),
      settingsRepository: ref.watch(settingsRepositoryProvider),
      pushNotificationService: ref.watch(pushNotificationServiceProvider),
    );
  },
);

final settingsUseCaseProvider = Provider(
  (ref) => SettingsUseCase(
    repository: ref.watch(settingsRepositoryProvider),
  ),
);

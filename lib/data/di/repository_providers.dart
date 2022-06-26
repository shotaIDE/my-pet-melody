import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/local_data_source_providers.dart';
import 'package:meow_music/data/di/remote_data_source_providers.dart';
import 'package:meow_music/data/repository/settings_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';

final submissionRepositoryProvider = Provider(
  (ref) => SubmissionRepository(
    remoteDataSource: ref.watch(submissionRemoteDataSourceProvider),
  ),
);

final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(
    localDataSource: ref.watch(
      settingsLocalDataSourceProvider,
    ),
  ),
);

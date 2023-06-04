import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/di/local_data_source_providers.dart';
import 'package:my_pet_melody/data/di/remote_data_source_providers.dart';
import 'package:my_pet_melody/data/repository/settings_repository.dart';
import 'package:my_pet_melody/data/repository/submission_repository.dart';

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

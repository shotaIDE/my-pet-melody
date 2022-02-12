import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/local_data_source_providers.dart';
import 'package:meow_music/data/repository/piece_repository.dart';
import 'package:meow_music/data/repository/settings_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';

final pieceRepositoryProvider = Provider(
  (_) => PieceRepository(),
);

final submissionRepositoryProvider = Provider(
  (_) => SubmissionRepository(),
);

final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(
    localDataSource: ref.watch(
      settingsLocalDataSourceProvider,
    ),
  ),
);

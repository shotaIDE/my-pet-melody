import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';

final settingsUseCaseProvider = Provider(
  (ref) => SettingsUseCase(
    repository: ref.watch(settingsRepositoryProvider),
  ),
);

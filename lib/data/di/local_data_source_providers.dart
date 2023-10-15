import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/repository/local/settings_local_data_source.dart';
import 'package:my_pet_melody/data/service/preference_service.dart';

final settingsLocalDataSourceProvider = Provider(
  (ref) => SettingsLocalDataSource(
    preferenceService: ref.watch(preferenceServiceProvider),
  ),
);

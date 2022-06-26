import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/repository/local/settings_local_data_source.dart';

final settingsLocalDataSourceProvider = Provider(
  (_) => SettingsLocalDataSource(),
);

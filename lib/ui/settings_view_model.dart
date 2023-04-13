import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/settings_state.dart';

class SettingsViewModel extends StateNotifier<SettingsState> {
  SettingsViewModel() : super(const SettingsState());
}

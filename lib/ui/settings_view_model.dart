import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/settings_state.dart';

class SettingsViewModel extends StateNotifier<SettingsState> {
  SettingsViewModel({
    required Ref ref,
  })  : _ref = ref,
        super(
          const SettingsState(),
        );

  final Ref _ref;

  Future<void> deleteAccount() async {
    debugPrint('Delete');
  }
}

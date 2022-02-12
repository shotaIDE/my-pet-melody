import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/root_state.dart';

class RootViewModel extends StateNotifier<RootState> {
  RootViewModel({
    required SettingsUseCase settingsUseCase,
  })  : _settingsUseCase = settingsUseCase,
        super(const RootState()) {
    _setup();
  }

  final SettingsUseCase _settingsUseCase;

  Future<void> _setup() async {
    final isOnboardingFinished =
        await _settingsUseCase.getIsOnboardingFinished();

    state = state.copyWith(shouldLaunchOnboarding: !isOnboardingFinished);
  }
}

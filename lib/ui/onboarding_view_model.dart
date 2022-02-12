import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/ui/onboarding_state.dart';

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel({
    required SettingsUseCase settingsUseCase,
  })  : _settingsUseCase = settingsUseCase,
        super(const OnboardingState());

  final SettingsUseCase _settingsUseCase;

  Future<void> onDone() async {
    await _settingsUseCase.onOnboardingFinished();
  }
}

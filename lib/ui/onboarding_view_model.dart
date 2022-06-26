import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/ui/onboarding_state.dart';

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel({required Reader reader})
      : _reader = reader,
        super(const OnboardingState());

  final Reader _reader;

  Future<void> onDone() async {
    await _reader(finishOnboardingActionProvider).call();
  }
}

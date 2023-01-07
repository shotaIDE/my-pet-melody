import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/ui/onboarding_state.dart';

class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel({required Ref ref})
      : _ref = ref,
        super(const OnboardingState());

  final Ref _ref;

  Future<void> onDone() async {
    await _ref.read(settingsActionsProvider).onOnboardingFinished();
  }
}

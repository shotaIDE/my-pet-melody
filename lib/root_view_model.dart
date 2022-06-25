import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/service/database_provider.dart';
import 'package:meow_music/data/usecase/auth_use_case.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/root_state.dart';

class RootViewModel extends StateNotifier<RootState> {
  RootViewModel({
    required Reader reader,
    required Stream<String> registrationTokenStream,
    required AuthUseCase authUseCase,
    required SettingsUseCase settingsUseCase,
  })  : _authUseCase = authUseCase,
        _settingsUseCase = settingsUseCase,
        super(const RootState()) {
    _setup(reader: reader, registrationTokenStream: registrationTokenStream);
  }

  final AuthUseCase _authUseCase;
  final SettingsUseCase _settingsUseCase;

  late StreamSubscription<void> _storeTokenSubscription;

  @override
  Future<void> dispose() async {
    await _storeTokenSubscription.cancel();

    super.dispose();
  }

  Future<void> _setup({
    required Reader reader,
    required Stream<String> registrationTokenStream,
  }) async {
    await _authUseCase.ensureLoggedIn();

    final isOnboardingFinished =
        await _settingsUseCase.getIsOnboardingFinished();

    state = state.copyWith(shouldLaunchOnboarding: !isOnboardingFinished);

    _storeTokenSubscription =
        registrationTokenStream.listen((registrationToken) {
      reader(registrationTokenSenderProvider)
          .sendRegistrationTokenIfNeeded(registrationToken);
    });
  }
}

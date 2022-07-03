import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/definitions/types.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/usecase/auth_use_case.dart';
import 'package:meow_music/data/usecase/settings_use_case.dart';
import 'package:meow_music/root_state.dart';

class RootViewModel extends StateNotifier<RootState> {
  RootViewModel({
    required Reader reader,
    required Listener listener,
  }) : super(const RootState()) {
    _setup(
      reader: reader,
      listener: listener,
    );
  }

  Future<void> _setup({
    required Reader reader,
    required Listener listener,
  }) async {
    await reader(ensureLoggedInActionProvider.future);

    final isOnboardingFinished =
        await reader(settingsActionsProvider).getIsOnboardingFinished();

    state = state.copyWith(shouldLaunchOnboarding: !isOnboardingFinished);

    listener<Future<String?>>(
      registrationTokenProvider.future,
      (_, next) async {
        final registrationToken = await next;
        if (registrationToken == null) {
          return;
        }

        final databaseActions = await reader(databaseActionsProvider.future);
        await databaseActions.sendRegistrationTokenIfNeeded(registrationToken);
      },
      fireImmediately: true,
    );
  }
}

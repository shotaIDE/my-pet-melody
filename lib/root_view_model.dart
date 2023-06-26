import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/types.dart';
import 'package:my_pet_melody/data/service/database_service.dart';
import 'package:my_pet_melody/data/service/remote_config_service.dart';
import 'package:my_pet_melody/data/usecase/app_use_case.dart';
import 'package:my_pet_melody/data/usecase/auth_use_case.dart';
import 'package:my_pet_melody/root_state.dart';

final rootViewModelProvider =
    StateNotifierProvider.autoDispose<RootViewModel, RootState>(
  (ref) => RootViewModel(
    ref: ref,
    listener: ref.listen,
  ),
);

class RootViewModel extends StateNotifier<RootState> {
  RootViewModel({
    required Ref ref,
    required Listener listener,
  })  : _ref = ref,
        _listener = listener,
        super(const RootState()) {
    _setup();
  }

  final Ref _ref;
  final Listener _listener;

  Future<void> restart() async {
    state = state.copyWith(startPage: null);

    // Wait a bit so that the splash screen appears
    // and the routes replacement runs.
    await Future<void>.delayed(const Duration(seconds: 1));

    await _determineStartPage();
  }

  Future<void> _setup() async {
    await _determineStartPage();

    await _ref.read(ensureSetupPushNotificationActionProvider).call();

    _listener<Future<String?>>(
      registrationTokenProvider.future,
      (_, next) async {
        final registrationToken = await next;
        if (registrationToken == null) {
          return;
        }

        final databaseActions = await _ref.read(databaseActionsProvider.future);
        await databaseActions.sendRegistrationTokenIfNeeded(registrationToken);
      },
      fireImmediately: true,
    );

    _listener<Future<Set<String>>>(
      updatedRemoteConfigKeysProvider.future,
      (_, next) async {
        // Observe remote config changes so that they will be activated
        // the next time app launches. Even if the monitor does not do anything,
        // the library will retain the changed values.
        // https://firebase.google.com/docs/remote-config/loading#strategy_3_load_new_values_for_next_startup
        final configKeys = await next;

        debugPrint('Updated remote config keys: $configKeys');
      },
      fireImmediately: true,
    );
  }

  Future<void> _determineStartPage() async {
    await _ref.read(ensureActivateFetchedRemoteConfigsActionProvider).call();

    final shouldUpdateApp = await _ref.read(shouldUpdateAppProvider.future);

    if (shouldUpdateApp) {
      state = state.copyWith(startPage: StartPage.updateApp);

      return;
    }

    final isLoggedIn =
        await _ref.read(ensureDetermineIfLoggedInActionProvider.future);

    final startPage = isLoggedIn ? StartPage.home : StartPage.login;
    state = state.copyWith(startPage: startPage);
  }
}

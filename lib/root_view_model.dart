import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/definitions/types.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/usecase/auth_use_case.dart';
import 'package:meow_music/root_state.dart';

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
    state = state.copyWith(showHomeScreen: null);

    // Wait a bit so that the splash screen appears
    // and the routes replacement runs.
    await Future<void>.delayed(const Duration(seconds: 1));

    await _determineStartPage();
  }

  Future<void> _setup() async {
    await _determineStartPage();

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
  }

  Future<void> _determineStartPage() async {
    final isLoggedIn =
        await _ref.read(ensureDetermineIfLoggedInActionProvider.future);

    state = state.copyWith(showHomeScreen: isLoggedIn);
  }
}

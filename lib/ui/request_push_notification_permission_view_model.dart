import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';

class RequestPushNotificationPermissionViewModel
    extends StateNotifier<RequestPushNotificationPermissionState> {
  RequestPushNotificationPermissionViewModel({
    required Reader reader,
    required RequestPushNotificationPermissionArgs args,
  })  : _reader = reader,
        _args = args,
        super(
          const RequestPushNotificationPermissionState(),
        );

  final Reader _reader;
  final RequestPushNotificationPermissionArgs _args;

  Future<void> requestPermissionAndSubmit() async {
    await _reader(requestPushNotificationPermissionActionProvider).call();

    await _submit();
  }

  Future<void> submit() async {
    await _submit();
  }

  Future<void> _submit() async {
    state = state.copyWith(isProcessing: true);

    final submitAction = await _reader(submitActionProvider.future);
    await submitAction(
      template: _args.template,
      sounds: _args.sounds,
    );

    state = state.copyWith(isProcessing: false);
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/use_case_providers.dart';
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
    final submissionUseCase = await _reader(submissionUseCaseProvider.future);
    await submissionUseCase.requestPushNotificationPermission();

    await _submit();
  }

  Future<void> submit() async {
    await _submit();
  }

  Future<void> _submit() async {
    state = state.copyWith(isProcessing: true);

    final submissionUseCase = await _reader(submissionUseCaseProvider.future);

    await submissionUseCase.submit(
      template: _args.template,
      sounds: _args.sounds,
    );

    state = state.copyWith(isProcessing: false);
  }
}

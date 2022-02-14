import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';

class RequestPushNotificationPermissionViewModel
    extends StateNotifier<RequestPushNotificationPermissionState> {
  RequestPushNotificationPermissionViewModel({
    required SubmissionUseCase submissionUseCase,
    required RequestPushNotificationPermissionArgs args,
  })  : _submissionUseCase = submissionUseCase,
        _args = args,
        super(
          const RequestPushNotificationPermissionState(),
        );

  final SubmissionUseCase _submissionUseCase;
  final RequestPushNotificationPermissionArgs _args;

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    // await _submissionUseCase.submit(
    //   template: state.template.template,
    //   soundIdList: soundIdList,
    // );

    state = state.copyWith(isProcessing: false);
  }
}

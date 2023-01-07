import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:path/path.dart';

class RequestPushNotificationPermissionViewModel
    extends StateNotifier<RequestPushNotificationPermissionState> {
  RequestPushNotificationPermissionViewModel({
    required Ref ref,
    required RequestPushNotificationPermissionArgs args,
  })  : _ref = ref,
        _args = args,
        super(
          const RequestPushNotificationPermissionState(),
        );

  final Ref _ref;
  final RequestPushNotificationPermissionArgs _args;

  Future<void> requestPermissionAndSubmit() async {
    await _ref.read(requestPushNotificationPermissionActionProvider).call();

    await _submit();
  }

  Future<void> submit() async {
    await _submit();
  }

  Future<void> _submit() async {
    state = state.copyWith(isProcessing: true);

    final thumbnailLocalPath = _args.thumbnailLocalPath;
    final thumbnail = File(thumbnailLocalPath);

    final uploadAction = await _ref.read(uploadActionProvider.future);
    final uploadedThumbnail = await uploadAction(
      thumbnail,
      fileName: basename(thumbnailLocalPath),
    );

    if (uploadedThumbnail == null) {
      return;
    }

    final submitAction = await _ref.read(submitActionProvider.future);
    await submitAction(
      template: _args.template,
      sounds: _args.sounds,
      displayName: _args.displayName,
      thumbnail: uploadedThumbnail,
    );

    state = state.copyWith(isProcessing: false);
  }
}

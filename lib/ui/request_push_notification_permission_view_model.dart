import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:path/path.dart';

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

    final thumbnailPath = _args.thumbnailPath;
    final thumbnail = File(thumbnailPath);

    final uploadAction = await _reader(uploadActionProvider.future);
    final uploadedThumbnail = await uploadAction(
      thumbnail,
      fileName: basename(thumbnailPath),
    );

    if (uploadedThumbnail == null) {
      return;
    }

    final submitAction = await _reader(submitActionProvider.future);
    await submitAction(
      template: _args.template,
      sounds: _args.sounds,
      displayName: _args.displayName,
      thumbnail: uploadedThumbnail,
    );

    state = state.copyWith(isProcessing: false);
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_media.dart';

part 'request_push_notification_permission_state.freezed.dart';

@freezed
class RequestPushNotificationPermissionState
    with _$RequestPushNotificationPermissionState {
  const factory RequestPushNotificationPermissionState({
    @Default(false) bool isProcessing,
  }) = _RequestPushNotificationPermissionState;
}

@freezed
class RequestPushNotificationPermissionArgs
    with _$RequestPushNotificationPermissionArgs {
  const factory RequestPushNotificationPermissionArgs({
    required Template template,
    required List<UploadedMedia> sounds,
    required String displayName,
    required String thumbnailLocalPath,
  }) = _RequestPushNotificationPermissionArgs;
}

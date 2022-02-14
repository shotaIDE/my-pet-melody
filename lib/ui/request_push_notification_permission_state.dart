import 'package:freezed_annotation/freezed_annotation.dart';

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
  const factory RequestPushNotificationPermissionArgs() =
      _RequestPushNotificationPermissionArgs;
}

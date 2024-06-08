import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';

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
    required LocalizedTemplate template,
    required List<UploadedMedia> sounds,
    required String displayName,
    required String thumbnailLocalPath,
  }) = _RequestPushNotificationPermissionArgs;
}

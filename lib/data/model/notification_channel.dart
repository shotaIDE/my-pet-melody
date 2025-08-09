import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_channel.freezed.dart';

@freezed
abstract class NotificationChannel with _$NotificationChannel {
  const factory NotificationChannel({
    required String id,
    required String title,
    required String description,
    required String groupId,
  }) = _NotificationChannel;
}

@freezed
abstract class NotificationChannelGroup with _$NotificationChannelGroup {
  const factory NotificationChannelGroup({
    required String id,
    required String title,
    required String description,
  }) = _NotificationChannelGroup;
}

import 'package:collection/collection.dart';
import 'package:my_pet_melody/data/model/notification_channel.dart';

const _makePieceGroup = NotificationChannelGroup(
  id: 'make_piece',
  title: '作品をつくる',
  description: '作品をつくるときの通知です。',
);

final _completedToGeneratePiece = NotificationChannel(
  id: 'completed_to_generate_piece',
  title: '完成した',
  description: '作品が完成したときにすぐにお知らせします。',
  groupId: _makePieceGroup.id,
);

final _groups = [
  _makePieceGroup,
];

final _notificationChannels = [
  _completedToGeneratePiece,
];

List<NotificationChannelGroup> get allNotificationChannelGroups {
  return [..._groups];
}

List<NotificationChannel> get allNotificationChannels {
  return [..._notificationChannels];
}

NotificationChannel? getNotificationChannel({required String id}) {
  final channel =
      _notificationChannels.firstWhereOrNull((channel) => channel.id == id);
  return channel;
}

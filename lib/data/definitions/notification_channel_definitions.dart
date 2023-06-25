import 'package:collection/collection.dart';
import 'package:my_pet_melody/data/model/notification_channel.dart';

class NotificationChannelDefinitions {
  static const _makePieceGroup = NotificationChannelGroup(
    id: 'make_piece',
    title: '作品をつくる',
    description: '作品をつくるときの通知です。',
  );

  static final _completedToGeneratePiece = NotificationChannel(
    id: 'completed_to_generate_piece',
    title: '完成した',
    description: '作品が完成したときにすぐにお知らせします。',
    groupId: _makePieceGroup.id,
  );

  static final _groups = [
    _makePieceGroup,
  ];

  static final _notificationChannels = [
    _completedToGeneratePiece,
  ];

  static List<NotificationChannelGroup> get allGroups {
    return [..._groups];
  }

  static List<NotificationChannel> get allChannels {
    return [..._notificationChannels];
  }

  static NotificationChannel? getChannel({required String id}) {
    final channel =
        _notificationChannels.firstWhereOrNull((channel) => channel.id == id);
    return channel;
  }
}

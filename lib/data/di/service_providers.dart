import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/service/push_notification_service.dart';

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

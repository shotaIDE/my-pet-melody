import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();

      // iOSでアプリがフォアグラウンドに表示されている際にも通知を表示する
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin!.requestPermission();
    }
  }

  Future<void> setupNotification() async {
    if (!Platform.isAndroid) {
      return;
    }

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    const generatePieceNotificationChannelGroupId = 'create_piece';
    await androidPlugin?.createNotificationChannelGroup(
      const AndroidNotificationChannelGroup(
        generatePieceNotificationChannelGroupId,
        '作品をつくる',
        description: '作品をつくるときの通知です。',
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'completed_to_generate_piece',
        '完成した',
        description: '作品が完成したときにすぐにお知らせします。',
        groupId: generatePieceNotificationChannelGroupId,
      ),
    );
  }

  Future<String?> registrationToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteRegistrationToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> showDummyNotification() async {
    await _plugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );

    await _plugin.show(
      0,
      '作品が完成しました！',
      'Happy Birthday を使った作品が完成しました',
      const NotificationDetails(),
    );
  }
}

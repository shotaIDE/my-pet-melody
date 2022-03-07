import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
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
    }
  }

  Future<void> showDummyNotification() async {
    final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: IOSInitializationSettings(),
      ),
    );

    await localNotificationsPlugin.show(
      0,
      '作品が完成しました！',
      'Happy Birthday を使った作品が完成しました',
      const NotificationDetails(),
    );
  }
}

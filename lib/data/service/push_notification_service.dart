import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/notification_channel_definitions.dart';

final Provider<PushNotificationService> pushNotificationServiceProvider =
    Provider(
  (ref) {
    final pushNotificationService = PushNotificationService();

    ref.onDispose(() async {
      await pushNotificationService.dispose();
    });

    return pushNotificationService;
  },
);

class PushNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  StreamSubscription<void>? _androidForegroundNotificationSubscription;

  Future<void> setupNotification() async {
    if (!Platform.isAndroid) {
      return;
    }

    await _setupAndroidNotificationChannels();

    await _setupAndroidLocalNotification();

    _androidForegroundNotificationSubscription =
        FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) {
        return;
      }

      final androidNotification = notification.android;
      if (androidNotification == null) {
        return;
      }

      // Notifications will not displayed when the app is in the foreground,
      // display manually.
      _showAndroidLocalNotification(
        notification,
        androidNotification,
      );
    });
  }

  Future<void> dispose() async {
    await _androidForegroundNotificationSubscription?.cancel();
  }

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

      await androidPlugin!.requestNotificationsPermission();
    }
  }

  Future<String?> registrationToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteRegistrationToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> _setupAndroidNotificationChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    for (final group in allNotificationChannelGroups) {
      await androidPlugin?.createNotificationChannelGroup(
        AndroidNotificationChannelGroup(
          group.id,
          group.title,
          description: group.description,
        ),
      );
    }

    for (final channel in allNotificationChannels) {
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          channel.id,
          channel.title,
          description: channel.description,
          groupId: channel.groupId,
          // Set the importance level to High to display as heads up.
          importance: Importance.high,
        ),
      );
    }
  }

  Future<void> _setupAndroidLocalNotification() async {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('drawable/ic_notification'),
      ),
    );
  }

  Future<void> _showAndroidLocalNotification(
    RemoteNotification notification,
    AndroidNotification androidNotification,
  ) async {
    final channelId = androidNotification.channelId;
    if (channelId == null) {
      return;
    }

    final channel = getNotificationChannel(id: channelId);
    if (channel == null) {
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.title,
      ),
    );

    await _plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
    );
  }
}

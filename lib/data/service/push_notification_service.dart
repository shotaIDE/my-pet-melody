import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_pet_melody/data/definitions/notification_channels.dart';

class PushNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  StreamSubscription<void>? _foregroundNotificationSubscription;

  Future<void> setupNotification() async {
    if (!Platform.isAndroid) {
      return;
    }

    await _setupAndroidNotificationChannels();

    await _initializeLocalNotification();

    _foregroundNotificationSubscription =
        FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) {
        return;
      }

      // アプリがフォアグラウンドに表示されている際は通知が表示されないため、
      // 手動で表示する必要がある
      _showLocalNotification(
        notification,
        notification.android,
        message.data,
      );
    });
  }

  Future<void> dispose() async {
    await _foregroundNotificationSubscription?.cancel();
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

      await androidPlugin!.requestPermission();
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

    final notificationChannelGroups = NotificationChannelDefinitions.allGroups;
    for (final group in notificationChannelGroups) {
      await androidPlugin?.createNotificationChannelGroup(
        AndroidNotificationChannelGroup(
          group.id,
          group.title,
          description: group.description,
        ),
      );
    }

    final notificationChannels = NotificationChannelDefinitions.allChannels;
    for (final channel in notificationChannels) {
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          channel.id,
          channel.title,
          description: channel.description,
          groupId: channel.groupId,
          // HeadsUp通知にするため重要度をHighに設定している
          importance: Importance.high,
        ),
      );
    }
  }

  Future<void> _initializeLocalNotification() async {
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_notification'),
      ),
    );
  }

  Future<void> _showLocalNotification(
    RemoteNotification notification,
    AndroidNotification? androidNotification,
    Map<String, dynamic> data,
  ) async {
    final NotificationDetails? details;
    if (androidNotification != null) {
      final channelId = androidNotification.channelId;
      if (channelId == null) {
        return;
      }

      final channel = NotificationChannelDefinitions.getChannel(id: channelId);
      if (channel == null) {
        return;
      }

      details = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.title,
          channelDescription: channel.description,
        ),
      );
    } else {
      details = null;
    }

    await _plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/service/database_service_firebase.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:meow_music/data/service/storage_service_firebase.dart';

final authServiceProvider = Provider(
  (_) => AuthService(),
);

final databaseServiceProvider = Provider<DatabaseService>(
  (_) => DatabaseServiceFirebase(),
);

final storageServiceProvider = Provider<StorageService>(
  (_) => StorageServiceFirebase(),
);

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

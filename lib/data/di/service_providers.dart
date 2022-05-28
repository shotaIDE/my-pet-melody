import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/api_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/service/database_service_firebase.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:meow_music/data/service/storage_service_local_flask.dart';

final authServiceProvider = Provider(
  (_) => AuthService(),
);

final databaseServiceProvider = Provider<DatabaseService>(
  (_) => DatabaseServiceFirebase(),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageServiceLocalFlask(
    api: ref.watch(storageApiProvider),
  ),
);

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

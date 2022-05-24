import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/database_service.dart';
import 'package:meow_music/data/service/database_service_firebase.dart';
import 'package:meow_music/data/service/database_service_local_flask.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:meow_music/data/service/storage_service_firebase.dart';
import 'package:meow_music/data/service/storage_service_local_flask.dart';
import 'package:meow_music/flavor.dart';

final authServiceProvider = Provider(
  (_) => AuthService(),
);

final databaseServiceProvider = Provider<DatabaseService>(
  (_) {
    if (F.flavor == Flavor.local) {
      return DatabaseServiceLocalFlask();
    }
    return DatabaseServiceFirebase();
  },
);

final storageServiceProvider = Provider<StorageService>(
  (_) {
    if (F.flavor == Flavor.local) {
      return StorageServiceLocalFlask();
    }
    return StorageServiceFirebase();
  },
);

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/api_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:meow_music/data/service/storage_service_firebase.dart';
import 'package:meow_music/data/service/storage_service_local_flask.dart';
import 'package:meow_music/flavor.dart';

final authServiceProvider = Provider(
  (_) => AuthService(),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) {
    if (F.flavor == Flavor.emulator) {
      // Firebase Emulator の Python クライアントはまだ Storage に対応していないので、
      // Flask のエンドポイントを利用する
      return StorageServiceLocalFlask(
        api: ref.watch(storageApiProvider),
      );
    }
    return StorageServiceFirebase();
  },
);

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

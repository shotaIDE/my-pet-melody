import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/api_providers.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:meow_music/data/service/storage_service_firebase.dart';
import 'package:meow_music/data/service/storage_service_local_flask.dart';

final storageServiceProvider = FutureProvider<StorageService>(
  (ref) async {
    final session = await ref.watch(sessionStreamProvider.future);

    return StorageServiceFirebase(session: session);
  },
);

final storageServiceFlaskProvider = FutureProvider<StorageService>(
  (ref) => StorageServiceLocalFlask(
    api: ref.watch(storageApiProvider),
  ),
);

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

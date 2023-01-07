import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';
import 'package:meow_music/data/service/storage_service_firebase.dart';

final storageServiceProvider = FutureProvider<StorageService>(
  (ref) async {
    final session = await ref.watch(sessionStreamProvider.future);

    return StorageServiceFirebase(session: session);
  },
);

final pushNotificationServiceProvider = Provider(
  (_) => PushNotificationService(),
);

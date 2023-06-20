import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/di/repository_providers.dart';
import 'package:my_pet_melody/data/di/service_providers.dart';
import 'package:my_pet_melody/data/model/movie_segmentation.dart';
import 'package:my_pet_melody/data/model/template.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';
import 'package:my_pet_melody/data/service/app_service.dart';
import 'package:my_pet_melody/data/service/auth_service.dart';

final detectActionProvider = FutureProvider((ref) async {
  final session = await ref.watch(sessionStreamProvider.future);
  final storageService = await ref.read(storageServiceProvider.future);
  final repository = ref.read(submissionRepositoryProvider);

  Future<MovieSegmentation?> action(
    File file, {
    required String fileName,
  }) async {
    final uploaded = await storageService.uploadUnedited(
      file,
      fileName: fileName,
    );
    if (uploaded == null) {
      return null;
    }

    return repository.detect(
      from: uploaded,
      token: session.token,
    );
  }

  return action;
});

final uploadActionProvider = FutureProvider((ref) async {
  final storageService = await ref.read(storageServiceProvider.future);

  return storageService.uploadEdited;
});

final getShouldShowRequestPushNotificationPermissionActionProvider =
    Provider((ref) {
  final settingsRepository = ref.read(settingsRepositoryProvider);
  final androidDeviceSdkIntFuture =
      ref.read(androidDeviceSdkIntProvider.future);

  Future<bool> action() async {
    if (Platform.isIOS ||
            (Platform.isAndroid &&
                await androidDeviceSdkIntFuture >= 33) // Android 13 or higher
        ) {
      final hasRequestedPermission = await settingsRepository
          .getHasRequestedPushNotificationPermissionAtLeastOnce();

      return !hasRequestedPermission;
    }

    return false;
  }

  return action;
});

final requestPushNotificationPermissionActionProvider = Provider((ref) {
  final pushNotificationService = ref.read(pushNotificationServiceProvider);
  final settingsRepository = ref.read(settingsRepositoryProvider);

  Future<void> action() async {
    await pushNotificationService.requestPermission();

    await settingsRepository
        .setHasRequestedPushNotificationPermissionAtLeastOnce();
  }

  return action;
});

final submitActionProvider = FutureProvider((ref) async {
  final session = await ref.watch(sessionStreamProvider.future);
  final repository = ref.read(submissionRepositoryProvider);

  Future<void> action({
    required Template template,
    required List<UploadedMedia> sounds,
    required String displayName,
    required UploadedMedia thumbnail,
  }) async {
    await repository.submit(
      templateId: template.id,
      sounds: sounds,
      displayName: displayName,
      thumbnail: thumbnail,
      token: session.token,
    );
  }

  return action;
});

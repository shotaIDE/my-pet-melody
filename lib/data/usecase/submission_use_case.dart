import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/service/auth_service.dart';

final detectActionProvider = FutureProvider((ref) async {
  final session = await ref.watch(sessionStreamProvider.future);
  final storageService = await ref.read(storageServiceProvider.future);
  final repository = ref.read(submissionRepositoryProvider);

  Future<DetectedNonSilentSegments?> action(
    File file, {
    required String fileName,
  }) async {
    final uploaded = await storageService.uploadOriginal(
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

  return storageService.uploadTrimmed;
});

final getShouldShowRequestPushNotificationPermissionActionProvider =
    Provider((ref) {
  final settingsRepository = ref.read(settingsRepositoryProvider);

  Future<bool> action() async {
    if (Platform.isAndroid) {
      return false;
    }

    final hasRequestedPermission = await settingsRepository
        .getHasRequestedPushNotificationPermissionAtLeastOnce();

    return !hasRequestedPermission;
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
    required List<UploadedSound> sounds,
    required String displayName,
  }) async {
    await repository.submit(
      templateId: template.id,
      sounds: sounds,
      displayName: displayName,
      token: session.token,
    );
  }

  return action;
});

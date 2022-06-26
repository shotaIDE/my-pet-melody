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
  final storageService = ref.read(storageServiceProvider);
  final repository = ref.read(submissionRepositoryProvider);

  Future<DetectedNonSilentSegments?> action(
    File file, {
    required String fileName,
  }) async {
    final uploaded = await storageService.uploadOriginal(
      file,
      fileName: fileName,
      userId: session.userId,
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
  final session = await ref.watch(sessionStreamProvider.future);
  final storageService = ref.read(storageServiceProvider);

  Future<UploadedSound?> action(
    File file, {
    required String fileName,
  }) async {
    return storageService.uploadTrimmed(
      file,
      fileName: fileName,
      userId: session.userId,
    );
  }

  return action;
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
  }) async {
    await repository.submit(
      templateId: template.id,
      sounds: sounds,
      token: session.token,
    );
  }

  return action;
});

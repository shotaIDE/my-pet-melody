import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/repository_providers.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/login_session.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/repository/settings_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/push_notification_service.dart';

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

class SubmissionUseCase {
  SubmissionUseCase({
    required LoginSession session,
    required SubmissionRepository repository,
    required SettingsRepository settingsRepository,
    required PushNotificationService pushNotificationService,
  })  : _session = session,
        _repository = repository,
        _settingsRepository = settingsRepository,
        _pushNotificationService = pushNotificationService;

  final LoginSession _session;
  final SubmissionRepository _repository;
  final SettingsRepository _settingsRepository;
  final PushNotificationService _pushNotificationService;

  Future<bool> getShouldShowRequestPushNotificationPermission() async {
    if (Platform.isAndroid) {
      return false;
    }

    final hasRequestedPermission = await _settingsRepository
        .getHasRequestedPushNotificationPermissionAtLeastOnce();

    return !hasRequestedPermission;
  }

  Future<void> requestPushNotificationPermission() async {
    await _pushNotificationService.requestPermission();

    await _settingsRepository
        .setHasRequestedPushNotificationPermissionAtLeastOnce();
  }

  Future<void> submit({
    required Template template,
    required List<UploadedSound> sounds,
  }) async {
    await _repository.submit(
      templateId: template.id,
      sounds: sounds,
      token: _session.token,
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/login_session.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/repository/settings_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';
import 'package:meow_music/data/service/push_notification_service.dart';
import 'package:meow_music/data/service/storage_service.dart';

class SubmissionUseCase {
  SubmissionUseCase({
    required LoginSession session,
    required SubmissionRepository repository,
    required SettingsRepository settingsRepository,
    required StorageService storageService,
    required PushNotificationService pushNotificationService,
  })  : _session = session,
        _repository = repository,
        _settingsRepository = settingsRepository,
        _storageService = storageService,
        _pushNotificationService = pushNotificationService;

  final LoginSession _session;
  final SubmissionRepository _repository;
  final SettingsRepository _settingsRepository;
  final StorageService _storageService;
  final PushNotificationService _pushNotificationService;

  Future<DetectedNonSilentSegments?> detect(
    File file, {
    required String fileName,
  }) async {
    final uploaded = await _storageService.uploadOriginal(
      file,
      fileName: fileName,
      userId: _session.userId,
    );
    if (uploaded == null) {
      return null;
    }

    return _repository.detect(
      from: uploaded,
      token: _session.token,
    );
  }

  Future<UploadedSound?> upload(
    File file, {
    required String fileName,
  }) async {
    return _storageService.uploadTrimmed(
      file,
      fileName: fileName,
      userId: _session.userId,
    );
  }

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

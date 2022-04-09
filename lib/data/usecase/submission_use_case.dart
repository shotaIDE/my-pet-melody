import 'dart:async';
import 'dart:io';

import 'package:meow_music/data/model/non_silence_segment.dart';
import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/repository/piece_repository.dart';
import 'package:meow_music/data/repository/settings_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';
import 'package:meow_music/data/service/push_notification_service.dart';

class SubmissionUseCase {
  SubmissionUseCase({
    required SubmissionRepository repository,
    required PieceRepository pieceRepository,
    required SettingsRepository settingsRepository,
    required PushNotificationService pushNotificationService,
  })  : _repository = repository,
        _pieceRepository = pieceRepository,
        _settingsRepository = settingsRepository,
        _pushNotificationService = pushNotificationService;

  final SubmissionRepository _repository;
  final PieceRepository _pieceRepository;
  final SettingsRepository _settingsRepository;
  final PushNotificationService _pushNotificationService;

  Future<List<Template>> getTemplates() async {
    return _repository.getTemplates();
  }

  Future<UploadedSound?> upload(
    File file, {
    required String fileName,
  }) async {
    return _repository.upload(
      file,
      fileName: fileName,
    );
  }

  Future<List<NonSilenceSegment>?> detectNonSilence(File file) async {
    return _repository.detectNonSilence(file);
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
    final generated = await _repository.submit(
      userId: 'test-user-id',
      templateId: template.id,
      sounds: sounds,
    );

    if (generated == null) {
      return;
    }

    final generating = PieceGenerating(
      id: generated.id,
      name: template.name,
      submittedAt: DateTime.now(),
    );

    unawaited(
      _setTimerToNotifyCompletingToGenerate(
        generating: generating,
        url: generated.url,
      ),
    );
  }

  Future<void> _setTimerToNotifyCompletingToGenerate({
    required PieceGenerating generating,
    required String url,
  }) async {
    await _pieceRepository.add(generating);

    await Future<void>.delayed(const Duration(seconds: 5));

    final generated = PieceGenerated(
      id: generating.id,
      name: generating.name,
      generatedAt: DateTime.now(),
      url: url,
    );

    await _pieceRepository.replace(generated);

    await _pushNotificationService.showDummyNotification();
  }
}

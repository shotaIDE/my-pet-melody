import 'dart:async';
import 'dart:io';

import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/repository/piece_repository.dart';
import 'package:meow_music/data/repository/submission_repository.dart';

class SubmissionUseCase {
  SubmissionUseCase({
    required SubmissionRepository repository,
    required PieceRepository pieceRepository,
  })  : _repository = repository,
        _pieceRepository = pieceRepository;

  final SubmissionRepository _repository;
  final PieceRepository _pieceRepository;

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

  Future<void> submit({
    required Template template,
    required List<String> soundIdList,
  }) async {
    final generated = await _repository.submit(
      userId: 'test-user-id',
      templateId: template.id,
      soundIdList: soundIdList,
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
  }
}

import 'dart:async';
import 'dart:io';

import 'package:meow_music/data/model/piece.dart';
import 'package:meow_music/data/model/piece_status.dart';
import 'package:meow_music/data/model/template.dart';
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

  Future<String?> upload(
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
    required List<String> remoteFileNames,
  }) async {
    final generated = await _repository.submit(
      userId: 'test-user-id',
      templateId: template.id,
      remoteFileNames: remoteFileNames,
    );

    if (generated == null) {
      return;
    }

    final piece = Piece(
      id: generated.id,
      name: template.name,
      status: PieceStatus.generated(generated: DateTime.now()),
      url: generated.url,
    );

    unawaited(_setTimerToNotify(piece: piece));
  }

  Future<void> _setTimerToNotify({required Piece piece}) async {
    await Future<void>.delayed(const Duration(seconds: 3));

    await _pieceRepository.addPiece(piece);
  }
}

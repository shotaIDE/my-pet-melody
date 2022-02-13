import 'dart:io';

import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/repository/submission_repository.dart';

class SubmissionUseCase {
  SubmissionUseCase({required SubmissionRepository repository})
      : _repository = repository;

  final SubmissionRepository _repository;

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
    required String templateId,
    required List<String> remoteFileNames,
  }) async {
    return _repository.submit(
      userId: 'test-user-id',
      templateId: templateId,
      remoteFileNames: remoteFileNames,
    );
  }
}

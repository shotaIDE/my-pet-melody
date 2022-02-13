import 'dart:io';

import 'package:meow_music/data/api/submission_api.dart';

class SubmissionRemoteDataSource {
  SubmissionRemoteDataSource({required SubmissionApi api}) : _api = api;

  final SubmissionApi _api;

  Future<String?> upload(
    File file, {
    required String fileName,
  }) async {
    final response = await _api.upload(
      file,
      fileName: fileName,
    );

    return response?.fileName;
  }

  Future<FetchedPiece?> submit({
    required String userId,
    required String templateId,
    required List<String> remoteFileNames,
  }) async {
    final response = await _api.submit(
      SubmitRequest(
        userId: userId,
        templateId: templateId,
        fileNames: remoteFileNames,
      ),
    );

    if (response == null) {
      return null;
    }

    return FetchedPiece(id: response.id, url: response.url);
  }
}

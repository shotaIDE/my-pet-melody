import 'dart:io';

import 'package:meow_music/data/api/submission_api.dart';

class SubmissionRemoteDataSource {
  SubmissionRemoteDataSource({required SubmissionApi api}) : _api = api;

  final SubmissionApi _api;

  Future<void> upload(
    File file, {
    required String fileName,
  }) async {
    return _api.upload(
      file,
      fileName: fileName,
    );
  }

  Future<void> submit({
    required String userId,
  }) async {
    return _api.submit(
      SubmitRequest(userId: userId),
    );
  }
}

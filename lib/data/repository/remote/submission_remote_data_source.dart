import 'dart:io';

import 'package:meow_music/data/api/submission_api.dart';
import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';

class SubmissionRemoteDataSource {
  SubmissionRemoteDataSource({required SubmissionApi api}) : _api = api;

  static const _apiBaseUrl = AppDefinitions.serverOrigin;

  final SubmissionApi _api;

  Future<UploadedSound?> upload(
    File file, {
    required String fileName,
  }) async {
    final response = await _api.upload(
      file,
      fileName: fileName,
    );

    if (response == null) {
      return null;
    }

    return UploadedSound(
      id: response.id,
      extension: response.extension,
      url: '$_apiBaseUrl${response.path}',
    );
  }

  Future<FetchedPiece?> submit({
    required String userId,
    required String templateId,
    required List<UploadedSound> sounds,
  }) async {
    final response = await _api.submit(
      SubmitRequest(
        userId: userId,
        templateId: templateId,
        fileNames:
            sounds.map((sound) => '${sound.id}${sound.extension}').toList(),
      ),
    );

    if (response == null) {
      return null;
    }

    return FetchedPiece(
      id: response.id,
      url: '$_apiBaseUrl${response.path}',
    );
  }
}

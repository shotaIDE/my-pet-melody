import 'dart:io';

import 'package:meow_music/data/api/submission_api.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/fetched_piece.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';

class SubmissionRemoteDataSource {
  SubmissionRemoteDataSource({required SubmissionApi api}) : _api = api;

  final SubmissionApi _api;

  Future<DetectedNonSilentSegments?> detect(
    File file, {
    required String fileName,
  }) async {
    final response = await _api.detect(
      file,
      fileName: fileName,
    );

    if (response == null) {
      return null;
    }

    return DetectedNonSilentSegments(
      list: response.segments
          .map(
            (segment) => NonSilentSegment(
              startMilliseconds: segment.first,
              endMilliseconds: segment[1],
            ),
          )
          .toList(),
      durationMilliseconds: response.durationMilliseconds,
    );
  }

  Future<UploadedSoundDraft?> upload(
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

    return UploadedSoundDraft(
      id: response.id,
      extension: response.extension,
      path: response.path,
    );
  }

  Future<FetchedPieceDraft?> submit({
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

    final id = response.id;
    final path = response.path;
    if (id == null || path == null) {
      return null;
    }

    return FetchedPieceDraft(
      id: id,
      path: path,
    );
  }
}

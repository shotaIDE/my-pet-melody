import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/uploaded_media.dart';
import 'package:meow_music/data/repository/remote/submission_remote_data_source.dart';

class SubmissionRepository {
  SubmissionRepository({required SubmissionRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final SubmissionRemoteDataSource _remote;

  Future<DetectedNonSilentSegments?> detect({
    required UploadedMedia from,
    required String token,
  }) async {
    return _remote.detect(
      from: from,
      token: token,
    );
  }

  Future<void> submit({
    required String templateId,
    required List<UploadedMedia> sounds,
    required String displayName,
    required UploadedMedia thumbnail,
    required String token,
  }) async {
    await _remote.submit(
      templateId: templateId,
      sounds: sounds,
      displayName: displayName,
      thumbnail: thumbnail,
      token: token,
    );
  }
}

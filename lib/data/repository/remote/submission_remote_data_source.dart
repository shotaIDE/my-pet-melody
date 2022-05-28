import 'package:meow_music/data/api/submission_api.dart';
import 'package:meow_music/data/model/detected_non_silent_segments.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';

class SubmissionRemoteDataSource {
  SubmissionRemoteDataSource({required SubmissionApi api}) : _api = api;

  final SubmissionApi _api;

  Future<DetectedNonSilentSegments?> detect({
    required UploadedSound from,
    required String token,
  }) async {
    final response = await _api.detect(
      DetectRequest(
        fileName: '${from.id}${from.extension}',
      ),
      token: token,
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

  Future<void> submit({
    required String templateId,
    required List<UploadedSound> sounds,
    required String token,
  }) async {
    await _api.submit(
      SubmitRequest(
        templateId: templateId,
        fileNames:
            sounds.map((sound) => '${sound.id}${sound.extension}').toList(),
      ),
      token: token,
    );
  }
}

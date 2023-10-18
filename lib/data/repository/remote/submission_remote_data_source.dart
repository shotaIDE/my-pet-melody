import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/api/submission_api.dart';
import 'package:my_pet_melody/data/model/movie_segmentation.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';

final submissionRemoteDataSourceProvider = Provider(
  (ref) => SubmissionRemoteDataSource(
    api: ref.watch(submissionApiProvider),
  ),
);

class SubmissionRemoteDataSource {
  SubmissionRemoteDataSource({required SubmissionApi api}) : _api = api;

  final SubmissionApi _api;

  Future<MovieSegmentation?> detect({
    required UploadedMedia from,
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

    return MovieSegmentation(
      nonSilents: response.detectedSegments
          .map(
            (segment) => NonSilentSegment(
              thumbnailBase64: segment.thumbnailBase64,
              startMilliseconds: segment.startMilliseconds,
              endMilliseconds: segment.endMilliseconds,
            ),
          )
          .toList(),
      equallyDividedThumbnailsBase64: response.equallyDividedSegments
          .map((segment) => segment.thumbnailBase64)
          .toList(),
      durationMilliseconds: response.durationMilliseconds,
    );
  }

  Future<void> submit({
    required String templateId,
    required List<UploadedMedia> sounds,
    required String displayName,
    required UploadedMedia thumbnail,
    required String token,
    required String purchaseUserId,
  }) async {
    await _api.submit(
      SubmitRequest(
        templateId: templateId,
        soundFileNames:
            sounds.map((sound) => '${sound.id}${sound.extension}').toList(),
        displayName: displayName,
        thumbnailFileName: '${thumbnail.id}${thumbnail.extension}',
      ),
      token: token,
      purchaseUserId: purchaseUserId,
    );
  }
}

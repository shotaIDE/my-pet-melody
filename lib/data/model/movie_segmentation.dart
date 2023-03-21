import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_segmentation.freezed.dart';

@freezed
class MovieSegmentation with _$MovieSegmentation {
  const factory MovieSegmentation({
    required List<NonSilentSegment> nonSilents,
    required List<String> equallyDividedThumbnailsBase64,
    required int durationMilliseconds,
  }) = _MovieSegmentation;
}

@freezed
class NonSilentSegment with _$NonSilentSegment {
  const factory NonSilentSegment({
    required String thumbnailBase64,
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _NonSilentSegment;
}

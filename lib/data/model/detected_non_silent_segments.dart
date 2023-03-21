import 'package:freezed_annotation/freezed_annotation.dart';

part 'detected_non_silent_segments.freezed.dart';

@freezed
class DetectedNonSilentSegments with _$DetectedNonSilentSegments {
  const factory DetectedNonSilentSegments({
    required List<NonSilentSegment> list,
    required List<String> equallyDividedSegmentThumbnailsBase64,
    required int durationMilliseconds,
  }) = _DetectedNonSilentSegments;
}

@freezed
class NonSilentSegment with _$NonSilentSegment {
  const factory NonSilentSegment({
    required String thumbnailBase64,
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _NonSilentSegment;
}

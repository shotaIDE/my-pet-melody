import 'package:freezed_annotation/freezed_annotation.dart';

part 'detected_non_silent_segments.freezed.dart';

@freezed
class DetectedNonSilentSegments with _$DetectedNonSilentSegments {
  const factory DetectedNonSilentSegments({
    required List<NonSilentSegment> list,
    required int durationMilliseconds,
  }) = _DetectedNonSilentSegments;
}

@freezed
class NonSilentSegment with _$NonSilentSegment {
  const factory NonSilentSegment({
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _NonSilentSegment;
}
